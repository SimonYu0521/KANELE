#!/usr/bin/env python3
"""Golden vectors for tb_b3_top: a packed JSON-lines byte stream (64 B words, idle gaps
in the first 60%, back-to-back after) + per-line expected (err, logits, 64-byte B3 vector)
from the bit-exact model in hw_reference.py.  Writes sim/stream.txt, sim/expected.txt, sim/lines.txt."""
import gzip, json, os, sys, random
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import hw_reference as R

rnd = random.Random(7)
DL = os.path.expanduser("~/Downloads/")
lines, tags = [], []
def add(l, t): lines.append(l.rstrip(b"\n")); tags.append(t)

# ---- malicious: random sample + every `id` event + the sshd->scp event ----
mal = gzip.open(DL + "E5_cadets-deduplicated.unsafe.json.gz", "rb").read().splitlines()
for l in rnd.sample(mal, 150): add(l, "mal:random")
for l in [l for l in mal if b'"exe": "id",' in l][:20]: add(l, "mal:exe=id")
for l in mal:
    if b"Mj30P0nUQrqN5ypyLZ9NtA" in l: add(l, "mal:sshd->scp"); break
for l in [l for l in mal if b"\\\\" in l][:5]: add(l, "mal:CommandLine-with-backslash")

# ---- benign: random sample + syscall lengths 7/8 + netflow + path-after-actor_type ----
want = {b'"syscall": "recvmsg"': 4, b'"syscall": "recvfrom"': 4, b'"object_type": "NETFLOW"': 4,
        b'"actor_type": "SUBJECT_PROCESS", "path"': 4}
pool = []
with gzip.open(DL + "E5_cadets-deduplicated.safe.json.gz", "rb") as f:
    for i, l in enumerate(f):
        if i >= 3_000_000: break
        if i % 20000 == 0: pool.append(l)
        for k in want:
            if want[k] and k in l: add(l, "ben:" + k.decode().split('"')[1] + "=" + k.decode().split('"')[3]); want[k] -= 1
for l in rnd.sample(pool, 150): add(l, "ben:random")

# ---- format-contract violations (must come out err=1) and the 320-byte boundary ----
base = next(l for l in lines if b'"path": "' in l and b'"syscall": "open"' in l).rstrip(b"\n")
j = json.loads(base)
add(json.dumps(j, separators=(",", ":")).encode(), "bad:compact-separators")
add(b'{"event_id": "' + b"A" * 22 + b'", "syscall": "open", "exe": "sh", "object_type": "FILE_OBJECT_FILE"}', "bad:short-line")
add(base.replace(b'"syscall": "open"', b'"syscall": "dup"'), "bad:syscall-len-3")
add(base.replace(b'"syscall": "open"', b'"syscall": "setgroups"'), "bad:syscall-len-9")
for target in (319, 320):              # fixed prefix up to exe + a path sized to hit the exact length
    jj = {k: j[k] for k in ("event_id", "syscall", "actorID", "objectID", "hostid", "timestampNanos", "exe")}
    for n in range(1, 400):
        jj["path"] = ("/tmp/" + "x" * 400)[:n]
        if len(json.dumps(jj).encode()) == target: break
    assert len(json.dumps(jj).encode()) == target
    add(json.dumps(jj).encode(), f"edge:length-{target}")

order = list(range(len(lines))); rnd.shuffle(order)
lines = [lines[i] for i in order]; tags = [tags[i] for i in order]

# ---- golden ----
vecs, errs = zip(*(R.b3_extract(l) for l in lines))
logits = R.kan_int(np.frombuffer(b"".join(vecs), np.uint8).reshape(-1, 64), R.load_luts())

# ---- stream: lines + '\n' packed into 64-byte words ----
blob = b"".join(l + b"\n" for l in lines)
blob += b"\0" * (-len(blob) % 64)
words = [blob[i:i + 64] for i in range(0, len(blob), 64)]
hx = lambda b: b[::-1].hex()                               # byte 63 first -> hread into (511 downto 0)
os.makedirs(os.path.join(HERE, "sim"), exist_ok=True)
with open(os.path.join(HERE, "sim/stream.txt"), "w") as f:
    for i, w in enumerate(words):
        gap = (rnd.choice([0, 0, 0, 1, 2]) if i < 0.6 * len(words) else 0)
        f.write(f"{gap} {hx(w)}\n")
with open(os.path.join(HERE, "sim/expected.txt"), "w") as f:
    f.write(f"{len(lines)}\n")
    for v, e, lg in zip(vecs, errs, logits):
        f.write(f"{int(e)} {int(lg[0])} {int(lg[1])} {hx(v)}\n")
with open(os.path.join(HERE, "sim/lines.txt"), "w") as f:
    for t, l, e, lg in zip(tags, lines, errs, logits):
        f.write(f"{t:38s} err={int(e)} logits=({int(lg[0])},{int(lg[1])}) len={len(l)}  {l[:150].decode(errors='replace')}\n")
n_err = sum(errs); n_fwd = sum(1 for e, lg in zip(errs, logits) if e or lg[1] - lg[0] >= 0)
print(f"{len(lines)} lines, {len(words)} words, {len(blob):,} bytes; expected err={n_err}, forwarded(tau=0.5)={n_fwd}")
print("lengths: min", min(map(len, lines)), "max", max(map(len, lines)))
