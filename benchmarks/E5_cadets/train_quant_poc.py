# === CPU proof-of-concept trainer for the UNSW-NB15 byte-level NID KAN ===
# Same model/pipeline as train_quant.py, but tuned to actually finish on CPU:
#   * balanced subsample (drawn WITHIN the existing flow-split -> no leakage)
#   * lighter grid/spline, fewer epochs, bigger batch
# The full-scale train_quant.py is left untouched for a GPU run later.
import sys, os, logging
from datetime import datetime

sys.path.append('../../src')
from KANQuant import KANQuant
from quant import QuantBrevitasActivation, ScalarBiasScale

import numpy as np
import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import TensorDataset, DataLoader
from sklearn.metrics import roc_curve, auc
from tqdm import tqdm
import json

from brevitas.nn import QuantHardTanh, QuantIdentity
from brevitas.core.scaling import ParameterScaling
from brevitas.core.quant import QuantType

seed = 4332142
torch.manual_seed(seed); np.random.seed(seed)
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# --- PoC subsample sizes (per class, capped by availability) ---
POC_TRAIN_PER_CLASS = 150_000
POC_TEST_PER_CLASS  = 30_000

logging.basicConfig(filename='training_poc.log', filemode='w', level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s')
console = logging.StreamHandler(); console.setLevel(logging.INFO)
console.setFormatter(logging.Formatter('%(message)s')); logging.getLogger().addHandler(console)

# === Configuration: matches train_quant.py exactly, except num_epochs.
# Only difference from the full run is the balanced subsample below (CPU feasibility).
config = {
    "seed": seed,
    "layers": [64, 16, 2],
    "grid_range": [-2, 2],
    "layers_bitwidth": [8, 6, 6],

    "grid_size": 40,
    "spline_order": 10,
    "grid_eps": 0.05,

    "base_activation": "nn.SiLU",

    "batch_size": 512,
    "num_epochs": 50,         # full run uses 700

    "learning_rate": 1e-3,
    "weight_decay": 1e-4,

    "prune_threshold": 0.7,
    "target_epoch": 12,
    "warmup_epochs": 5,
    "random_seed": seed,
}

model_dir = f'models/{datetime.now().strftime("%Y%m%d_%H%M%S")}_poc'
os.makedirs(model_dir, exist_ok=True)
with open(f'{model_dir}/config.json', 'w') as f:
    json.dump(config, f)

# === Input layer ===
bn_in = nn.BatchNorm1d(config["layers"][0])
nn.init.constant_(bn_in.weight.data, 1); nn.init.constant_(bn_in.bias.data, 0)
input_bias = ScalarBiasScale(scale=False, bias_init=-0.25)
input_layer = QuantBrevitasActivation(
    QuantHardTanh(bit_width=config["layers_bitwidth"][0], max_val=1.0, min_val=-1.0,
                  act_scaling_impl=ParameterScaling(1.33), quant_type=QuantType.INT,
                  return_quant_tensor=False),
    pre_transforms=[bn_in, input_bias], cuda=device.type == "cuda").to(device)

# === Load full data, then balanced-subsample within each split ===
data_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data')
def load(split):
    X = torch.from_numpy(np.load(os.path.join(data_dir, f'X_{split}.npy'))).float()
    y = torch.from_numpy(np.load(os.path.join(data_dir, f'y_{split}.npy'))).float().argmax(dim=1)
    return X, y

def balanced_subsample(X, y, per_class, rng):
    idxs = []
    for cls in (0, 1):
        pool = np.where(y.numpy() == cls)[0]
        take = min(per_class, len(pool))
        idxs.append(rng.choice(pool, size=take, replace=False))
    sel = np.concatenate(idxs); rng.shuffle(sel)
    return X[sel], y[sel]

rng = np.random.default_rng(seed)
Xtr, ytr = load('train'); Xte, yte = load('test')
Xtr, ytr = balanced_subsample(Xtr, ytr, POC_TRAIN_PER_CLASS, rng)
Xte, yte = balanced_subsample(Xte, yte, POC_TEST_PER_CLASS, rng)
logging.info(f"PoC train {tuple(Xtr.shape)} balance {torch.bincount(ytr).tolist()} | "
             f"test {tuple(Xte.shape)} balance {torch.bincount(yte).tolist()}")

trainloader = DataLoader(TensorDataset(Xtr, ytr), batch_size=config["batch_size"], shuffle=True)
testloader  = DataLoader(TensorDataset(Xte, yte), batch_size=config["batch_size"], shuffle=False)

# === Model / optim / loss ===
model = KANQuant(config, input_layer, device).to(device)
optimizer = optim.AdamW(model.parameters(), lr=config["learning_rate"], weight_decay=config["weight_decay"])
scheduler = optim.lr_scheduler.ExponentialLR(optimizer, gamma=0.998)
counts = torch.bincount(ytr, minlength=2).float()
class_weights = (counts.sum() / (2.0 * counts)).to(device)   # ~1:1 here, kept for safety
criterion = nn.CrossEntropyLoss(weight=class_weights)

# === Training loop ===
for epoch in range(config["num_epochs"]):
    model.train(); epoch_loss = 0.0; nb = 0
    with tqdm(trainloader, desc=f"epoch {epoch+1}/{config['num_epochs']}") as pbar:
        for inputs, labels in pbar:
            inputs, labels = inputs.to(device), labels.to(device)
            optimizer.zero_grad()
            output = model(inputs)
            loss = criterion(output, labels)
            loss.backward(); optimizer.step()
            epoch_loss += loss.item(); nb += 1
            acc = (output.argmax(1) == labels).float().mean()
            pbar.set_postfix(loss=loss.item(), acc=acc.item())
    avg_train_loss = epoch_loss / max(nb, 1)

    remaining_fraction = model.prune_below_threshold(
        threshold=config["prune_threshold"], epoch=epoch,
        target_epoch=config["target_epoch"], warmup_epochs=config["warmup_epochs"])

    # Validation with imbalance-aware metrics
    model.eval(); val_loss = 0.0; tp = fp = tn = fn = 0; scores, truth = [], []
    with torch.no_grad():
        for inputs, labels in testloader:
            inputs, labels = inputs.to(device), labels.to(device)
            output = model(inputs)
            val_loss += criterion(output, labels).item()
            pred = output.argmax(1)
            tp += ((pred == 1) & (labels == 1)).sum().item()
            fp += ((pred == 1) & (labels == 0)).sum().item()
            tn += ((pred == 0) & (labels == 0)).sum().item()
            fn += ((pred == 0) & (labels == 1)).sum().item()
            scores.append(torch.softmax(output, 1)[:, 1].cpu()); truth.append(labels.cpu())
    val_loss /= len(testloader)
    acc = (tp + tn) / max(tp + tn + fp + fn, 1)
    precision = tp / max(tp + fp, 1); recall = tp / max(tp + fn, 1)
    f1 = 2 * precision * recall / max(precision + recall, 1e-9)
    try:
        fpr, tpr, _ = roc_curve(torch.cat(truth).numpy(), torch.cat(scores).numpy())
        val_auc = auc(fpr, tpr)
    except Exception:
        val_auc = float("nan")
    scheduler.step()

    logging.info(f"Epoch {epoch+1:02d} | TrainLoss {avg_train_loss:.4f} | ValLoss {val_loss:.4f} | "
                 f"Acc {acc:.4f} P {precision:.4f} R {recall:.4f} F1 {f1:.4f} AUC {val_auc:.4f} | "
                 f"Remaining {remaining_fraction:.4f}")

    torch.save({'epoch': epoch + 1, 'model_state_dict': model.state_dict(),
                'optimizer_state_dict': optimizer.state_dict(),
                'val_accuracy': acc, 'val_loss': val_loss, 'val_auc': val_auc,
                'remaining_fraction': remaining_fraction},
               f'{model_dir}/NID_acc{acc:.4f}_epoch{epoch+1}_remaining{remaining_fraction:.4f}.pt')
print(f"Done. checkpoints in {model_dir}")
