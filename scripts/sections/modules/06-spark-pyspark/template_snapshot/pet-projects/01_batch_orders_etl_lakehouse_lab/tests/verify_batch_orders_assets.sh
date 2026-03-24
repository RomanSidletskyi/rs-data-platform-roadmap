#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

preview_output=$(python3 "$ROOT_DIR/src/preview_daily_orders_gold.py" "$ROOT_DIR/data/sample_orders_raw.jsonl")
schema_output=$(python3 "$ROOT_DIR/src/check_orders_schema_contract.py" "$ROOT_DIR/data/sample_bad_orders_raw.jsonl")

preview_file=$(mktemp)
schema_file=$(mktemp)
trap 'rm -f "$preview_file" "$schema_file"' EXIT

printf '%s' "$preview_output" > "$preview_file"
printf '%s' "$schema_output" > "$schema_file"

diff -u "$ROOT_DIR/tests/fixture_expected_daily_orders_gold.json" "$preview_file" >/dev/null
diff -u "$ROOT_DIR/tests/fixture_expected_schema_check.txt" "$schema_file" >/dev/null

printf 'batch-orders-asset-check=pass\n'