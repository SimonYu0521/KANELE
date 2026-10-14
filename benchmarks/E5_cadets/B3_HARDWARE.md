# B3 hardware — raw JSON log stream → KAN verdict, no JSON parser

A complete, verified FPGA datapath for the E5 CADETS byte-level intrusion pre-filter:
a 64-byte-per-clock stream of JSON log lines goes in, and one verdict per line comes out.
The KAN input is built from **fixed byte windows of the raw line** (encoding "B3"), so there is
no JSON decoding anywhere. The KAN's input transform is **folded into its first-layer LUTs**,
so the core takes raw bytes directly.

| | |
|---|---|
| Model | `models/20261013_145858_undersample_b3` (KAN [64,16,2], 8/6/6-bit, Sigma labels) |
| Hardware ≡ model | bit-exact on all **656,388** distinct test inputs (0 decision disagreements) |
| End-to-end RTL sim | **348/348** log lines correct (vector, error flag, logits, forward decision) |
| Resources (VU9P, OOC, post-route) | **12,083 LUTs (1.0%)**, 6,731 FF, **0 BRAM / 0 DSP** for preprocessing + core + decision |
| Clock | meets **322 MHz** (100G MAC user clock) with +0.229 ns slack (≈ 348 MHz max) |
| Throughput | one 64-byte word per clock → **20.6 GB/s per instance**; one result per line, II = 1 |

---

## 1. Model accuracy (what the hardware reproduces exactly)

Touched-once test set: 37.97 M events, 290,144 malicious, real 0.76% prior. Same events and
split as the parsed-encoding model; only the encoding differs (see `MATCHED_FN.md`, `B3_RESULTS.md`).

| share of traffic forwarded | parsed encoding FN | B2 FN | **B3 FN** |
|--:|--:|--:|--:|
| 0.80% | 760 | 408 | **58** |
| 1.0% | 78 | 55 | **49** |
| 1.5% | 46 | 51 | **45** |
| lowest FN (and where) | 42 (3.07%) | 46 (9.16%) | **44 (2.07%)** |

- PR-AUC **0.9998** (parsed 0.9996). At τ = 0.5: FN 108, FP 6,715 (parsed: 140 / 37,016).
- **True false negatives** — misses with no benign event of identical raw content (except IDs/time),
  over all 190 M benign: **B3 1**, parsed 1, B2 4 (`FN_TRUE_B3.txt`). The other 43 B3 misses are
  byte-for-byte identical to benign activity.

---

## 2. The B3 encoding

The CADETS producer writes every line with the same layout: a 22-character `event_id`, three
36-character UUIDs, a 19-digit timestamp, a fixed key order and `": "` spacing. So the useful
fields sit at known byte offsets, and the identity fields can be skipped by position.

```
byte  0         {"event_id": "<22 chars>", "syscall": "
byte 51         <syscall>                  (L = 4..8 chars)
byte 51+L       ", "actorID": "<uuid>", "objectID": "<uuid>", "hostid": "<uuid>", "timestampNanos": <19 digits>
byte 244+L      , "exe": "                 (format guard: these 10 bytes must match)
byte 254+L      <exe value> ...            (then "path"/"object_type"/... in producer order)
```

| KAN input bytes | taken from the raw line | content |
|---|---|---|
| 0–7 | bytes **51–58** (fixed) | syscall + trailing punctuation, e.g. `open", "` |
| 8–63 | bytes **254+L … 309+L** (start floats with syscall length) | exe value, then path / object_type text as written |

Example (`open`, L = 4):
```
raw : ..."syscall": "open", ..."timestampNanos": 1558011787312711440, "exe": "make", "path": "/tmp//makeATMGNQ", ...
KAN : |open", "|make", "path": "/tmp//makeATMGNQ", "object_type": "FILE_|
```

Why "floating": with a fixed cut (B2) the exe value landed 0–4 bytes into the window depending on
syscall length; B3 always puts it at input byte 8. That removed B2's 4 true misses (`id`).

**Format contract and guard.** A line is classified only if (a) it is ≥ 320 bytes, (b) the
syscall's closing quote is at byte 55–59 (L = 4–8), and (c) bytes 244+L…253+L are exactly
`, "exe": "`. Otherwise `err = 1` and the line is **forwarded unclassified** (fail-open). On all
40.7 M lines encoded for the dataset, the guard never failed and every syscall had L = 4–8
(L histogram: 4: 24.6 M, 5: 15.0 M, 6: 1.09 M, 7: 2,946, 8: 1,742); lines are 329–621 bytes.

---

## 3. Architecture

```
          64 B/clk JSON-lines stream
in_data ──────────────────────────► b3_extract ──64 B──► KAN core ──2×6-bit logits──► decision ──► res_*
in_valid                            (preprocessing)  err   (folded LUTs,              d = mal − ben
                                                     │     8-cycle pipeline)          mal = d ≥ THRESH
                                                     └───────── err delay line ──────► forward = mal | err
```

**`b3_top`** (`b3_hw/rtl/b3_top.vhd`)

