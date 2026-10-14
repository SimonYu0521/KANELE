"""
Build data_us_b2/: the SAME events and SAME train/test split as data_us/
(build_undersample.py), only the 64-byte ENCODING changes.

B2 encoding (plan B: no JSON parsing, fixed byte offsets of the raw log line):
  bytes  0– 7  = raw[51:59]    syscall value (always starts at byte 51) + trailing punctuation
  bytes  8–63  = raw[258:314]  56 bytes from the earliest possible exe start (254+len(syscall),
                               min 258); skips event_id / actorID / objectID / hostid / timestamp.

Why the split is identical: build_undersample's RNG draws depend only on row counts and
line order, never on the encoded bytes. This script replays the exact same RNG sequence on
128-byte rows [parsed 64 | b2 64]; the parsed half is then checked row-for-row against
data_us/ before anything is saved as valid (writes data_us_b2/VERIFIED on success).

Output -> data_us_b2/{X_train,y_train,X_test,y_test}.npy  (uint8 [N,64], y uint8 {0,1})
"""
import os, sys, gzip, json, time
import numpy as np
from build_dataset import pack, SAFE, UNSAFE, HERE
import build_undersample as BU

OUT = os.path.join(HERE, "data_us_b2")
REF = os.path.join(HERE, "data_us")


def b2(raw):
    return np.frombuffer(raw[51:59].ljust(8, b"\0") + raw[258:314].ljust(56, b"\0"), np.uint8)


def enc2(line, encode=b2):
    raw = line.rstrip(b"\n")
    row = np.empty(128, np.uint8)
    row[:64] = pack(json.loads(raw))
    row[64:] = encode(raw)
    return row


def main(encode=b2, out=OUT):
    """encode: raw line bytes -> uint8[64]; out: output dir. Defaults reproduce data_us_b2/."""
    rng = np.random.default_rng(BU.SEED)
    mal_train = int(BU.MAL_TRAIN_FRAC * BU.MAL_RAW)
    mal_test = BU.MAL_RAW - mal_train
    ben_train = mal_train
    ben_test = round(mal_test * BU.BEN_RAW / BU.MAL_RAW)
    ben_needed = ben_train + ben_test
    print(f"train mal {mal_train:,} ben {ben_train:,} | test mal {mal_test:,} ben {ben_test:,}", flush=True)

    # malicious: all, shuffle, 80/20   (same RNG calls as build_undersample)
    t0 = time.time()
    with gzip.open(UNSAFE, "rb") as f:
        Xmal = np.asarray([enc2(l, encode) for l in f], np.uint8)
    print(f"malicious loaded {len(Xmal):,} ({time.time()-t0:.0f}s)", flush=True)
    rng.shuffle(Xmal)
    mal_tr, mal_te = Xmal[:mal_train], Xmal[mal_train:mal_train + mal_test]

    # benign: same keep_p / rng.random() per line / early stop as stream_benign
    keep_p = min(1.0, (ben_needed / BU.BEN_RAW) * 1.06)
    buf = np.zeros((ben_needed, 128), np.uint8)
    k = seen = 0
    t0 = time.time()
    with gzip.open(SAFE, "rb") as f:
        for line in f:
            seen += 1
            if seen % 20_000_000 == 0:
                print(f"  ...streamed {seen:,} benign, kept {k:,}/{ben_needed:,} ({time.time()-t0:.0f}s)", flush=True)
            if rng.random() >= keep_p:
                continue
            buf[k] = enc2(line, encode)
            k += 1
            if k >= ben_needed:
                break
    if k < ben_needed:
        print(f"  WARNING: only kept {k:,} of {ben_needed:,}", flush=True)
        buf = buf[:k]
    print(f"benign kept {k:,} ({time.time()-t0:.0f}s)", flush=True)
    rng.shuffle(buf)
    ben_tr = buf[:ben_train]
    ben_te = buf[ben_train:ben_train + ben_test]

    def assemble(Xm, Xb):
        X = np.concatenate([Xm, Xb])
        y = np.concatenate([np.ones(len(Xm), np.uint8), np.zeros(len(Xb), np.uint8)])
        p = rng.permutation(len(y))
        return X[p], y[p]

    Xtr, ytr = assemble(mal_tr, ben_tr)
    Xte, yte = assemble(mal_te, ben_te)

    # ---- prove identical split: parsed half must equal data_us/ row-for-row ----
    ok = True
    for name, X, y in (("train", Xtr, ytr), ("test", Xte, yte)):
        rX = np.load(f"{REF}/X_{name}.npy", mmap_mode="r")
        ry = np.load(f"{REF}/y_{name}.npy")
        same_y = np.array_equal(ry, y)
        same_X = rX.shape == X[:, :64].shape and all(
            np.array_equal(rX[i:i + 2_000_000], X[i:i + 2_000_000, :64]) for i in range(0, len(X), 2_000_000))
        print(f"VERIFY {name}: rows {len(y):,} | y identical {same_y} | parsed X identical {same_X}", flush=True)
        ok &= same_y and same_X
    if not ok:
        print("VERIFY FAILED: split differs from data_us/ -- not saving.", flush=True)
        sys.exit(2)

    os.makedirs(out, exist_ok=True)
    np.save(f"{out}/X_train.npy", np.ascontiguousarray(Xtr[:, 64:]))
    np.save(f"{out}/y_train.npy", ytr)
    np.save(f"{out}/X_test.npy", np.ascontiguousarray(Xte[:, 64:]))
    np.save(f"{out}/y_test.npy", yte)
    open(f"{out}/VERIFIED", "w").write("parsed-encoding half matched data_us/ row-for-row (X and y)\n")
    print(f"saved -> {out}/  train {len(ytr):,}  test {len(yte):,}", flush=True)


if __name__ == "__main__":
    main()
