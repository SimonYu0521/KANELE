"""
Pretty-print packed E5_cadets test-vector entries: decoded fields, hex bytes,
and ASCII. Works on any vectors file of space-separated byte ints (one event
per line), e.g. the demo or equivalence sim inputs.

Usage:
  python examine.py                      # sim/demo_in.txt + demo_label.txt
  python examine.py --file <vectors.txt> [--labels <labels.txt>] [--n 10]
"""
import os, argparse
import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
SIM = os.path.join(HERE, "models/20260708_150047_poc/firmware/sim")

# 64-byte field layout (must match build_dataset.py): (name, start, end)
FIELDS = [("syscall", 0, 8), ("object_type", 8, 12), ("exe", 12, 28), ("path", 28, 64)]

def ascii_of(bs):
    return "".join(chr(b) if 32 <= b < 127 else "." for b in bs)

def decode(bs, a, b):
    return bytes(bs[a:b]).rstrip(b"\x00").decode("ascii", "ignore")

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--file", default=os.path.join(SIM, "demo_in_hex.txt"))
    ap.add_argument("--labels", default=os.path.join(SIM, "demo_label.txt"))
    ap.add_argument("--n", type=int, default=0, help="limit entries (0 = all)")
    ap.add_argument("--hex", action="store_true", help="parse values as hex (auto if 'hex' in filename)")
    args = ap.parse_args()

    base = 16 if (args.hex or "hex" in os.path.basename(args.file).lower()) else 10
    rows = [np.array([int(t, base) for t in l.split()], dtype=int)
            for l in open(args.file) if l.strip()]
    labels = None
    if args.labels and os.path.exists(args.labels):
        labels = [int(l) for l in open(args.labels) if l.strip()]
    if args.n:
        rows = rows[:args.n]

    print(f"file: {args.file}   ({len(rows)} entries, {len(rows[0])} bytes each)\n")
    for i, r in enumerate(rows):
        b = bytes(r.astype(np.uint8))
        tag = ""
        if labels is not None:
            tag = "  TRUE=" + ("MALICIOUS" if labels[i] else "BENIGN")
        print("=" * 92)
        print(f"entry {i}{tag}")
        # semantic one-liner
        flds = "   ".join(f"{n}={decode(b, a, e)!r}" for n, a, e in FIELDS)
        print("  " + flds)
        print("  " + "-" * 88)
        print(f"  {'offset':9s} {'field':12s} {'hex':50s} ascii")
        for n, a, e in FIELDS:
            hx = " ".join(f"{x:02x}" for x in b[a:e])
            # wrap long hex (path) so it stays readable
            print(f"  [{a:2d}:{e:2d}]  {n:12s} {hx[:48]:48s} {ascii_of(b[a:e])}")
            if len(hx) > 48:
                for off in range(48, len(hx), 48):
                    print(f"  {'':9s} {'':12s} {hx[off:off+48]:48s}")
    print("=" * 92)

if __name__ == "__main__":
    main()
