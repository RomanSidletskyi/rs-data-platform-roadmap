#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "${0%/*}" && pwd)
PROJECT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
ACTUAL_OUTPUT=$(/usr/bin/mktemp)
trap '/bin/rm -f "$ACTUAL_OUTPUT"' EXIT

python3 "$PROJECT_DIR/src/build_site_temperature_summary.py" \
  "$PROJECT_DIR/data/sample_telemetry_events.jsonl" > "$ACTUAL_OUTPUT"

python3 - "$PROJECT_DIR" "$ACTUAL_OUTPUT" <<'PY'
import json
import pathlib
import sys

project_dir = pathlib.Path(sys.argv[1])
actual_path = pathlib.Path(sys.argv[2])

expected = json.loads((project_dir / "tests" / "fixture_expected_site_summary.json").read_text(encoding="utf-8"))
actual = json.loads(actual_path.read_text(encoding="utf-8"))

if actual != expected:
    raise SystemExit("site summary does not match expected fixture")
PY

printf 'site-summary-check=pass\n'