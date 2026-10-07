# Running a KANELÉ E5_cadets model on arbitrary inputs

This is a self-contained guide to load one of the trained byte-level KAN models and
score **arbitrary audit-event records** (get P(malicious) per event). Verified working
2026-09-16.

---

## 1. What the model is (1 paragraph)

Each model is a quantized Kolmogorov–Arnold Network (Brevitas) that classifies a single
DARPA-TC E5 **CADETS** audit event as benign(0)/malicious(1). The model sees **only 4
fields of the event, packed into 64 raw bytes** — `syscall | object_type | exe | path`.
Everything else in the record (event_id, actorID, objectID, hostid, timestampNanos,
actor_type) is **dropped and never seen**. So inference = pack the event to 64 bytes,
feed as float, softmax, read column 1.

## 2. Environment

- conda env **`kanele`** (torch 2.8, brevitas 0.12; CPU is fine). Run python as
  `conda run --no-capture-output -n kanele python …`.
- Run from `benchmarks/E5_cadets/`. KANELÉ source is imported with
  `sys.path.append('../../src')` (same as `convert.py` / `train_under_sample.py`).

## 3. Which model directory to use

All live under `models/` (relative to `benchmarks/E5_cadets/`). Loading/inference is
**identical** for all — only `config.json` (architecture) + `NID_best.pt` (weights) differ.

| dir | labels it was trained on | layers | note |
|---|---|---|---|
| `20260709_193605_undersample` | **Sigma** rules (original `~/Downloads/E5_cadets-deduplicated`) | [64,16,2] | PR-AUC 0.9996; re-learns Sigma signatures. **Committed** (weights + firmware) |
| `20260909_152914_undersample` | **ground truth** (provenance tracing) | [64,16,2] | PR-AUC 0.068; the "GT model". Local only, not committed |

(`data_us_gt/` holds the **ground-truth** (provenance) labels; `data_us/` holds the
original **Sigma** (signature) labels. Dataset dirs are not committed — rebuild `data_us/`
with `build_undersample.py`.)

## 4. Input encoding — MUST match training exactly

Pack each event into a 64-byte `uint8` vector, raw ASCII, zero-padded, truncated to slot
width. Then feed as **float 0..255 with NO `/255` normalization** (the model's input
BatchNorm standardizes; raw byte scale is intentional).

```
byte  0– 7  syscall        (8)      e.g. "open", "read", "execve"
byte  8–11  object_type    (4)      first 4 chars, e.g. "FILE" from "FILE_OBJECT_FILE"
byte 12–27  exe           (16)      e.g. "sh", "bash", "cc"
byte 28–63  path          (36)      e.g. "/etc/libmap.conf"; empty if the event has none
```

Missing field → empty bytes. `object_type` is truncated to its first 4 chars by the
4-byte slot, so `"FILE_OBJECT_FILE"` → `"FILE"`, `"SUBJECT_PROCESS"`(as object) → `"SUBJ"`, etc.

## 5. Complete runnable script (copy-paste)

