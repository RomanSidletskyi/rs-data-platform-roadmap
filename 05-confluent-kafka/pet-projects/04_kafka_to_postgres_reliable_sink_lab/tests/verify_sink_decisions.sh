#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "${0%/*}" && pwd)
PROJECT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)

python3 - "$PROJECT_DIR" <<'PY'
import json
import pathlib
import sys

project_dir = pathlib.Path(sys.argv[1])
src_dir = project_dir / "src"
sys.path.insert(0, str(src_dir))

from order_sink_helpers import build_dlq_record, build_upsert_record, parse_event

valid_line = (project_dir / "data" / "sample_order_events.jsonl").read_text(encoding="utf-8").splitlines()[0]
bad_line = (project_dir / "data" / "sample_bad_order_events.jsonl").read_text(encoding="utf-8").splitlines()[1]

valid_payload = parse_event(valid_line)
bad_payload = parse_event(bad_line)

actual_valid = build_upsert_record(valid_payload)
actual_dlq = build_dlq_record(
    bad_payload,
    error_type="validation_error",
    error_reason="missing required fields: order_id",
    failed_at="2026-03-24T12:00:00Z",
)

expected_valid = json.loads((project_dir / "tests" / "fixture_expected_valid_upsert_record.json").read_text(encoding="utf-8"))
expected_dlq = json.loads((project_dir / "tests" / "fixture_expected_dlq_record.json").read_text(encoding="utf-8"))

if actual_valid != expected_valid:
    raise SystemExit("valid upsert record does not match expected fixture")

if actual_dlq != expected_dlq:
    raise SystemExit("DLQ record does not match expected fixture")

print("sink-decision-check=pass")
PY