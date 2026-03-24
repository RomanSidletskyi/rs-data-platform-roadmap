#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "${0%/*}" && pwd)
PROJECT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
GOLD_OUTPUT=$(/usr/bin/mktemp)
JOB_OUTPUT=$(/usr/bin/mktemp)
trap '/bin/rm -f "$GOLD_OUTPUT" "$JOB_OUTPUT"' EXIT

python3 "$PROJECT_DIR/src/build_gold_daily_revenue.py" \
  "$PROJECT_DIR/data/sample_orders_bronze.jsonl" > "$GOLD_OUTPUT"

python3 "$PROJECT_DIR/src/check_job_definition.py" \
  "$PROJECT_DIR/config/job_definition.json" > "$JOB_OUTPUT"

python3 - "$PROJECT_DIR" "$GOLD_OUTPUT" "$JOB_OUTPUT" <<'PY'
import json
import pathlib
import sys

project_dir = pathlib.Path(sys.argv[1])
gold_path = pathlib.Path(sys.argv[2])
job_path = pathlib.Path(sys.argv[3])

expected_gold = json.loads((project_dir / "tests" / "fixture_expected_daily_revenue.json").read_text(encoding="utf-8"))
actual_gold = json.loads(gold_path.read_text(encoding="utf-8"))
if actual_gold != expected_gold:
    raise SystemExit("gold output does not match expected fixture")

expected_job = (project_dir / "tests" / "fixture_expected_job_check.txt").read_text(encoding="utf-8").strip()
actual_job = job_path.read_text(encoding="utf-8").strip()
if actual_job != expected_job:
    raise SystemExit("job check output does not match expected fixture")
PY

printf 'medallion-asset-check=pass\n'