| port | dir | meaning |
|---|---|---|
| `in_valid`, `in_data[511:0]` | in | stream word; byte i = bits 8i+7..8i, byte 0 first in stream order |
| `res_valid` | out | 1-cycle pulse, one per log line, in stream order |
| `res_logit_ben`, `res_logit_mal` | out | signed 6-bit KAN outputs |
| `res_mal` | out | `logit_mal − logit_ben ≥ THRESH` |
| `res_err` | out | line failed the format guard (not classified) |
| `res_forward` | out | `res_mal or res_err` → send this line to the downstream IDS |

| generic | default | meaning |
|---|---|---|
| `THRESH` | 0 | decision threshold in integer logit units (table in §6) |
| `KAN_LAT` | 8 | KAN core latency (measured, see §5) |

Latency: a line's result appears `KAN_LAT + 3` cycles after the word holding its newline
(input register, extract output register, KAN pipeline, decision register). Results are strictly
in order, so a line FIFO beside the datapath pairs each verdict with its line (pop one line per
`res_valid`; forward it if `res_forward`).

---

## 4. Preprocessing: `b3_extract` (`b3_hw/rtl/b3_extract.vhd`)

Input lines are packed back to back, so a line can start at any of the 64 byte lanes.
Per valid word:

1. **Input register** (timing isolation).
2. **Newline search**: compare all 64 bytes with `0x0A`, take the lowest. No quote/escape tracking
   is needed — valid JSON cannot contain a raw newline inside a string.
3. **Line alignment**: the word is concatenated with the previous word and **funnel-shifted** by the
   line's start lane `p` (`chunk[j] = {prev,cur}[j+p]`), a 3-stage 4:1 log shifter. This yields
   64-byte chunks aligned to the line start; chunks 0–4 (line bytes 0–319) are written to a buffer.
   A relative word counter `rel` picks the chunk; after a newline at lane `n`, the next line
   starts at `p = n+1` (or lane 0 of the next word if `n = 63`).
4. **Emit** (the cycle after the newline word): from the buffer,
   - `L` = first quote among bytes 55–59 (5-way priority);
   - out bytes 0–7 = buffer 51–58; out bytes 8–63 = buffer `254+L … 309+L` (5:1 mux per byte);
   - guard = buffer `244+L … 253+L` == `, "exe": "`;
   - `err = (no quote) or (guard mismatch) or (line length < 320)`.

Synthesis keeps only the buffer bytes the emit logic reads (≈ 79 bytes), so the buffer is small;
most of the 3,117 LUTs are the funnel shifter and the slice multiplexers.

Contract (holds for this producer): the stream starts at a line boundary after reset; every line is
≥ 65 bytes (at most one newline per 64-byte word); lines shorter than 320 bytes are flagged `err`.

---

## 5. KAN core and the input fold

**Generate** (`convert.py <model_tag>`): KANELÉ writes the core as per-connection ROMs
(`xpm_memory_sprom`, 256 × 6 bit for layer 0, 64 × 6 bit for layer 1) plus an adder tree.
B3 has **544 active layer-0 connections** and 32 in layer 1.

**Fold** (`fold_input.py <model_dir> --raw --data data_us_b3`): during training each input byte goes
through `BatchNorm → +bias → HardTanh → 8-bit quantize` before the first layer. Because the input
is a byte (256 possible values) and each layer-0 ROM has exactly 256 entries, that per-feature map
`raw byte → ROM index` is absorbed by **reordering each layer-0 `.mem` file**:
`folded[b] = original[index(b)]`. No logic is added and the RTL is unchanged; the core now takes
the raw B3 bytes as `din`. (`--raw` is required for this model: it was trained on bytes 0–255, not
byte/255 like the old PoC. Originals are kept in `firmware/mem/prefold_layer0/`.)

**Latency**: 8 cycles, measured with the generated `tb_kan_latency` (same as the deployed core).

---

## 6. Decision threshold

The core outputs integer logits; the model's probability is `P(malicious) = sigmoid(s·d)` with
`d = logit_mal − logit_ben ∈ [−63, 63]` and `s = 0.151659` (last-layer output scale). So a
probability threshold τ maps exactly to `THRESH = ceil(ln(τ/(1−τ)) / s)`:

| τ | THRESH | note |
|--:|--:|---|
| 0.5 | 0 | argmax (default) |
| 0.1 | −14 | |
| 0.01 | −30 | |
| 0.001 | −45 | |
| floor | −62 | drop only the most-confident-benign point (d = −63): lowest FN (44 on test) |

---

## 7. Verification

| check | scope | result |
|---|---|---|
| Fold ≡ generator reference | 2,000 test rows, folded `.mem` model vs `KAN_LUT` integer reference | 0 mismatches |
| Fold ≡ trained model | **all 656,388** distinct test inputs | max logit error 1.2e-7, **0** decision disagreements |
| Core RTL (xsim) | 40 raw-byte vectors (20 malicious / 20 benign) | 40/40 |
| Core latency (xsim) | generated latency testbench | 8 cycles |
| **End-to-end RTL (xsim)** | 348 real + edge-case lines packed into a 64 B/clk stream (with idle gaps, then back-to-back) | **348/348**: extractor vector + err, logits, forward decision; result count = line count |
| Negative control | same test with `KAN_LAT = 7` | fails (194 mismatches) — the test detects misalignment |

