#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "${0%/*}" && pwd)
PROJECT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
SUMMARY_OUTPUT=$(/usr/bin/mktemp)
CONTRACT_OUTPUT=$(/usr/bin/mktemp)
trap '/bin/rm -f "$SUMMARY_OUTPUT" "$CONTRACT_OUTPUT"' EXIT

python3 "$PROJECT_DIR/src/build_order_journey_summary.py" \
  "$PROJECT_DIR/data/sample_backbone_events.jsonl" > "$SUMMARY_OUTPUT"

python3 "$PROJECT_DIR/src/check_event_backbone_contracts.py" \
  "$PROJECT_DIR/data/sample_bad_backbone_events.jsonl" > "$CONTRACT_OUTPUT"

python3 - "$PROJECT_DIR" "$SUMMARY_OUTPUT" "$CONTRACT_OUTPUT" <<'PY'
import json
import pathlib
import sys

project_dir = pathlib.Path(sys.argv[1])
summary_path = pathlib.Path(sys.argv[2])
contract_path = pathlib.Path(sys.argv[3])

expected_summary = json.loads((project_dir / "tests" / "fixture_expected_order_journey_summary.json").read_text(encoding="utf-8"))
actual_summary = json.loads(summary_path.read_text(encoding="utf-8"))

if actual_summary != expected_summary:
    raise SystemExit("order journey summary does not match expected fixture")

expected_contract = (project_dir / "tests" / "fixture_expected_contract_check.txt").read_text(encoding="utf-8").strip()
actual_contract = contract_path.read_text(encoding="utf-8").strip()

if actual_contract != expected_contract:
    raise SystemExit("contract check output does not match expected fixture")
PY

printf 'backbone-asset-check=pass\n'