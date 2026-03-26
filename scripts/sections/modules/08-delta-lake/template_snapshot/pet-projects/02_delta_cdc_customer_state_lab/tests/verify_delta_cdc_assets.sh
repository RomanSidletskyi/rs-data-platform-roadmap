#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash "$project_dir/run_lab.sh" >/dev/null
diff -u "$project_dir/tests/fixture_expected_local_cdc_pipeline.json" "$project_dir/artifacts/customer_current_state_preview.json"

python3 -m py_compile \
	"$project_dir/src/check_customer_cdc_keys.py" \
	"$project_dir/src/preview_customer_current_state.py" \
	"$project_dir/src/plan_customer_merge.py" \
	"$project_dir/src/run_local_cdc_pipeline.py"

check_output="$(python3 "$project_dir/src/check_customer_cdc_keys.py" "$project_dir/data/sample_customer_cdc.jsonl")"
diff -u "$project_dir/tests/fixture_expected_cdc_check.txt" <(printf '%s\n' "$check_output")

current_state_output="$(python3 "$project_dir/src/preview_customer_current_state.py" "$project_dir/data/sample_customer_cdc.jsonl")"
diff -u "$project_dir/tests/fixture_expected_customer_current_state.json" <(printf '%s\n' "$current_state_output")

plan_output="$(python3 "$project_dir/src/plan_customer_merge.py" batch-001)"
diff -u "$project_dir/tests/fixture_expected_merge_plan.json" <(printf '%s\n' "$plan_output")

local_pipeline_output="$(python3 "$project_dir/src/run_local_cdc_pipeline.py" "$project_dir/config/customer_cdc_rules.yaml" "$project_dir/data/sample_customer_cdc.jsonl")"
diff -u "$project_dir/tests/fixture_expected_local_cdc_pipeline.json" <(printf '%s\n' "$local_pipeline_output")

artifact_path="$project_dir/artifacts/generated_customer_current_state_preview.json"
rm -f "$artifact_path"
python3 "$project_dir/src/run_local_cdc_pipeline.py" \
	"$project_dir/config/customer_cdc_rules.yaml" \
	"$project_dir/data/sample_customer_cdc.jsonl" \
	"$artifact_path" >/dev/null
diff -u "$project_dir/tests/fixture_expected_local_cdc_pipeline.json" "$artifact_path"

grep -F "MERGE INTO silver.customer_current_state" "$project_dir/src/merge_customer_current_state.sql" >/dev/null
grep -F "WHEN MATCHED AND source.op = 'delete' THEN DELETE" "$project_dir/src/merge_customer_current_state.sql" >/dev/null

bad_output="$(python3 "$project_dir/src/check_customer_cdc_keys.py" "$project_dir/data/sample_bad_customer_cdc.jsonl")"
grep -F "unsupported op=remove" <<< "$bad_output" >/dev/null
grep -F "customer_id must not be empty" <<< "$bad_output" >/dev/null

echo "delta-cdc-assets=pass"
