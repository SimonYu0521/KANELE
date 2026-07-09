# E5_cadets — training → hardware, minimal flow

Byte-level host-IDS KAN (4 fields: syscall│object_type│exe│path → 64 bytes,
binary benign/malicious). All commands from `~/KANELE/benchmarks/E5_cadets`.

**Per run, update two constants** to the new `models/<timestamp>_poc`:
`model_tag` in `convert.py`, and `MDIR` in `fold_input.py`.

```bash
# 1. Build dataset from ~/Downloads/E5_cadets*.json.gz     -> data/*.npy
python build_dataset.py

# 2. Train (CPU ~50 min)                                    -> models/<ts>_poc/
conda run --no-capture-output -n kanele python -u train_quant_poc.py

# 3. Convert trained model to RTL (set model_tag first)     -> models/<ts>_poc/firmware/
conda run --no-capture-output -n kanele python convert.py

# 4. Fold input transform into layer-0 LUTs => din = raw bytes (set MDIR first)
conda run --no-capture-output -n kanele python fold_input.py     # see fold.md

# 5a. Verify RTL == model (equivalence)
cd models/<ts>_poc/firmware/sim && vivado -mode batch -source sim.tcl        # 10/10

# 5b. Classification demo on 30 real held-out events (raw bytes)
cd ~/KANELE/benchmarks/E5_cadets && conda run -n kanele python make_demo_vectors.py
cd models/<ts>_poc/firmware/sim && vivado -mode batch -source sim_demo.tcl    # 30/30

# 6. Build for resources + timing (OOC) or bitstream (full)
cd models/<ts>_poc/firmware
vivado -mode batch -source vivado/build_ooc.tcl     # LUTs / FF / Fmax
vivado -mode batch -source vivado/build_full.tcl    # in-context + .bit (needs met timing)
```

Reference results (this model): acc 0.999 in-domain; RTL exact-match; 8-cycle
latency; OOC 6,997 LUTs / 2,922 FF / 0 BRAM / 0 DSP; Fmax ~950 MHz; demo 30/30.
See `fold.md` for the input-fold method. NOTE: 0.999 is in-domain; cross-engagement
(cadets→trace) drops to AUC ~0.64 — the hardware is exact, the detection is
engagement-specific.
