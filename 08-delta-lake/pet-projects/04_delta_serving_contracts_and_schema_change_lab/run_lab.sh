#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
artifact_path="$project_dir/artifacts/serving_contract_assessment.json"

python3 "$project_dir/src/run_local_serving_pipeline.py" \
  "$project_dir/config/serving_contract.yaml" \
  "$project_dir/data/sample_daily_store_sales.jsonl" \
  "$project_dir/data/sample_breaking_schema_candidate.json" \
  "$artifact_path"

echo "artifact_path=$artifact_path"
