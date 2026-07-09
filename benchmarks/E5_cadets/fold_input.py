"""
Fold the per-feature input transform (BatchNorm + bias + HardTanh + quant) into
the FIRST-layer LUTs, so the hardware consumes RAW bytes directly (din = packed
byte, no preprocessing).

How: each layer-0 connection LUT lut_0_j_k.mem has 256 lines, line i = LUT value
at input index din=i. The map raw_byte -> din for feature j is fixed after
training (call it idx[b,j]). We rewrite the mem so line b (raw byte) holds what
used to be at line idx[b,j]:  folded[b] = original[idx[b,j]].  Pure permutation
of 256 lines -> same LUT size, zero extra hardware, no retrain. Layers >=1 are
untouched (their inputs are already internal LUT indices).

Also regenerates the sim test vectors with RAW bytes as din (doubles as a
real-data check, drawn from X_test). Run in kanele env.
"""
import os, sys, json, glob, shutil
import numpy as np, torch, torch.nn as nn
sys.path.append('../../src')
from KAN_LUT import KAN_LUT
from KANQuant import KANQuant
from quant import QuantBrevitasActivation, ScalarBiasScale
from brevitas.nn import QuantHardTanh
from brevitas.core.scaling import ParameterScaling
from brevitas.core.quant import QuantType

MDIR = "models/20260708_150047_poc"
dev = torch.device("cpu")
cfg = json.load(open(f"{MDIR}/config.json"))
pt = sorted(glob.glob(f"{MDIR}/*.pt"), key=lambda x: float(x.split('_acc')[1].split('_epoch')[0]))[-1]
ck = torch.load(pt, map_location=dev, weights_only=False)

# input layer (identical construction to training) -> gets trained stats via KAN_LUT load
bn = nn.BatchNorm1d(cfg["layers"][0]); nn.init.constant_(bn.weight, 1); nn.init.constant_(bn.bias, 0)
il = QuantBrevitasActivation(
    QuantHardTanh(bit_width=cfg["layers_bitwidth"][0], max_val=1.0, min_val=-1.0,
                  act_scaling_impl=ParameterScaling(1.33), quant_type=QuantType.INT,
                  return_quant_tensor=False),
    pre_transforms=[bn, ScalarBiasScale(scale=False, bias_init=-0.25)], cuda=False)
kl = KAN_LUT(MDIR, ck, cfg, il, dev)          # loads model+truth_tables; il now has trained stats
il.eval()

scale, bits = il.get_scale_factor_bits(False)
scale = float(scale); bits = int(bits); OFF = 2 ** (bits - 1)

def to_din(x_float):  # replicate the hardware input index exactly
    q = il(x_float)
    return (q / scale).round().to(torch.int64) + OFF

# --- per-feature byte -> din map, idx[b, j] in 0..255 ---
probe = (torch.arange(256).float().unsqueeze(1).repeat(1, cfg["layers"][0])) / 255.0
idx = to_din(probe).numpy()                    # (256, 64)
assert idx.min() >= 0 and idx.max() <= 255

# --- permute the layer-0 mem files ---
mem_dir = f"{MDIR}/firmware/mem"
backup = f"{mem_dir}/prefold_layer0"
os.makedirs(backup, exist_ok=True)
n_folded = 0
for f in glob.glob(f"{mem_dir}/lut_0_*.mem"):
    name = os.path.basename(f)
    j = int(name.split("_")[2])                # lut_0_<j>_<k>.mem
    shutil.copy(f, os.path.join(backup, name))
    lines = open(f).read().splitlines()
    assert len(lines) == 256, f"{name}: {len(lines)} lines"
    folded = [lines[idx[b, j]] for b in range(256)]
    open(f, "w").write("\n".join(folded) + "\n")
    n_folded += 1
print(f"folded {n_folded} layer-0 mem files (backup in {backup}/)")

# --- regenerate sim vectors with RAW bytes (from real X_test) ---
X = np.load("data/X_test.npy")                 # byte/255
raw = np.rint(X[:10] * 255).astype(np.int64)   # 10 real events, raw bytes 0..255
din = to_din(torch.from_numpy(raw).float() / 255.0)
outs = [kl._inference_sample(din[i]) for i in range(len(din))]
sim = f"{MDIR}/firmware/sim"
with open(f"{sim}/vectors_in.txt", "w") as fi:
    for r in raw.tolist(): fi.write(" ".join(str(int(v)) for v in r) + "\n")
with open(f"{sim}/vectors_out.txt", "w") as fo:
    for r in torch.stack(outs).to(torch.int64).tolist(): fo.write(" ".join(str(int(v)) for v in r) + "\n")
print(f"wrote {len(raw)} RAW-byte test vectors (din now = packed bytes) to {sim}/")
