"""
Bit-exact software model of the B3 hardware path:

    raw JSON log line --(b3_extract)--> 64 bytes --(folded-LUT KAN)--> 2 signed 6-bit logits

Everything here mirrors the RTL, and is used both to verify the fold and to generate
golden vectors for the VHDL testbench.
"""
import glob, os, re
import numpy as np

E5 = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MODEL = os.path.join(E5, "models/20261013_145858_undersample_b3")
FW = os.path.join(MODEL, "firmware")

GUARD = b', "exe": "'
MIN_LINE = 320            # bytes [0, 320) must belong to the line (all B3 bytes are < 318)


# ---------------------------------------------------------------- preprocessing
def b3_extract(line: bytes):
    """Returns (vec64: bytes, err: bool) exactly as b3_extract.vhd does.
    vec = raw[51:59] + raw[254+L : 310+L], L = syscall length found from the closing quote
    at bytes 55..59 (L = 4..8). err = line shorter than 320 B, no quote at 55..59, or the
    literal ', "exe": "' not at 244+L..253+L  ->  the line is forwarded unclassified."""
    raw = line.rstrip(b"\n")
    L = next((k - 51 for k in range(55, 60) if k < len(raw) and raw[k:k + 1] == b'"'), None)
    if L is None:
        L, err = 4, True              # RTL default when no quote found (value irrelevant: err)
    else:
        err = False
    x = 254 + L
    vec = raw[51:59].ljust(8, b"\0") + raw[x:x + 56].ljust(56, b"\0")
    err = err or len(raw) < MIN_LINE or raw[x - 10:x] != GUARD
    return vec, err


# ---------------------------------------------------------------- KAN core (folded LUTs)
def _read_mem(path, bits=6):
    v = np.array([int(h, 16) for h in open(path).read().split()], np.int64)
    return np.where(v >= 1 << (bits - 1), v - (1 << bits), v)


def load_luts(fw=FW):
    L = {0: {}, 1: {}}
    for f in glob.glob(os.path.join(fw, "mem", "lut_*.mem")):
        i, j, k = map(int, re.match(r"lut_(\d+)_(\d+)_(\d+)\.mem", os.path.basename(f)).groups())
        L[i][(j, k)] = _read_mem(f)
    return L


def kan_int(X, luts, n_hidden=16, n_out=2, lo=-32, hi=31, in1_off=32):
    """X: uint8 [N,64] raw B3 bytes (folded layer 0 is addressed by the raw byte).
    Returns int64 [N,2] = (logit_benign, logit_malicious) exactly as KAN.vhd outputs them."""
    X = np.asarray(X)
    h = np.zeros((len(X), n_hidden), np.int64)
    for (j, k), t in luts[0].items():
        h[:, k] += t[X[:, j]]
    h = np.clip(h, lo, hi)
    o = np.zeros((len(X), n_out), np.int64)
    for (j, k), t in luts[1].items():
        o[:, k] += t[h[:, j] + in1_off]
    return np.clip(o, lo, hi)
