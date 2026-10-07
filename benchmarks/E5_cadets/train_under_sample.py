"""
UNDER-SAMPLE trainer for the byte-level E5_cadets KAN.

Data (built by build_undersample.py, in data_us/):
  * TRAIN  : balanced 50/50 by random benign under-sampling  (~2.35M events)
  * TEST   : REAL deployment ratio (~0.76% malicious)         (~38.4M events)

Inputs are raw bytes fed as float 0..255 (NO /255): the input BatchNorm
standardises each feature, so byte scale is irrelevant, and raw bytes are the
natural 8-bit LUT address for the hardware fold.

Because the test set is ~38M events, we do NOT evaluate it every epoch. Each
epoch validates on a small real-ratio MONITOR subset; the full 38M test is
evaluated ONCE at the end -> the honest deployment number (P / R / F1 / PR-AUC /
ROC-AUC + confusion matrix).

Usage:
  python train_under_sample.py [--epochs 20] [--data_dir data_us] [--monitor_n 400000]
"""
import sys, os, json, argparse, logging
from datetime import datetime

sys.path.append('../../src')
from KANQuant import KANQuant
from quant import QuantBrevitasActivation, ScalarBiasScale

import numpy as np
import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import TensorDataset, DataLoader
from sklearn.metrics import roc_auc_score, average_precision_score, precision_recall_curve
from tqdm import tqdm

from brevitas.nn import QuantHardTanh
from brevitas.core.scaling import ParameterScaling
from brevitas.core.quant import QuantType

seed = 4332142
torch.manual_seed(seed); np.random.seed(seed)
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

ap = argparse.ArgumentParser()
ap.add_argument('--epochs', type=int, default=20)
ap.add_argument('--data_dir', default='data_us')
ap.add_argument('--monitor_n', type=int, default=400_000,
                help='real-ratio test subset size used for per-epoch validation')
args = ap.parse_args()

# === Configuration: same model as train_quant_poc.py (only data + epochs differ) ===
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
    "num_epochs": args.epochs,
    "learning_rate": 1e-3,
    "weight_decay": 1e-4,
    "prune_threshold": 0.7,
    "target_epoch": 12,
    "warmup_epochs": 5,
    "random_seed": seed,
}

model_dir = f'models/{datetime.now().strftime("%Y%m%d_%H%M%S")}_undersample'
os.makedirs(model_dir, exist_ok=True)
with open(f'{model_dir}/config.json', 'w') as f:
    json.dump(config, f)

logging.basicConfig(filename=f'{model_dir}/training.log', filemode='w', level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s')
console = logging.StreamHandler(); console.setLevel(logging.INFO)
console.setFormatter(logging.Formatter('%(message)s')); logging.getLogger().addHandler(console)

# === Input layer (identical to the PoC/full pipeline) ===
bn_in = nn.BatchNorm1d(config["layers"][0])
nn.init.constant_(bn_in.weight.data, 1); nn.init.constant_(bn_in.bias.data, 0)
input_bias = ScalarBiasScale(scale=False, bias_init=-0.25)
input_layer = QuantBrevitasActivation(
    QuantHardTanh(bit_width=config["layers_bitwidth"][0], max_val=1.0, min_val=-1.0,
                  act_scaling_impl=ParameterScaling(1.33), quant_type=QuantType.INT,
                  return_quant_tensor=False),
    pre_transforms=[bn_in, input_bias], cuda=device.type == "cuda").to(device)

# === Data (uint8 bytes; fed as float 0..255, no /255) ===
data_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), args.data_dir)
def load_u8(split):
    X = torch.from_numpy(np.load(f'{data_dir}/X_{split}.npy'))      # uint8 [N,64]
    y = torch.from_numpy(np.load(f'{data_dir}/y_{split}.npy')).long()  # {0,1}
    return X, y

Xtr, ytr = load_u8('train')
Xte, yte = load_u8('test')
logging.info(f"train {tuple(Xtr.shape)} balance {torch.bincount(ytr).tolist()} | "
             f"test {tuple(Xte.shape)} balance {torch.bincount(yte).tolist()} "
             f"({100*yte.float().mean():.3f}% mal)")