```python
import json, sys, numpy as np, torch, torch.nn as nn
sys.path.append('../../src')          # run from benchmarks/E5_cadets/
from KANQuant import KANQuant
from quant import QuantBrevitasActivation, ScalarBiasScale
from brevitas.nn import QuantHardTanh
from brevitas.core.scaling import ParameterScaling
from brevitas.core.quant import QuantType

MODEL_DIR = "models/20260709_193605_undersample"
TAU = 0.5   # flag malicious iff P(malicious) >= TAU  (0.5 == argmax of the two logits)

# ---- input packing (the ONLY 4 fields used) ----
SLOTS = {"syscall": (0, 8), "object_type": (8, 4), "exe": (12, 16), "path": (28, 36)}
def pack(rec):
    b = np.zeros(64, np.uint8)
    for f, (o, w) in SLOTS.items():
        v = rec.get(f) or ""
        raw = str(v).encode("ascii", "ignore")[:w]
        b[o:o + len(raw)] = np.frombuffer(raw, np.uint8)
    return b

# ---- load model (input-layer construction MUST be built like this so state_dict keys
#      match; load_state_dict then restores ALL trained weights incl. the input BatchNorm,
#      so the fresh bn init below does not matter) ----
cfg = json.load(open(f"{MODEL_DIR}/config.json"))
bn = nn.BatchNorm1d(cfg["layers"][0]); nn.init.constant_(bn.weight.data, 1); nn.init.constant_(bn.bias.data, 0)
ib = ScalarBiasScale(scale=False, bias_init=-0.25)
il = QuantBrevitasActivation(
    QuantHardTanh(bit_width=cfg["layers_bitwidth"][0], max_val=1.0, min_val=-1.0,
                  act_scaling_impl=ParameterScaling(1.33), quant_type=QuantType.INT,
                  return_quant_tensor=False),
    pre_transforms=[bn, ib], cuda=False)
model = KANQuant(cfg, il, torch.device("cpu"))
model.load_state_dict(torch.load(f"{MODEL_DIR}/NID_best.pt", map_location="cpu",
                                 weights_only=False)["model_state_dict"])
model.eval()

# ---- inference: list of event dicts -> P(malicious) per event ----
def score(records, batch=16384):
    X = np.stack([pack(r) for r in records]).astype(np.float32)   # [N,64], values 0..255, NO /255
    out = np.empty(len(X), np.float32)
    with torch.no_grad():
        for i in range(0, len(X), batch):
            out[i:i+len(X[i:i+batch])] = torch.softmax(model(torch.from_numpy(X[i:i+batch])), 1)[:, 1].numpy()
    return out

if __name__ == "__main__":
    recs = [
        {"syscall": "open",   "object_type": "FILE_OBJECT_FILE", "exe": "sh",   "path": "/etc/libmap.conf"},
        {"syscall": "execve", "object_type": "FILE_OBJECT_FILE", "exe": "bash", "path": "/usr/bin/scp"},
        {"syscall": "read",   "object_type": "FILE_OBJECT_FILE", "exe": "cc"},   # no path -> empty
    ]
    for r, p in zip(recs, score(recs)):
        print(f"P(malicious)={p:.4f}  flag={p >= TAU}   {r}")
```

Verified output with `MODEL_DIR = models/20260709_193605_undersample` (the Sigma model):
```
P(malicious)=0.0001  flag=False   open  sh   /etc/libmap.conf
P(malicious)=0.9995  flag=True    execve bash /usr/bin/scp
P(malicious)=0.0001  flag=False   read  cc
```
(The Sigma model flags `execve bash /usr/bin/scp` — a Sigma signature pattern — and ignores
`open sh /etc/libmap.conf`. The local-only GT model does the opposite: 0.9855 / 0.0004 / 0.0004,
because `/etc/libmap.conf` is the dominant provenance-attack content.)

## 6. Notes / gotchas

- **Feed raw bytes as float, never `/255`.** `X.astype(np.float32)` with values 0..255.
- **`weights_only=False`** when loading (checkpoint stores non-tensor metadata: epoch,
  remaining_fraction, val_prauc). The weights are under key `"model_state_dict"`.
- **Do not skip the input layer.** The `BatchNorm(64) → bias(-0.25) → QuantHardTanh(scale 1.33)`
  front-end is part of the model; `load_state_dict` restores its trained BatchNorm
  running stats, so the boundary is correct. Building it with different structure will
  break key matching or give wrong scores.
- **Architecture is read from `config.json`** (`layers`, `layers_bitwidth`), so the same
  code adapts to any architecture variant without edits.
- **Threshold:** `TAU=0.5` is argmax of the two output logits (the deployed operating
  point). Raise it for fewer false positives / more misses; the model's minimum possible
  score ("floor") is a few×10⁻⁴–10⁻⁵ depending on the model.
- **Speed:** the 64-byte content has massive duplication in real logs. To score millions
  of events, dedup identical 64-byte patterns first (`np.unique(X.view(np.void, ...))`),
  score the uniques, and map back — ~100× fewer forward passes.
- Output is P(malicious) = `softmax(logits)[:,1]`. `1 - that` = P(benign).
```
