"""
Build data_us_b3/: the SAME events and split as data_us/ (verified row-for-row, via build_b2.main),
with the B3 "floating" raw-window encoding:

  bytes  0– 7  = raw[51:59]       syscall value (always starts at byte 51), same as B2
  bytes  8–63  = raw[x:x+56]      x = 254 + len(syscall) = start of the exe VALUE

Unlike B2 (fixed cut at 258), slice 2's start floats with the syscall length, so the exe
value always lands at input byte 8. In hardware, len(syscall) = position of the closing quote
after byte 51 (a 5-way choice for syscalls of 4..8 chars).
Also checks the format guard: raw[x-10:x] must be the literal ', "exe": "'.
"""
import os, collections
import numpy as np
from build_dataset import HERE
from build_b2 import main

GUARD = b', "exe": "'
STATS = collections.Counter()


def exe_start(raw):
    return 254 + (raw.index(b'"', 51) - 51)


def b3(raw):
    L = raw.index(b'"', 51) - 51
    x = 254 + L
    STATS[f"syscall_len={L}"] += 1
    if raw[x - 10:x] != GUARD: STATS["GUARD_MISMATCH"] += 1
    return np.frombuffer(raw[51:59].ljust(8, b"\0") + raw[x:x + 56].ljust(56, b"\0"), np.uint8)


if __name__ == "__main__":
    main(encode=b3, out=os.path.join(HERE, "data_us_b3"))
    print("B3 encoder stats over encoded lines:", dict(sorted(STATS.items())), flush=True)
