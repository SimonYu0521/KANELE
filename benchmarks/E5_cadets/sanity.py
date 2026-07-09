"""Single-byte benign-vs-malicious separability for the E5_cadets byte layout."""
import os, numpy as np
d = os.path.dirname(os.path.abspath(__file__))
X = np.load(f"{d}/data/X_train.npy"); y = np.load(f"{d}/data/y_train.npy").argmax(1)
rng = np.random.default_rng(7)
k = min((y == 0).sum(), (y == 1).sum(), 400000)
idx = np.concatenate([rng.choice(np.where(y == 0)[0], k, replace=False),
                      rng.choice(np.where(y == 1)[0], k, replace=False)])
B = np.rint(X[idx] * 255).astype(int); Y = y[idx]

def field(o):
    return "syscall" if o < 8 else "object_type" if o < 12 else "exe" if o < 28 else "path"

rows = []
for o in range(64):
    b = B[:, o]
    c0 = np.bincount(b[Y == 0], minlength=256).astype(float)
    c1 = np.bincount(b[Y == 1], minlength=256).astype(float)
    rows.append((np.maximum(c0, c1).sum() / len(Y), o))
rows.sort(reverse=True)
print(f"balanced {k:,}/class | 0.50 useless, 1.00 perfect single-byte shortcut\n")
print(f"{'off':>3} {'field':12s} {'acc':>6}")
for acc, o in rows[:18]:
    flag = "  <== GIVEAWAY" if acc >= 0.80 else ("  <- strong" if acc >= 0.65 else "")
    print(f"{o:>3} {field(o):12s} {acc:6.3f}{flag}")
