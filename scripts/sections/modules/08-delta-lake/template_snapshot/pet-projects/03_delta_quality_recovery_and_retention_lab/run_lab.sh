#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
artifact_path="$project_dir/artifacts/quality_recovery_assessment.json"

python3 "$project_dir/src/run_local_quality_recovery_pipeline.py" \
  "$project_dir/config/quality_recovery_policy.yaml" \
  "$project_dir/data/sample_invalid_shared_orders_silver.jsonl" \
  "$artifact_path"

echo "artifact_path=$artifact_path"
