"""
Build the UNDER-SAMPLE E5_cadets split (KANELE benchmark).

Design (user spec):
  * ALL malicious events are used: 80% -> train, 20% -> test.
  * TRAIN is balanced 50/50 by RANDOM under-sampling of benign
    (benign subsample count == train malicious count).
  * TEST keeps the REAL deployment ratio: benign:malicious reconstructed at the
    true prior of the raw data (190,387,151 benign : 1,466,123 malicious ~= 0.76% mal).
  * Train/test benign pools are DISJOINT (a benign event is never in both).

Storage: X saved as raw uint8 bytes [N,64] (0..255) to stay small on disk
(the ~38M-event test is 2.5 GB as uint8 vs 9.8 GB as float32); y as uint8 {0,1}.
The trainer feeds bytes as float 0..255 with NO /255 normalisation: the input
BatchNorm standardises each feature, so byte scale is irrelevant to training, and
raw bytes are the natural 8-bit LUT address for the hardware input-fold.

Output -> data_us/{X_train,y_train,X_test,y_test}.npy
"""
import os, gzip, json, time
import numpy as np
from build_dataset import pack, SAFE, UNSAFE, HERE   # same 64-byte packing/layout

SEED = 4332142
OUT = os.path.join(HERE, "data_us")
MAL_TRAIN_FRAC = 0.80

# authoritative raw counts (exact benign line count measured from the safe.gz)
BEN_RAW = 190_387_151
MAL_RAW = 1_466_123


def load_all_malicious():
    rows = []
    with gzip.open(UNSAFE, "rt") as f:
        for line in f:
            rows.append(pack(json.loads(line)))
    return np.asarray(rows, np.uint8)


def stream_benign(n_target, rng):
    """Random iid sample of n_target benign records, packed into a preallocated
    uint8 buffer. keep_p is set slightly above target/raw and we stop once full."""
    keep_p = min(1.0, (n_target / BEN_RAW) * 1.06)
    buf = np.zeros((n_target, 64), np.uint8)
    k = 0
    seen = 0
    t0 = time.time()
    with gzip.open(SAFE, "rt") as f:
        for line in f:
            seen += 1
            if seen % 20_000_000 == 0:
                print(f"    ...streamed {seen:,} benign lines, kept {k:,}/{n_target:,} "
                      f"({time.time()-t0:.0f}s)", flush=True)
            if rng.random() >= keep_p:
                continue
            buf[k] = pack(json.loads(line))
            k += 1
            if k >= n_target:
                break
    if k < n_target:
        print(f"    WARNING: only kept {k:,} of {n_target:,} benign (file exhausted)")
        buf = buf[:k]
    print(f"    benign kept {k:,} in {time.time()-t0:.0f}s", flush=True)
    return buf


def main():
    rng = np.random.default_rng(SEED)

    # --- split sizes ---
    mal_train = int(MAL_TRAIN_FRAC * MAL_RAW)          # 1,172,898
    mal_test = MAL_RAW - mal_train                     #   293,225
    ben_train = mal_train                              # 50/50 train
    ben_test = round(mal_test * BEN_RAW / MAL_RAW)     # real prior in test
    ben_needed = ben_train + ben_test
    print(f"target sizes:")
    print(f"  train  mal {mal_train:,}  ben {ben_train:,}  (50/50)")
    print(f"  test   mal {mal_test:,}  ben {ben_test:,}  (real {100*MAL_RAW/(BEN_RAW+MAL_RAW):.3f}% mal)")
    print(f"  benign to stream: {ben_needed:,}\n")

    # --- malicious: load all, shuffle, 80/20 ---
    print("loading ALL malicious...", flush=True)
    Xmal = load_all_malicious()
    print(f"  malicious loaded: {len(Xmal):,}")
    rng.shuffle(Xmal)
    mal_tr, mal_te = Xmal[:mal_train], Xmal[mal_train:mal_train + mal_test]

    # --- benign: stream a random pool, shuffle, split disjoint train/test ---
    print("streaming benign (random subsample)...", flush=True)
    Xben = stream_benign(ben_needed, rng)
    rng.shuffle(Xben)
    ben_tr = Xben[:ben_train]
    ben_te = Xben[ben_train:ben_train + ben_test]

    # --- assemble + shuffle within each split ---
    def assemble(Xm, Xb):
        X = np.concatenate([Xm, Xb])
        y = np.concatenate([np.ones(len(Xm), np.uint8), np.zeros(len(Xb), np.uint8)])
        p = rng.permutation(len(y))
        return X[p], y[p]

    Xtr, ytr = assemble(mal_tr, ben_tr)
    Xte, yte = assemble(mal_te, ben_te)

    os.makedirs(OUT, exist_ok=True)
    np.save(f"{OUT}/X_train.npy", Xtr)   # uint8 [N,64]
    np.save(f"{OUT}/y_train.npy", ytr)   # uint8 [N]
    np.save(f"{OUT}/X_test.npy", Xte)
    np.save(f"{OUT}/y_test.npy", yte)

    print(f"\nsaved -> {OUT}/")
    print(f"  train {len(ytr):,}  ({100*ytr.mean():.3f}% mal)  X={Xtr.nbytes/1e9:.2f}GB")
    print(f"  test  {len(yte):,}  ({100*yte.mean():.3f}% mal)  X={Xte.nbytes/1e9:.2f}GB")


if __name__ == "__main__":
    main()
