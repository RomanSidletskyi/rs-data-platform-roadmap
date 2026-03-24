#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash "$project_dir/run_lab.sh" >/dev/null
diff -u "$project_dir/tests/fixture_expected_local_serving_pipeline.json" "$project_dir/artifacts/serving_contract_assessment.json"

python3 -m py_compile \
	"$project_dir/src/check_serving_contract.py" \
	"$project_dir/src/review_schema_change.py" \
	"$project_dir/src/plan_serving_publish.py" \
	"$project_dir/src/run_local_serving_pipeline.py"

contract_output="$(python3 "$project_dir/src/check_serving_contract.py" "$project_dir/data/sample_daily_store_sales.jsonl")"
diff -u "$project_dir/tests/fixture_expected_serving_contract_check.txt" <(printf '%s\n' "$contract_output")

review_output="$(python3 "$project_dir/src/review_schema_change.py" "$project_dir/data/sample_breaking_schema_candidate.json")"
diff -u "$project_dir/tests/fixture_expected_schema_review.json" <(printf '%s\n' "$review_output")

plan_output="$(python3 "$project_dir/src/plan_serving_publish.py" release-2026-04-05)"
diff -u "$project_dir/tests/fixture_expected_serving_plan.json" <(printf '%s\n' "$plan_output")

local_pipeline_output="$(python3 "$project_dir/src/run_local_serving_pipeline.py" "$project_dir/config/serving_contract.yaml" "$project_dir/data/sample_daily_store_sales.jsonl" "$project_dir/data/sample_breaking_schema_candidate.json")"
diff -u "$project_dir/tests/fixture_expected_local_serving_pipeline.json" <(printf '%s\n' "$local_pipeline_output")

artifact_path="$project_dir/artifacts/generated_serving_contract_assessment.json"
rm -f "$artifact_path"
python3 "$project_dir/src/run_local_serving_pipeline.py" \
	"$project_dir/config/serving_contract.yaml" \
	"$project_dir/data/sample_daily_store_sales.jsonl" \
	"$project_dir/data/sample_breaking_schema_candidate.json" \
	"$artifact_path" >/dev/null
diff -u "$project_dir/tests/fixture_expected_local_serving_pipeline.json" "$artifact_path"

grep -F "CREATE OR REPLACE VIEW analytics.daily_store_sales AS" "$project_dir/src/create_official_consumer_view.sql" >/dev/null
grep -F "FROM gold.daily_store_sales" "$project_dir/src/create_official_consumer_view.sql" >/dev/null

echo "delta-serving-assets=pass"
