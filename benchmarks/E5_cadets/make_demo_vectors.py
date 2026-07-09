"""
Pick 30 real held-out E5_cadets events (15 benign + 15 malicious), write their
RAW packed bytes + true labels for the classification-demo testbench.
Outputs into the firmware sim dir:  demo_in.txt (raw bytes), demo_label.txt (0/1)
"""
import os, numpy as np
HERE = os.path.dirname(os.path.abspath(__file__))
SIM = os.path.join(HERE, "models/20260708_150047_poc/firmware/sim")
X = np.load(f"{HERE}/data/X_test.npy"); y = np.load(f"{HERE}/data/y_test.npy").argmax(1)

rng = np.random.default_rng(0)
sel = np.concatenate([rng.choice(np.where(y == 0)[0], 15, replace=False),
                      rng.choice(np.where(y == 1)[0], 15, replace=False)])
rng.shuffle(sel)
raw = np.rint(X[sel] * 255).astype(int)        # raw bytes 0..255
lab = y[sel].astype(int)

with open(f"{SIM}/demo_in_hex.txt", "w") as fx:      # hex bytes — read by the VHDL testbench (hread)
    for r in raw.tolist(): fx.write(" ".join(f"{int(v):02x}" for v in r) + "\n")
with open(f"{SIM}/demo_label.txt", "w") as fl:
    for v in lab.tolist(): fl.write(f"{v}\n")

def dec(r, a, b): return bytes(r[a:b].astype(np.uint8)).rstrip(b"\0").decode("ascii", "ignore")
print(f"wrote 30 demo vectors -> {SIM}/demo_in_hex.txt (hex), demo_label.txt\n")
print(f"{'#':>2} {'true':10s} {'syscall':8s} {'exe':12s} path")
for i, r in enumerate(raw):
    print(f"{i:>2} {'MALICIOUS' if lab[i] else 'BENIGN':10s} "
          f"{dec(r,0,8):8s} {dec(r,12,28):12s} {dec(r,28,64)}")
