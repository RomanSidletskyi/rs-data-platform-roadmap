#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
artifact_path="$project_dir/artifacts/daily_sales_preview.json"

python3 "$project_dir/src/run_local_batch_pipeline.py" \
  "$project_dir/config/orders_pipeline_template.yaml" \
  "$project_dir/data/sample_orders_raw.jsonl" \
  2026-04-01 \
  "$artifact_path"

echo "artifact_path=$artifact_path"
