#!/usr/bin/env python3
"""TRUE false negatives of one model at its lowest-FN point (tau = floor) on the touched-once test.
  python fn_true.py <model_dir> --enc=p0|b2|b3
For every floor FN, scan ALL 190M benign lines and count
  enc twins : benign events with the identical 64-byte model input
  raw twins : benign events identical in the raw log except event_id/actorID/objectID/hostid/timestampNanos
A TRUE FN has no raw twin. Test rows are mapped back to raw JSON lines by replaying the build RNG split
(verified by re-encoding every malicious test row). Writes FN_TRUE_<ENC>.txt."""
import os, sys, gzip, json, collections
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); os.chdir(HERE); sys.path.insert(0, HERE)
MODEL = sys.argv[1]
ENC = next((a.split("=", 1)[1] for a in sys.argv if a.startswith("--enc=")), "b2")
sys.argv = ["eval_b2.py", MODEL] + ([f"--enc={ENC}"] if ENC != "p0" else [])
import eval_b2 as E
import build_undersample as BU
from build_dataset import pack, UNSAFE, SAFE
ID = {"event_id", "actorID", "objectID", "hostid", "timestampNanos"}
SLOTS = [("syscall", 8), ("object_type", 4), ("exe", 16), ("path", 36)]
def penc(r): return b"".join(str(r.get(f) or "").encode("ascii", "ignore")[:w].ljust(w, b"\0") for f, w in SLOTS)
DATA = "data_us" if ENC == "p0" else f"data_us_{ENC}"
def enc_raw(raw, r): return penc(r) if ENC == "p0" else E.WIN(raw)

# ---- replay split: test row -> malicious line ----
rng = np.random.default_rng(BU.SEED)
mal_train = int(BU.MAL_TRAIN_FRAC * BU.MAL_RAW); mal_test = BU.MAL_RAW - mal_train
ben_train = mal_train; ben_test = round(mal_test * BU.BEN_RAW / BU.MAL_RAW); ben_needed = ben_train + ben_test
mal_idx = np.arange(BU.MAL_RAW, dtype=np.int64).reshape(-1, 1); rng.shuffle(mal_idx)
mal_te = mal_idx[mal_train:mal_train + mal_test, 0]
keep_p = min(1.0, (ben_needed / BU.BEN_RAW) * 1.06); k = 0
while k < ben_needed:
    if rng.random() < keep_p: k += 1
rng.shuffle(np.arange(ben_needed, dtype=np.int64).reshape(-1, 1))
rng.permutation(mal_train + ben_train)
p_te = rng.permutation(mal_test + ben_test)
lines = [l.rstrip(b"\n") for l in gzip.open(UNSAFE, "rb")]
yte = np.load("data_us/y_test.npy"); Xw = np.load(f"{DATA}/X_test.npy", mmap_mode="r")
mal_rows = np.where(yte == 1)[0]
row2line = {int(r): int(mal_te[p_te[r]]) for r in mal_rows}
bad = sum(1 for r in mal_rows if bytes(Xw[r]) != enc_raw(lines[row2line[r]], json.loads(lines[row2line[r]])))
print(f"split replayed; mapping verified on {len(mal_rows):,} malicious test rows: {bad} mismatches", flush=True)
assert bad == 0

# ---- floor FN of this model on the touched-once test ----
m = E.load_model(MODEL)
X = np.load(f"{DATA}/X_test.npy")[E.N_VAL:]; y = yte[E.N_VAL:]
U, inv, nb, nm = E.unique_counts(X, y); su = E.score(m, U); s = su[inv]; floor = su.min()
fn_rows = (np.where((y == 1) & (s <= floor * 1.0001))[0] + E.N_VAL).tolist()
print(f"{ENC} floor {floor:.3e}: {len(fn_rows)} FN", flush=True)

ev = []
for r in fn_rows:
    raw = lines[row2line[r]]; j = json.loads(raw)
    ev.append(dict(row=r, raw=raw, j=j, c={k: v for k, v in j.items() if k not in ID}, pk=penc(j),
                   ek=enc_raw(raw, j), score=float(s[r - E.N_VAL]), enc=0, rawtw=0, diffs=collections.Counter()))
by_e = collections.defaultdict(list); by_p = collections.defaultdict(list)
for e in ev: by_e[e["ek"]].append(e); by_p[e["pk"]].append(e)

# ---- scan all benign ----
n = 0
with gzip.open(SAFE, "rb") as f:
    for line in f:
        n += 1
        raw = line.rstrip(b"\n"); j = json.loads(raw)
        for e in by_e.get(enc_raw(raw, j), ()): e["enc"] += 1
        hits = by_p.get(penc(j))
        if hits:
            c = {k: v for k, v in j.items() if k not in ID}
            for e in hits:
                d = frozenset(k for k in set(c) | set(e["c"]) if c.get(k) != e["c"].get(k))
                if d: e["diffs"][d] += 1
                else: e["rawtw"] += 1
        if n % 20_000_000 == 0: print(f"  {n:,} benign lines", flush=True)

true = [e for e in ev if e["rawtw"] == 0]
L = [f"model {MODEL}  encoding {ENC}  floor {floor:.3e}   benign lines scanned {n:,}",
     f"floor FN: {len(ev)} | raw twin exists: {len(ev) - len(true)} | TRUE FN (no raw twin): {len(true)}"
     f"  [of which still identical after encoding: {sum(1 for e in true if e['enc'] > 0)}]", ""]
for e in sorted(ev, key=lambda e: (e["rawtw"] > 0, -e["enc"])):
    j = e["j"]
    L.append(f"{'TRUE FN ' if e['rawtw'] == 0 else 'twin    '} {j.get('syscall')} {j.get('exe')} {j.get('path', '')} "
             f"| enc twins {e['enc']:,} | raw twins {e['rawtw']:,} | score {e['score']:.2e} | halt-id {'halt' in j.get('event_id', '')}")
    if e["rawtw"] == 0:
        if e["diffs"]: L.append("      differs from same-parsed-encoding benign in: " +
                                ", ".join(f"{'+'.join(sorted(d))} ({c:,})" for d, c in e["diffs"].most_common(3)))
        L.append(f"      raw: {e['raw'].decode()}")
open(f"FN_TRUE_{ENC.upper()}.txt", "w").write("\n".join(L) + "\n")
print("\n".join(l for l in L if not l.startswith("      "))); print("FNTRUEDONE", flush=True)
