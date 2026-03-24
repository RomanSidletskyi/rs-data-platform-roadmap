#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
artifact_path="$project_dir/artifacts/customer_current_state_preview.json"

python3 "$project_dir/src/run_local_cdc_pipeline.py" \
  "$project_dir/config/customer_cdc_rules.yaml" \
  "$project_dir/data/sample_customer_cdc.jsonl" \
  "$artifact_path"

echo "artifact_path=$artifact_path"
