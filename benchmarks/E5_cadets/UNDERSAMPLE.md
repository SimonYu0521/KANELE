# E5_cadets — Under-Sample byte-level KAN: training → FPGA

End-to-end recipe for the model in `models/20260709_193605_undersample/`
(checkpoint **`NID_best.pt`**): a byte-level Kolmogorov–Arnold Network that
classifies DARPA-TC Engagement-5 **CADETS** host-provenance events as
benign/malicious, trained with **random under-sampling**, then compiled to FPGA
LUTs via KANELE.

## TL;DR result
- **Input:** 64 raw bytes per audit event (`syscall | object_type | exe | path`); client identity (UUIDs / host / timestamp) **excluded**.
- **Test** (37.97 M events at the *real* 0.76 % malicious prior): **ROC-AUC 0.9999, PR-AUC 0.9996**.
- **Operating point τ = 0.5** (argmax): **FN 140 / FP 37,016** → recall 99.95 %, precision 88.7 %.
- **Hardware** (OOC, `xcvu9p-flgb2104-2-i`): **8,939 LUTs / 3,623 FF / 0 BRAM / 0 DSP**, ≈ 875 MHz, 8-cycle latency; RTL ≡ model exact (`max|Δ| = 0`).

## Prerequisites
- conda env **`kanele`** (torch 2.8, brevitas 0.12.1; CPU is fine) — run python as `conda run -n kanele …`.
- Raw data in `~/Downloads/`: `E5_cadets-deduplicated.safe.json.gz` (benign, ~190 M events) and `E5_cadets-deduplicated.unsafe.json.gz` (malicious, 1.47 M).
- **Vivado 2024.1** at `/opt/amd/Xilinx/Vivado/2024.1` for RTL sim + build.
- Run everything from `~/KANELE/benchmarks/E5_cadets/`.

---

## Step 1 — Build the dataset  (`build_undersample.py` → `data_us/`)
What it does:
- Streams the raw logs; packs each event into a **64-byte record**
  (`syscall[0:8] | object_type[8:12] | exe[12:28] | path[28:64]`, raw ASCII,
  zero-padded). Identity fields are omitted to avoid identity shortcuts.
- **Malicious split:** 80 % → train, 20 % → test.
  **Train = balanced 50/50** by random under-sampling of benign;
  **test = kept at the real ~0.76 % prior**. Train/eval benign pools are disjoint.
- Saves **uint8 raw bytes** (no `/255` — the input BatchNorm standardises, so byte
  scale is irrelevant, and a raw byte == the 8-bit LUT address for the fold).

```bash
conda run --no-capture-output -n kanele python build_undersample.py
```
Outputs `data_us/{X,y}_{train,test}.npy`: **train 2,345,796** (50/50),
**test 38,370,707** (0.76 % mal). Validation is carved from the test pool at
train time (next step).

---

## Step 2 — Train  (`train_under_sample.py` → `models/<ts>_undersample/`)
Model (`config.json`): `layers=[64,16,2]`, `layers_bitwidth=[8,6,6]`,
`grid_size=40`, `spline_order=10`, `batch_size=512`, **class-weighted CrossEntropy**.

Pipeline: raw bytes fed as float `0..255` (no `/255`); a disjoint **400 K
real-ratio slice** of the test pool is the **validation** set (the rest,
37,970,707, is the touched-once test); **best checkpoint = highest validation
PR-AUC**; the full test is then scored at the **τ = 0.5 (argmax)** operating point.

```bash
# as run — ~10 h on CPU for 20 epochs (--epochs 10 is plenty; val PR-AUC ~1.0 by epoch 1)
conda run --no-capture-output -n kanele python -u train_under_sample.py --epochs 20 2>&1 | tee train_us.log
```
Produces in `models/<ts>_undersample/`: **`NID_best.pt`** (this model = epoch 12,
pruned to **41.6 %** of connections), `NID_last.pt`, `config.json`,
`final_test_report.json`, `training.log`.

