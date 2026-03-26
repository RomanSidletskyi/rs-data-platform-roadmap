#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash "$project_dir/run_lab.sh" >/dev/null
diff -u "$project_dir/tests/fixture_expected_local_quality_pipeline.json" "$project_dir/artifacts/quality_recovery_assessment.json"

python3 -m py_compile \
	"$project_dir/src/check_quality_rules.py" \
	"$project_dir/src/recommend_repair_strategy.py" \
	"$project_dir/src/plan_quality_recovery.py" \
	"$project_dir/src/run_local_quality_recovery_pipeline.py"

quality_output="$(python3 "$project_dir/src/check_quality_rules.py" "$project_dir/data/sample_shared_orders_silver.jsonl")"
diff -u "$project_dir/tests/fixture_expected_quality_check.txt" <(printf '%s\n' "$quality_output")

repair_output="$(python3 "$project_dir/src/recommend_repair_strategy.py" "$project_dir/data/sample_invalid_shared_orders_silver.jsonl")"
diff -u "$project_dir/tests/fixture_expected_repair_strategy.json" <(printf '%s\n' "$repair_output")

plan_output="$(python3 "$project_dir/src/plan_quality_recovery.py" incident-42)"
diff -u "$project_dir/tests/fixture_expected_quality_plan.json" <(printf '%s\n' "$plan_output")

local_pipeline_output="$(python3 "$project_dir/src/run_local_quality_recovery_pipeline.py" "$project_dir/config/quality_recovery_policy.yaml" "$project_dir/data/sample_invalid_shared_orders_silver.jsonl")"
diff -u "$project_dir/tests/fixture_expected_local_quality_pipeline.json" <(printf '%s\n' "$local_pipeline_output")

artifact_path="$project_dir/artifacts/generated_quality_recovery_assessment.json"
rm -f "$artifact_path"
python3 "$project_dir/src/run_local_quality_recovery_pipeline.py" \
	"$project_dir/config/quality_recovery_policy.yaml" \
	"$project_dir/data/sample_invalid_shared_orders_silver.jsonl" \
	"$artifact_path" >/dev/null
diff -u "$project_dir/tests/fixture_expected_local_quality_pipeline.json" "$artifact_path"

grep -F "FROM silver.orders_shared" "$project_dir/src/inspect_repair_scope.sql" >/dev/null
grep -F "GROUP BY business_date" "$project_dir/src/inspect_repair_scope.sql" >/dev/null

bad_output="$(python3 "$project_dir/src/check_quality_rules.py" "$project_dir/data/sample_invalid_shared_orders_silver.jsonl")"
grep -F "gross_amount must be non-negative" <<< "$bad_output" >/dev/null
grep -F "unsupported currency_code=usd" <<< "$bad_output" >/dev/null

echo "delta-quality-recovery-assets=pass"
