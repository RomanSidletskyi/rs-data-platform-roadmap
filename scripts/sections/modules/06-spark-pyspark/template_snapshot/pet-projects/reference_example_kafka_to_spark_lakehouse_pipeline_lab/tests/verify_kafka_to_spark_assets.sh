#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

bronze_output=$(python3 "$ROOT_DIR/src/normalize_kafka_orders_to_bronze.py" "$ROOT_DIR/data/sample_kafka_order_events.jsonl")
silver_output=$(python3 "$ROOT_DIR/src/build_silver_order_status.py" "$ROOT_DIR/data/sample_kafka_order_events.jsonl")

bronze_file=$(mktemp)
silver_file=$(mktemp)
trap 'rm -f "$bronze_file" "$silver_file"' EXIT

printf '%s' "$bronze_output" > "$bronze_file"
printf '%s' "$silver_output" > "$silver_file"

diff -u "$ROOT_DIR/tests/fixture_expected_bronze_output.json" "$bronze_file" >/dev/null
diff -u "$ROOT_DIR/tests/fixture_expected_silver_output.json" "$silver_file" >/dev/null

printf 'kafka-to-spark-reference-check=pass\n'