#!/bin/bash
# B2 raw-window pipeline: build -> smoke-eval -> train -> eval.
# Run inside screen:  screen -dmS b2pipe bash run_b2.sh
# Each stage is skipped if already done, so re-running resumes after an interruption.
set -u
cd "$(dirname "$0")"
PY="conda run --no-capture-output -n kanele python -u"
LOG=b2_pipeline.log
log() { echo "[$(date '+%F %T')] $*" >> "$LOG"; }
log "pipeline start"

# 1. dataset: same events/split as data_us/, B2 encoding (verified row-for-row)
if [ ! -f data_us_b2/VERIFIED ]; then
  log "BUILD start"
  $PY build_b2.py >> "$LOG" 2>&1 || { log "BUILD FAILED"; exit 1; }
fi
log "BUILD ok"

# 2. smoke-test the eval code on tiny slices (stand-in model); non-fatal
if $PY eval_b2.py models/20260709_193605_undersample --smoke >> "$LOG" 2>&1; then log "SMOKE ok"
else log "SMOKE FAILED (continuing to training; eval can be fixed and re-run)"; fi

# 3. train (unchanged trainer, only --data_dir differs); model dir renamed *_undersample_b2
if [ ! -f b2_model_dir.txt ]; then
  log "TRAIN start"
  $PY train_under_sample.py --data_dir data_us_b2 > b2_train.out 2>&1 || { log "TRAIN FAILED"; exit 1; }
  D=$(grep -oE "models/[0-9]{8}_[0-9]{6}_undersample" b2_train.out | tail -1)
  mv "$D" "${D}_b2" && echo "${D}_b2" > b2_model_dir.txt
fi
MD=$(cat b2_model_dir.txt)
log "TRAIN ok -> $MD"

# 4. evaluate B2 vs parsed on identical events (test + full dataset)
$PY eval_b2.py "$MD" >> "$LOG" 2>&1 || { log "EVAL FAILED"; exit 1; }
log "EVAL ok -> B2_RESULTS.md"
log "B2PIPELINEDONE"