# Split the real-ratio pool into a VALIDATION set (per-epoch monitoring +
# best-checkpoint selection) and a DISJOINT TEST set (touched once, at the end).
# X_test is already shuffled by the builder, so a prefix slice is a random draw.
n_val = min(args.monitor_n, len(yte) // 2)
Xval, yval = Xte[:n_val], yte[:n_val]
Xtest, ytest = Xte[n_val:], yte[n_val:]
logging.info(f"val {tuple(Xval.shape)} ({100*yval.float().mean():.3f}% mal, {int(yval.sum())} mal) | "
             f"test {tuple(Xtest.shape)} ({100*ytest.float().mean():.3f}% mal, {int(ytest.sum())} mal)")

trainloader = DataLoader(TensorDataset(Xtr, ytr), batch_size=config["batch_size"], shuffle=True)
valloader   = DataLoader(TensorDataset(Xval, yval), batch_size=4096, shuffle=False)
testloader  = DataLoader(TensorDataset(Xtest, ytest), batch_size=4096, shuffle=False)

# === Model / optim / loss (train is 50/50 -> plain CE; weights ~1:1) ===
model = KANQuant(config, input_layer, device).to(device)
optimizer = optim.AdamW(model.parameters(), lr=config["learning_rate"], weight_decay=config["weight_decay"])
scheduler = optim.lr_scheduler.ExponentialLR(optimizer, gamma=0.998)
counts = torch.bincount(ytr, minlength=2).float()
class_weights = (counts.sum() / (2.0 * counts)).to(device)
criterion = nn.CrossEntropyLoss(weight=class_weights)


def scores_and_truth(loader):
    """Malicious-class probability + label for every event in the loader."""
    model.eval(); S = []; T = []
    with torch.no_grad():
        for inputs, labels in loader:
            inputs = inputs.to(device).float()          # raw bytes 0..255
            output = model(inputs)
            S.append(torch.softmax(output, 1)[:, 1].cpu())
            T.append(labels)
    return torch.cat(S).numpy(), torch.cat(T).numpy()

def metrics_at(s, t, tau):
    """Confusion metrics when calling 'malicious' iff score >= tau."""
    pred = (s >= tau)
    tp = int((pred & (t == 1)).sum()); fp = int((pred & (t == 0)).sum())
    tn = int((~pred & (t == 0)).sum()); fn = int((~pred & (t == 1)).sum())
    acc = (tp + tn) / max(tp + tn + fp + fn, 1)
    precision = tp / max(tp + fp, 1); recall = tp / max(tp + fn, 1)
    f1 = 2 * precision * recall / max(precision + recall, 1e-9)
    return dict(threshold=float(tau), tp=tp, fp=fp, tn=tn, fn=fn,
                acc=acc, precision=precision, recall=recall, f1=f1)


# === Training loop ===
best_prauc = -1.0   # select checkpoint by threshold-free PR-AUC on real-ratio val
for epoch in range(config["num_epochs"]):
    model.train(); epoch_loss = 0.0; nb = 0
    with tqdm(trainloader, desc=f"epoch {epoch+1}/{config['num_epochs']}") as pbar:
        for inputs, labels in pbar:
            inputs = inputs.to(device).float()          # raw bytes 0..255, no /255
            labels = labels.to(device)
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

    # per-epoch: real-ratio val. Monitor argmax metrics; SELECT by PR-AUC (threshold-free).
    sv, tv = scores_and_truth(valloader)
    prauc = average_precision_score(tv, sv)
    m = metrics_at(sv, tv, 0.5)
    scheduler.step()
    logging.info(f"Epoch {epoch+1:02d} | TrainLoss {avg_train_loss:.4f} | "
                 f"[val] PR-AUC {prauc:.4f} | @0.5 P {m['precision']:.4f} R {m['recall']:.4f} "
                 f"F1 {m['f1']:.4f} (TP {m['tp']} FP {m['fp']} FN {m['fn']}) | Remaining {remaining_fraction:.4f}")

    torch.save({'epoch': epoch + 1, 'model_state_dict': model.state_dict(),
                'remaining_fraction': remaining_fraction, 'val_prauc': prauc, 'val_at_0.5': m},
               f'{model_dir}/NID_last.pt')
    if prauc > best_prauc:
        best_prauc = prauc
        torch.save({'epoch': epoch + 1, 'model_state_dict': model.state_dict(),
                    'remaining_fraction': remaining_fraction, 'val_prauc': prauc, 'val_at_0.5': m},
                   f'{model_dir}/NID_best.pt')

# === FINAL: recalibrate threshold on val, then evaluate the touched-once test ===
best = torch.load(f'{model_dir}/NID_best.pt', weights_only=False)
model.load_state_dict(best['model_state_dict'])
logging.info(f"loaded best checkpoint (epoch {best['epoch']}, val PR-AUC {best['val_prauc']:.4f})")

# tune threshold on real-ratio VAL to maximise F1 (undersampling miscalibrates 0.5)
sv, tv = scores_and_truth(valloader)
prec, rec, thr = precision_recall_curve(tv, sv)
f1s = 2 * prec * rec / np.clip(prec + rec, 1e-9, None)
tau = float(thr[int(np.nanargmax(f1s[:-1]))]) if len(thr) else 0.5
logging.info(f"tuned threshold on val: tau={tau:.4f} (val F1={np.nanmax(f1s[:-1]):.4f})")

# full test, ONCE
st, tt = scores_and_truth(testloader)
roc = roc_auc_score(tt, st); pr = average_precision_score(tt, st)
res = {"n": int(len(tt)), "prior_mal": float(tt.mean()), "roc_auc": roc, "pr_auc": pr,
       "at_0.5": metrics_at(st, tt, 0.5), "at_tuned": metrics_at(st, tt, tau)}
logging.info(f"=== FINAL full test | N {len(tt):,} ({100*tt.mean():.3f}% mal) | "
             f"ROC-AUC {roc:.4f} PR-AUC {pr:.4f} ===")
for name in ("at_0.5", "at_tuned"):
    r = res[name]
    logging.info(f"  [{name} tau={r['threshold']:.3f}] P {r['precision']:.4f} R {r['recall']:.4f} "
                 f"F1 {r['f1']:.4f} | TP {r['tp']:,} FP {r['fp']:,} FN {r['fn']:,} TN {r['tn']:,}")
with open(f'{model_dir}/final_test_report.json', 'w') as f:
    json.dump(res, f, indent=2)
print(f"Done. model + report in {model_dir}")