**Results** (`final_test_report.json`, full 37.97 M test), at **τ = 0.5 (argmax)**:

| Precision | Recall | F1 | TP | FP | FN | TN |
|--:|--:|--:|--:|--:|--:|--:|
| 0.887 | 0.9995 | 0.940 | 290,004 | 37,016 | **140** | 37,643,547 |

ROC-AUC **0.9999**, PR-AUC **0.9996**.
> This is the **high-recall** operating point: only **140 missed attacks**
> (recall 99.95 %), at the cost of 37 K false alarms (precision 88.7 %) — the
> base-rate effect of a 0.76 % prior on 37.7 M benign events.

---

## Step 3 — Convert to RTL  (`convert.py` → `firmware/`)
Edit `convert.py`: set `model_tag = "<ts>_undersample"` (here
`20260709_193605_undersample`). The checkpoint picker prefers `NID_best.pt`;
loads with `weights_only=False`.

```bash
conda run --no-capture-output -n kanele python convert.py
```
Builds the per-connection 256-deep LUT truth tables and emits
`models/<ts>_undersample/firmware/` (`src/*.vhd`, `mem/*.mem`, `sim/`, `vivado/`)
+ `truth_tables.json`, and runs an **xsim equivalence check** (RTL vs quantised
model → **`max|Δ| = 0`**). **439** active layer-0 LUT ROMs, **8-cycle** latency.

---

## Step 4 (optional) — Fold input for RAW-BYTE hardware  (`fold_input.py`)
The model still applies an input transform (**BatchNorm + −0.25 bias + HardTanh +
8-bit quant**) that maps a raw byte → LUT index (BatchNorm is *not* identity — its
per-feature means run 0…110, variances up to ~2857). To let the FPGA ingest
**raw log bytes** with zero preprocessing, fold that map into the layer-0 LUTs.

Edit `fold_input.py`: set `MDIR = "models/<ts>_undersample"`. Then:
```bash
conda run -n kanele python fold_input.py     # see fold.md
```
It permutes each of the 439 layer-0 mems' 256 lines by `b → din(b)`. **Lossless**
(`max|Δ| = 0`), same LUT count / Fmax, no retrain, and the **τ=0.5 (argmax)
behaviour is preserved**. Originals backed up in `firmware/mem/prefold_layer0/`.
Skip this only if you pre-quantise inputs on the host.

---

## Step 5 — Build for resources / timing  (Vivado OOC)
```bash
cd models/<ts>_undersample/firmware
/opt/amd/Xilinx/Vivado/2024.1/bin/vivado -mode batch -source vivado/build_ooc.tcl
```
Reports land in `KAN_FPGA_PROJECT/post_impl_{util,timing}.rpt`. This model:
**8,939 CLB LUTs (0.76 %), 3,623 FF, 0 BRAM/URAM/DSP, 207 CARRY8**;
WNS ≈ −0.14 ns @ 1 GHz → **Fmax ≈ 875 MHz**, latency 8 cycles.
(1 GHz not met → no bitstream; OOC metrics only. `vivado/build_full.tcl` is the
in-context / `.bit` path.)

---

## Deploying at τ = 0.5
The KAN emits two logits (benign, malicious). **`argmax(benign, malicious)` ==
τ=0.5**, i.e. the 140-FN / 99.95 %-recall operating point — the RTL produces
exactly this with **nothing added** (no threshold logic, no bias): just take the
larger of the two output logits.

## File map
| path | what |
|---|---|
| `build_undersample.py` | Step 1 — dataset builder |
| `train_under_sample.py` | Step 2 — trainer |
| `convert.py` | Step 3 — model → RTL (set `model_tag`) |
| `fold_input.py`, `fold.md` | Step 4 — raw-byte input fold (set `MDIR`) |
| `models/20260709_193605_undersample/NID_best.pt` | the trained checkpoint |
| `models/20260709_193605_undersample/final_test_report.json` | metrics (τ=0.5) |
| `models/20260709_193605_undersample/firmware/` | generated RTL + Vivado build |
