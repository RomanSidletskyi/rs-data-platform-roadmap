#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "${0%/*}" && pwd)
PROJECT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
PROJECTION_OUTPUT=$(/usr/bin/mktemp)
CHECK_OUTPUT=$(/usr/bin/mktemp)
trap '/bin/rm -f "$PROJECTION_OUTPUT" "$CHECK_OUTPUT"' EXIT

python3 "$PROJECT_DIR/src/build_order_serving_projection.py" \
  "$PROJECT_DIR/data/sample_kafka_order_events.jsonl" > "$PROJECTION_OUTPUT"

python3 "$PROJECT_DIR/src/check_serving_contract.py" \
  "$PROJECT_DIR/config/job_definition.json" \
  "$PROJECT_DIR/config/warehouse_contract.json" > "$CHECK_OUTPUT"

python3 - "$PROJECT_DIR" "$PROJECTION_OUTPUT" "$CHECK_OUTPUT" <<'PY'
import json
import pathlib
import sys

project_dir = pathlib.Path(sys.argv[1])
projection_path = pathlib.Path(sys.argv[2])
check_path = pathlib.Path(sys.argv[3])

expected_projection = json.loads((project_dir / "tests" / "fixture_expected_serving_projection.json").read_text(encoding="utf-8"))
actual_projection = json.loads(projection_path.read_text(encoding="utf-8"))
if actual_projection != expected_projection:
    raise SystemExit("serving projection does not match expected fixture")

expected_check = (project_dir / "tests" / "fixture_expected_serving_check.txt").read_text(encoding="utf-8").strip()
actual_check = check_path.read_text(encoding="utf-8").strip()
if actual_check != expected_check:
    raise SystemExit("serving check output does not match expected fixture")
PY

printf 'serving-asset-check=pass\n'