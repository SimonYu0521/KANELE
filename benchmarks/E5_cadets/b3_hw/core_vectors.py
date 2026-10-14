"""Diverse raw-byte vectors for the generated core testbenches (tb_kan / tb_kan_latency):
20 malicious + 20 benign real B3 test rows, golden from the bit-exact folded-LUT model;
the first two have different outputs so the latency testbench can measure."""
import os, sys, numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import hw_reference as R
E5 = os.path.dirname(HERE)
X = np.load(f"{E5}/data_us_b3/X_test.npy", mmap_mode="r"); y = np.load(f"{E5}/data_us_b3/y_test.npy")
rng = np.random.default_rng(1)
rows = np.concatenate([rng.choice(np.where(y == 1)[0], 20, replace=False), rng.choice(np.where(y == 0)[0], 20, replace=False)])
rng.shuffle(rows)
Xs = np.asarray(X[np.sort(rows)]); out = R.kan_int(Xs, R.load_luts())
k = next(i for i in range(1, len(out)) if (out[i] != out[0]).any())
order = [0, k] + [i for i in range(len(out)) if i not in (0, k)]
sim = os.path.join(R.FW, "sim")
open(f"{sim}/vectors_in.txt", "w").write("".join(" ".join(map(str, Xs[i])) + "\n" for i in order))
open(f"{sim}/vectors_out.txt", "w").write("".join(" ".join(map(str, out[i])) + "\n" for i in order))
print(f"wrote {len(order)} vectors; distinct outputs: {len({tuple(o) for o in out})}; first two: {out[0]} {out[k]}")
