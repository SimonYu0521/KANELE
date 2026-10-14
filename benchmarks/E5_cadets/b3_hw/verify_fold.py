#!/usr/bin/env python3
"""Prove the folded B3 core == the trained model, on every distinct test pattern.
  (1) folded .mem model (raw byte addressed)  == KAN_LUT integer reference on to_din(byte)   [2,000 rows]
  (2) folded .mem model * last_scale          == trained PyTorch model logits               [all unique test rows]
Also derives the output scale s_out used to map a probability threshold tau to an integer
logit-difference threshold T (forward iff logit_mal - logit_ben >= T)."""
import os, sys, json, math
import numpy as np, torch
HERE = os.path.dirname(os.path.abspath(__file__)); E5 = os.path.dirname(HERE)
sys.path.insert(0, HERE); sys.path.insert(0, E5); sys.path.append(os.path.join(E5, "../../src"))
os.chdir(E5)
import hw_reference as R
sys.argv = ["eval_b2.py", R.MODEL, "--enc=b3"]
import eval_b2 as E
from KAN_LUT import KAN_LUT
from quant import QuantBrevitasActivation, ScalarBiasScale
from brevitas.nn import QuantHardTanh
from brevitas.core.scaling import ParameterScaling
from brevitas.core.quant import QuantType
import torch.nn as nn

luts = R.load_luts()
print(f"folded LUTs: layer0 {len(luts[0])}, layer1 {len(luts[1])}", flush=True)

# (1) vs KAN_LUT integer reference (index domain, original truth tables)
cfg = json.load(open(f"{R.MODEL}/config.json"))
ck = torch.load(f"{R.MODEL}/NID_best.pt", map_location="cpu", weights_only=False)
bn = nn.BatchNorm1d(64); nn.init.constant_(bn.weight, 1); nn.init.constant_(bn.bias, 0)
il = QuantBrevitasActivation(QuantHardTanh(bit_width=8, max_val=1.0, min_val=-1.0, act_scaling_impl=ParameterScaling(1.33),
     quant_type=QuantType.INT, return_quant_tensor=False), pre_transforms=[bn, ScalarBiasScale(scale=False, bias_init=-0.25)], cuda=False)
kl = KAN_LUT(R.MODEL, ck, cfg, il, torch.device("cpu")); il.eval()
sc, bits = il.get_scale_factor_bits(False); sc = float(sc); OFF = 2 ** (int(bits) - 1)
X = np.load("data_us_b3/X_test.npy", mmap_mode="r")
rng = np.random.default_rng(0); rows = np.sort(rng.choice(len(X), 2000, replace=False))
Xs = np.asarray(X[rows])
din = ((il(torch.from_numpy(Xs).float()) / sc).round().to(torch.int64) + OFF)
ref = np.stack([kl._inference_sample(d).numpy() for d in din])
hw = R.kan_int(Xs, luts)
print(f"(1) folded-mem model vs KAN_LUT reference on {len(rows):,} rows: {int((ref != hw).any(1).sum())} mismatching rows", flush=True)

# (2) vs the trained PyTorch model on every unique test pattern
y = np.load("data_us_b3/y_test.npy")
U, inv, nb, nm = E.unique_counts(np.asarray(X), y)
model = E.load_model(R.MODEL)
with torch.no_grad():
    lg = np.concatenate([model(torch.from_numpy(U[i:i + 65536].astype(np.float32))).double().numpy() for i in range(0, len(U), 65536)])
hwU = R.kan_int(U, luts)
s_out = float(model.layers[-1].output_quantizer.get_scale_factor_bits(False)[0])
err = np.abs(lg - hwU * s_out).max()
am = int(((lg[:, 1] >= lg[:, 0]) != (hwU[:, 1] >= hwU[:, 0])).sum())
print(f"(2) {len(U):,} unique test patterns: max|model_logit - hw_int*s_out| = {err:.3e};  argmax disagreements: {am}", flush=True)
d = hwU[:, 1] - hwU[:, 0]
print(f"output scale s_out = {s_out:.6f};  hw logit-difference range d in [{d.min()}, {d.max()}]", flush=True)
print("tau -> integer threshold T (forward iff d >= T):")
for tau in (0.5, 0.1, 0.01, 0.001):
    print(f"   tau={tau:<6} T = ceil(logit(tau)/s_out) = {math.ceil(math.log(tau / (1 - tau)) / s_out)}")
print(f"   floor  : T = {d.min() + 1}  (drop only the minimum-score point mass d = {d.min()})")
json.dump(dict(s_out=s_out, d_min=int(d.min()), d_max=int(d.max()), unique=len(U),
               max_abs_logit_err=float(err), argmax_disagree=am), open(os.path.join(HERE, "fold_verify.json"), "w"), indent=2)
print("VERIFYFOLDDONE")
