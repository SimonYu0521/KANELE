# Folding the input transform into the first-layer LUTs

**Goal:** make the FPGA core consume the **raw packed 64 bytes** directly as `din`,
with no BatchNorm / affine / quantize preprocessing block in front of it.

## Background: why `din` ≠ raw byte by default

During training every input goes through an input layer
(`BatchNorm1d → ScalarBiasScale(bias=−0.25) → QuantHardTanh[−1,1] → 8-bit quant`).
The KANELÉ paper (§3.2) folds the BN *statistics* into affine constants at
inference, but the result is still an **affine → clip → quantize** step that
runs *before* the first LUT. So the generated core expects `din` = the
**quantized input index**, and `convert.py`'s test vectors are those indices —
not raw bytes. Feeding raw bytes without this transform gives wrong results.

## The key observation

Our inputs are **discrete 8-bit bytes (0–255)**, and each first-layer LUT is a
**256-entry table addressed by an 8-bit index**. The map `raw_byte → din` is a
fixed, per-feature function over exactly those 256 values. So it can be
**absorbed into the first-layer LUTs by re-indexing** — no separate hardware,
no size change, no retrain. (The paper can't do this for its benchmarks because
their inputs are *continuous*; a byte-discrete input is what makes it free.)

## The method (implemented in `fold_input.py`)

For layer-0 connection `(j → k)`, the mem file `lut_0_j_k.mem` has 256 lines,
where **line `i` = the LUT output for input index `din = i`**
(confirmed in `KAN_LUT._inference_sample`, layer-0 `lookup_index = sample[in]`).

1. **Compute the per-feature map** `idx[b, j]` = the din the hardware would form
   for raw byte `b` at feature `j`:
   ```
   idx[b, j] = round( input_layer(b/255)[j] / scale ) + 2^(bits−1)      # 0..255
   ```
   (`input_layer` carries the trained BN stats + bias + HardTanh + quant; it is
   element-wise per feature, so byte 12 `exe[0]` and byte 28 `path[0]` get
   different maps.) Shape `(256, 64)`.

2. **Permute each layer-0 mem** so line `b` (raw byte) holds what used to sit at
   line `idx[b, j]`:
   ```
   folded[b] = original[ idx[b, j] ]        for b = 0..255
   ```
   This is a pure re-ordering of the 256 lines — values are untouched, so no
   re-encoding and the LUT size / data width / RTL are unchanged. Originals are
   backed up to `firmware/mem/prefold_layer0/`.

3. **Layers ≥ 1 are untouched** — their inputs are already internal LUT indices
   (`running_accumulator + 2^(w−1)`), not raw external bytes.

4. **Regenerate the sim vectors** with raw bytes as `din` (drawn from real
   `X_test` events), with golden outputs from the integer reference
   (`KAN_LUT._inference_sample`), so xsim checks the folded core on raw input.

## Why it's exact

`idx[b, j]` is, by construction, the same `din` the original front-end would
produce for byte `b`. So the folded core computes
`folded_LUT[b] = original_LUT[din(b)]` = exactly what the un-folded core
produced for that byte. It is a lossless permutation, not an approximation.

## Result

- **323 layer-0 mem files** re-indexed (the active/unpruned connections); the 32
  layer-1 mems unchanged; `top.vhd`/`KAN.vhd`/`PkgLUT.vhd`/LUT sizes all unchanged.
- **xsim: 10/10 vectors match** feeding **raw packed bytes** into `din`
  (`xsim_folded.log`).
- Net effect: `din` is now literally the 64 packed record bytes
  (`syscall[0:8] | object_type[8:12] | exe[12:28] | path[28:64]`), values 0–255.
  No BatchNorm/affine/quantize block is needed anywhere. Resources & Fmax
  unchanged (same LUTs, just different contents).

## Reproduce / caveats

```bash
cd ~/KANELE/benchmarks/E5_cadets
conda run -n kanele python convert.py          # (re)generate RTL + mems (din = index)
conda run -n kanele python fold_input.py       # fold -> din = raw bytes
cd models/<tag>/firmware/sim && vivado -mode batch -source sim.tcl   # 10/10
```

- Run `fold_input.py` **after** `convert.py` (it post-processes the mems). Re-run
  it after any retrain/reconvert. To revert, restore from `prefold_layer0/`.
- Assumes 8-bit inputs whose 256 values coincide with the layer-0 LUT address
  space (true here). For wider inputs or a smaller first-layer address width the
  re-index would not be 1:1 and a small input ROM would be needed instead.