The end-to-end lines include 150 random malicious + 150 random benign, every `id` event, the
`sshd → sh -c scp` event, `CommandLine` lines with escaped backslashes, syscall lengths 7 and 8,
netflow lines, the `path`-after-`actor_type` layout, and five contract violations (compact
separators, a 105-byte line, 3- and 9-character syscalls, a 319-byte line) that must come out
`err = 1`, plus a 320-byte line that must be classified.

---

## 8. Resources and timing

Vivado 2024.1, `xcvu9p-flgb2104-2-i`, out-of-context synth + place + route.

| design | clock target | LUTs | FF | BRAM/DSP | slack → max clock |
|---|--:|--:|--:|--:|--:|
| **`b3_top`** (extract + core + decision) | 3.103 ns (322 MHz) | **12,083** | 6,731 | 0 / 0 | +0.229 ns → ≈ 348 MHz |
| ↳ `b3_extract` | | 3,117 | 2,172 | 0 / 0 | |
| ↳ `KAN` | | 8,961 | 4,532 | 0 / 0 | |
| ↳ decision | | 5 | 27 | 0 / 0 | |
| KAN core alone (generated flow) | 1.0 ns | 9,368 | 4,532 | 0 / 0 | −0.163 ns → ≈ 860 MHz |

Critical path at 322 MHz: extractor output register → layer-0 ROM address (95% routing; the 64
input bytes fan out to 544 ROMs).

**Scaling to 200 Gb/s** (two 100G ports, ~70 M lines/s): one `b3_top` per port →
≈ **24 k LUTs**, versus ≈ 90 k LUTs for the JSON-parser design (parser lanes ~66 k measured, two
KANs ~18 k, splitter/dispatcher ~5–10 k estimated). Both exclude the line FIFO used for forwarding. Each instance runs one stream at 64 B/clk; its KAN is ~11% busy.

---

## 9. Reproduce

```bash
cd ~/KANELE/benchmarks/E5_cadets
PY="conda run --no-capture-output -n kanele python"
bash run_b3.sh                                     # dataset (data_us_b3/) + training + evaluation (~5 h)
$PY convert.py 20261013_145858_undersample_b3      # RTL + ROMs
$PY fold_input.py models/20261013_145858_undersample_b3 --raw --data data_us_b3
cd b3_hw
$PY verify_fold.py                                 # fold ≡ model on every test input
$PY core_vectors.py                                # diverse vectors for the generated core TBs
(cd ../models/20261013_145858_undersample_b3/firmware/sim && vivado -mode batch -source sim.tcl \
   && vivado -mode batch -source sim_latency.tcl)  # 40/40, 8 cycles
$PY gen_vectors.py                                 # end-to-end stream + golden
(cd sim && vivado -mode batch -source sim_b3.tcl -tclargs 8)          # B3 E2E PASSED
(cd syn && vivado -mode batch -source impl_b3_top.tcl -tclargs 3.103) # resources + timing
```

## 10. Files

| path | what |
|---|---|
| `build_b3.py` (+ `build_b2.py`) | B3 dataset, same split as `data_us/` (verified row-for-row) |
| `run_b3.sh`, `eval_b2.py --enc=b3`, `compare_matched.py`, `fn_true.py` | training + evaluation pipeline |
| `models/20261013_145858_undersample_b3/` | checkpoint, `firmware/` (generated core, folded ROMs, core sims) |
| `b3_hw/rtl/b3_extract.vhd` | preprocessing: log stream → 64-byte input |
| `b3_hw/rtl/b3_top.vhd` | top: preprocessing + core + decision |
| `b3_hw/hw_reference.py` | bit-exact Python model of the whole path |
| `b3_hw/verify_fold.py`, `fold_verify.json` | fold exactness proof, τ → THRESH constants |
| `b3_hw/gen_vectors.py`, `sim/tb_b3_top.vhd`, `sim/sim_b3.tcl` | end-to-end test |
| `b3_hw/syn/impl_b3_top.tcl`, `syn/b3_top_3.103ns/*.rpt` | implementation + reports |

## 11. Not included / limitations

- **Format dependence.** B3 relies on this producer's exact serialization. The guard turns any
  deviation into a forwarded line rather than a wrong verdict, but a different producer (key order,
  spacing, ID lengths) needs a new window definition and retraining.
- **Network side.** The design starts at a 64 B/clk byte stream. MACs, TCP/RDMA termination, and
  the line FIFO that forwards or drops each line are not included.
- **Short lines.** Lines under 65 bytes (two newlines in one word) are outside the contract.
- **Bitstream.** Results are out-of-context place-and-route; no in-context build or board test yet.
