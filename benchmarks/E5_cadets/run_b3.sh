#!/bin/bash
# B3 "floating" raw-window pipeline: build -> smoke -> train -> eval -> matched-FN -> true-FN.
# Run inside screen:  screen -dmS b3pipe bash run_b3.sh   (re-run resumes; finished stages are skipped)
set -u
cd "$(dirname "$0")"
PY="conda run --no-capture-output -n kanele python -u"
LOG=b3_pipeline.log
log() { echo "[$(date '+%F %T')] $*" >> "$LOG"; }
P0=models/20260709_193605_undersample
B2=models/20261007_152104_undersample_b2
log "pipeline start"

if [ ! -f data_us_b3/VERIFIED ]; then
  log "BUILD start"
  $PY build_b3.py >> "$LOG" 2>&1 || { log "BUILD FAILED"; exit 1; }
fi
log "BUILD ok"

if $PY eval_b2.py "$B2" --enc=b3 --smoke >> "$LOG" 2>&1; then log "SMOKE ok"
else log "SMOKE FAILED (continuing to training)"; fi

if [ ! -f b3_model_dir.txt ]; then
  log "TRAIN start"
  $PY train_under_sample.py --data_dir data_us_b3 > b3_train.out 2>&1 || { log "TRAIN FAILED"; exit 1; }
  D=$(grep -oE "models/[0-9]{8}_[0-9]{6}_undersample" b3_train.out | tail -1)
  mv "$D" "${D}_b3" && echo "${D}_b3" > b3_model_dir.txt
fi
MD=$(cat b3_model_dir.txt)
log "TRAIN ok -> $MD"

[ -f B3_RESULTS.md ] || $PY eval_b2.py "$MD" --enc=b3 >> "$LOG" 2>&1 || { log "EVAL FAILED"; exit 1; }
log "EVAL ok -> B3_RESULTS.md"

$PY compare_matched.py "parsed:$P0:data_us" "B2:$B2:data_us_b2" "B3:$MD:data_us_b3" >> "$LOG" 2>&1 \
  && log "MATCHED ok -> MATCHED_FN.md" || log "MATCHED FAILED"

$PY fn_true.py "$MD" --enc=b3 >> "$LOG" 2>&1 && log "FNTRUE ok -> FN_TRUE_B3.txt" || log "FNTRUE FAILED"
log "B3PIPELINEDONE"
