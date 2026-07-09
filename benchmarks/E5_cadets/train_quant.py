# === Imports ===
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
import matplotlib.pyplot as plt
import math

from sklearn.metrics import roc_curve, auc
from tqdm import tqdm
import json

#For quantization
from brevitas.nn import QuantHardTanh, QuantIdentity
from brevitas.core.scaling import ParameterScaling
from brevitas.core.quant import QuantType

#Set the seed
seed = 4332142
torch.manual_seed(seed)
np.random.seed(seed)

#Set the device
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# === Logging Setup ===
os.makedirs('checkpoints', exist_ok=True)
logging.basicConfig(
    filename='training.log',
    filemode='w',
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
console = logging.StreamHandler()
console.setLevel(logging.INFO)
formatter = logging.Formatter('%(message)s')
console.setFormatter(formatter)
logging.getLogger().addHandler(console)

# === Configuration ===
config = {
    "seed": seed,
    # 64 packet-header bytes -> hidden -> 2 classes (benign / attack).
    "layers": [64, 16, 2],
    "grid_range": [-2, 2],
    # Input 8-bit (raw byte resolution); hidden/output 6-bit. MUST match len("layers").
    "layers_bitwidth": [8, 6, 6],

    "grid_size": 40,
    "spline_order": 10,
    "grid_eps": 0.05,

    "base_activation": "nn.SiLU",
    
    "batch_size": 512,
    "num_epochs": 700,

    "learning_rate": 1e-3,
    "weight_decay": 1e-4,

    "prune_threshold": 0.7,
    "target_epoch": 12,
    "warmup_epochs": 5,
    "random_seed": seed,
}

#Create a new directory to save the config and checkpoints
model_dir = f'models/{datetime.now().strftime("%Y%m%d_%H%M%S")}'
os.makedirs(model_dir, exist_ok=True)
with open(f'{model_dir}/config.json', 'w') as f:
    json.dump(config, f)

#Build the input layer
bn_in = nn.BatchNorm1d(config["layers"][0])
nn.init.constant_(bn_in.weight.data, 1)
nn.init.constant_(bn_in.bias.data, 0)
input_bias = ScalarBiasScale(scale=False, bias_init=-0.25)
JSC_input_layer = QuantBrevitasActivation(
    QuantHardTanh(bit_width = config["layers_bitwidth"][0],
    max_val=1.0,
    min_val=-1.0,
    act_scaling_impl=ParameterScaling(1.33),
    quant_type=QuantType.INT,
    return_quant_tensor = False),
    pre_transforms=[bn_in, input_bias],
    cuda=device.type == "cuda").to(device)

# === Load Data ===
data_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data')
# Keep tensors on CPU (dataset is ~2GB); the loops move each batch to device.
X_train = torch.from_numpy(np.load(os.path.join(data_dir, 'X_train.npy'))).float()
y_train = torch.from_numpy(np.load(os.path.join(data_dir, 'y_train.npy'))).float().argmax(dim=1)
X_test = torch.from_numpy(np.load(os.path.join(data_dir, 'X_test.npy'))).float()
y_test = torch.from_numpy(np.load(os.path.join(data_dir, 'y_test.npy'))).float().argmax(dim=1)

# === Create Data Loaders ===
train_dataset = TensorDataset(X_train, y_train)
test_dataset = TensorDataset(X_test, y_test)
trainloader = DataLoader(train_dataset, batch_size=config["batch_size"], shuffle=True)
testloader = DataLoader(test_dataset, batch_size=config["batch_size"], shuffle=False)

# === Initialize Model ===
#Define the model
model = KANQuant(config, JSC_input_layer, device).to(device)

optimizer = optim.AdamW(model.parameters(), lr=config["learning_rate"], weight_decay=config["weight_decay"])
scheduler = optim.lr_scheduler.ExponentialLR(optimizer, gamma=0.998)

# Inverse-frequency class weights (dataset is ~24:1 normal:attack) so the
# minority attack class is not ignored. Without this, accuracy is misleading.
counts = torch.bincount(y_train, minlength=2).float()
class_weights = (counts.sum() / (2.0 * counts)).to(device)
logging.info(f"class counts {counts.tolist()} -> weights {class_weights.tolist()}")
criterion = nn.CrossEntropyLoss(weight=class_weights)

# === Training Loop ===
training_loss = []
testing_loss = []
best_val_accuracy = 0.0
for epoch in range(config["num_epochs"]):
    # Train
    model.train()
    epoch_train_loss = 0  # Initialize loss for the epoch
    total_batches = 0
    with tqdm(trainloader) as pbar:
        for i, (inputs, labels) in enumerate(pbar):
            inputs = inputs.to(device)
            optimizer.zero_grad()
            output = model(inputs)
            loss = criterion(output, labels.to(device))
            loss.backward()
            optimizer.step()

            epoch_train_loss += loss.item()
            total_batches += 1

            accuracy = (output.argmax(dim=1) == labels.to(device)).float().mean()
            pbar.set_postfix(loss=loss.item(), accuracy=accuracy.item(), lr=optimizer.param_groups[0]['lr'])

    
    average_train_loss = epoch_train_loss / total_batches
    training_loss.append(average_train_loss)  # Record the average training loss

    # Prune the model
    remaining_fraction = model.prune_below_threshold(threshold=config["prune_threshold"], epoch=epoch, target_epoch=config["target_epoch"], warmup_epochs=config["warmup_epochs"])
    print(f"Remaining fraction: {remaining_fraction}")

    # Validation
    model.eval()
    val_loss = 0
    tp = fp = tn = fn = 0
    attack_scores, attack_truth = [], []
    with torch.no_grad():
        for inputs, labels in testloader:
            inputs = inputs.to(device)
            labels = labels.to(device)
            output = model(inputs)
            val_loss += criterion(output, labels).item()
            pred = output.argmax(dim=1)
            tp += ((pred == 1) & (labels == 1)).sum().item()
            fp += ((pred == 1) & (labels == 0)).sum().item()
            tn += ((pred == 0) & (labels == 0)).sum().item()
            fn += ((pred == 0) & (labels == 1)).sum().item()
            attack_scores.append(torch.softmax(output, dim=1)[:, 1].cpu())
            attack_truth.append(labels.cpu())
    val_loss /= len(testloader)
    val_accuracy = (tp + tn) / max(tp + tn + fp + fn, 1)
    precision = tp / max(tp + fp, 1)      # of flagged packets, how many are real attacks
    recall = tp / max(tp + fn, 1)         # of real attacks, how many we caught
    f1 = 2 * precision * recall / max(precision + recall, 1e-9)
    try:
        fpr, tpr, _ = roc_curve(torch.cat(attack_truth).numpy(),
                                torch.cat(attack_scores).numpy())
        val_auc = auc(fpr, tpr)
    except Exception:
        val_auc = float("nan")
    testing_loss.append(val_loss)

    # Update learning rate
    scheduler.step()

    logging.info(
        f"Epoch {epoch + 1:02d} | Train Loss: {average_train_loss:.4f} | "
        f"Val Loss: {val_loss:.4f} | Acc: {val_accuracy:.4f} | "
        f"P: {precision:.4f} R: {recall:.4f} F1: {f1:.4f} AUC: {val_auc:.4f} | "
        f"Remaining: {remaining_fraction:.4f}"
    )

    # === Save Checkpoint if Best ===
    #Always save the model
    checkpoint_path = f'{model_dir}/NID_acc{val_accuracy:.4f}_epoch{epoch + 1}_remaining{remaining_fraction:.4f}.pt'
    torch.save({
        'epoch': epoch + 1,
        'model_state_dict': model.state_dict(),
        'optimizer_state_dict': optimizer.state_dict(),
        'val_accuracy': val_accuracy,
        'val_loss': val_loss,
        'remaining_fraction': remaining_fraction,
    }, checkpoint_path)
    logging.info(f"New best model saved with val accuracy: {val_accuracy:.4f}, remaining fraction: {remaining_fraction:.4f}")