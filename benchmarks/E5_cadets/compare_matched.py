#!/usr/bin/env python3
"""FN at MATCHED forwarded % (filter rate) on the touched-once test set, for several models.
  python compare_matched.py name:model_dir:data_dir [name:model_dir:data_dir ...]
Writes MATCHED_FN.md."""
import sys, os
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); os.chdir(HERE); sys.path.insert(0, HERE)
specs = [a.split(":") for a in sys.argv[1:]]
sys.argv = ["eval_b2.py", specs[0][1]]
import eval_b2 as E

def curve(model_dir, data_dir):
    m = E.load_model(model_dir)
    X = np.load(f"{data_dir}/X_test.npy")[E.N_VAL:]; y = np.load(f"{data_dir}/y_test.npy")[E.N_VAL:]
    U, inv, nb, nm = E.unique_counts(X, y)
    su = E.score(m, U)
    o = np.argsort(-su, kind="stable"); s, tot, mal = su[o], (nb + nm)[o], nm[o]
    last = np.r_[s[1:] != s[:-1], True]                       # a threshold can only cut between distinct scores
    ct, cm = np.cumsum(tot)[last], np.cumsum(mal)[last]
    return ct / tot.sum() * 100, int(nm.sum()) - cm, int(nm.sum())

res = {n: curve(md, dd) for n, md, dd in specs}
names = [n for n, _, _ in specs]
targets = [0.80, 0.85, 0.90, 1.0, 1.25, 1.5, 2.0, 3.0, 4.19, 6.0, 9.16]
L = ["# FN at matched forwarded % (touched-once test, 37.97M events, 290,144 malicious)", "",
     "| forwarded <= % | " + " | ".join(f"{n} FN (fwd%)" for n in names) + " |", "|--:|" + "--:|" * len(names)]
for t in targets:
    cells = []
    for n in names:
        fwd, fn, M = res[n]; i = np.searchsorted(fwd, t, side="right") - 1
        cells.append(f"{fn[i]:,} ({fwd[i]:.2f})" if i >= 0 else f"{M:,} (0)")
    L.append(f"| {t:.2f} | " + " | ".join(cells) + " |")
L.append("")
for n in names:
    fwd, fn, M = res[n]; j = int(np.argmin(fn[:-1]))
    L.append(f"- **{n}**: lowest FN while still filtering = **{fn[j]}** at {fwd[j]:.2f}% forwarded")
open("MATCHED_FN.md", "w").write("\n".join(L) + "\n")
print("\n".join(L)); print("MATCHEDDONE", flush=True)
