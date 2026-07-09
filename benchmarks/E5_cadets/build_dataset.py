"""
Build a byte-level DARPA-TC E5_cadets dataset for the KANELE benchmark.

Each audit event -> a fixed 64-byte record (hardware-realistic, minimal
preprocessing): the parser copies the RAW ASCII bytes of the semantic fields
into fixed slots and OMITS the leaky identity fields (UUIDs, host, timestamp).

  byte[ 0: 8] syscall        byte[ 8:12] object_type
  byte[12:28] exe            byte[28:64] path            (zero-padded)

Label: safe file -> benign(0), unsafe file -> malicious(1). Output .npy like NID.
"""
import os, gzip, json
import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
DL = os.path.expanduser("~/Downloads")
SAFE = os.path.join(DL, "E5_cadets-deduplicated.safe.json.gz")     # benign  (~115M)
UNSAFE = os.path.join(DL, "E5_cadets-deduplicated.unsafe.json.gz")  # malicious (1.47M)
OUT = os.path.join(HERE, "data")
SEED = 4332142
TEST_SIZE = 0.2
BENIGN_TARGET = 3_000_000      # subsample benign to ~2x malicious
BENIGN_KEEP_P = 0.03           # ~3M of ~115M

# field -> (offset, width) in the 64-byte record
SLOTS = {"syscall": (0, 8), "object_type": (8, 4), "exe": (12, 16), "path": (28, 36)}

def pack(rec):
    b = np.zeros(64, np.uint8)
    for field, (off, w) in SLOTS.items():
        v = rec.get(field) or ""
        raw = str(v).encode("ascii", "ignore")[:w]
        b[off:off + len(raw)] = np.frombuffer(raw, np.uint8)
    return b

def load(path, keep_p=1.0, cap=None, rng=None):
    rows = []
    with gzip.open(path, "rt") as f:
        for line in f:
            if keep_p < 1.0 and rng.random() >= keep_p:
                continue
            rows.append(pack(json.loads(line)))
            if cap and len(rows) >= cap:
                break
    return np.asarray(rows, np.uint8)

def main():
    rng = np.random.default_rng(SEED)
    print("reading malicious (unsafe)…", flush=True)
    Xmal = load(UNSAFE)
    print(f"  malicious events: {len(Xmal):,}")
    print("streaming benign (safe) with subsampling…", flush=True)
    Xben = load(SAFE, keep_p=BENIGN_KEEP_P, cap=BENIGN_TARGET, rng=rng)
    print(f"  benign events kept: {len(Xben):,}")

    X = np.concatenate([Xben, Xmal])
    y = np.concatenate([np.zeros(len(Xben), np.int64), np.ones(len(Xmal), np.int64)])
    print(f"total {len(y):,} | benign {len(Xben):,} | malicious {len(Xmal):,}")

    # shuffle + split (random; features carry no identity, so no entity grouping)
    perm = rng.permutation(len(y)); X, y = X[perm], y[perm]
    cut = int((1 - TEST_SIZE) * len(y))
    tr, te = slice(0, cut), slice(cut, None)

    os.makedirs(OUT, exist_ok=True)
    eye = np.eye(2, dtype=np.float32)
    np.save(f"{OUT}/X_train.npy", (X[tr].astype(np.float32) / 255.0))
    np.save(f"{OUT}/X_test.npy",  (X[te].astype(np.float32) / 255.0))
    np.save(f"{OUT}/y_train.npy", eye[y[tr]])
    np.save(f"{OUT}/y_test.npy",  eye[y[te]])
    print(f"train {cut:,} ({100*y[tr].mean():.2f}% mal) | test {len(y)-cut:,} ({100*y[te].mean():.2f}% mal)")
    print(f"saved -> {OUT}/")

if __name__ == "__main__":
    main()
