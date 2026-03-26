#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash "$project_dir/run_lab.sh" >/dev/null
diff -u "$project_dir/tests/fixture_expected_local_batch_pipeline.json" "$project_dir/artifacts/daily_sales_preview.json"

python3 -m py_compile \
	"$project_dir/src/check_orders_delta_contract.py" \
	"$project_dir/src/preview_repair_window.py" \
	"$project_dir/src/plan_batch_repair.py" \
	"$project_dir/src/run_local_batch_pipeline.py"

schema_output="$(python3 "$project_dir/src/check_orders_delta_contract.py" "$project_dir/data/sample_orders_raw.jsonl")"
diff -u "$project_dir/tests/fixture_expected_schema_check.txt" <(printf '%s\n' "$schema_output")

repair_output="$(python3 "$project_dir/src/preview_repair_window.py" "$project_dir/data/sample_orders_raw.jsonl" 2026-04-01)"
diff -u "$project_dir/tests/fixture_expected_repair_window.json" <(printf '%s\n' "$repair_output")

plan_output="$(python3 "$project_dir/src/plan_batch_repair.py" 2026-04-01)"
diff -u "$project_dir/tests/fixture_expected_repair_plan.json" <(printf '%s\n' "$plan_output")

local_pipeline_output="$(python3 "$project_dir/src/run_local_batch_pipeline.py" "$project_dir/config/orders_pipeline_template.yaml" "$project_dir/data/sample_orders_raw.jsonl" 2026-04-01)"
diff -u "$project_dir/tests/fixture_expected_local_batch_pipeline.json" <(printf '%s\n' "$local_pipeline_output")

artifact_path="$project_dir/artifacts/generated_daily_sales_preview.json"
rm -f "$artifact_path"
python3 "$project_dir/src/run_local_batch_pipeline.py" \
	"$project_dir/config/orders_pipeline_template.yaml" \
	"$project_dir/data/sample_orders_raw.jsonl" \
	2026-04-01 \
	"$artifact_path" >/dev/null
diff -u "$project_dir/tests/fixture_expected_local_batch_pipeline.json" "$artifact_path"

grep -F "INSERT OVERWRITE gold.daily_sales" "$project_dir/src/rebuild_gold_for_business_date.sql" >/dev/null
grep -F "WHERE business_date = '{{ business_date }}'" "$project_dir/src/rebuild_gold_for_business_date.sql" >/dev/null

bad_output="$(python3 "$project_dir/src/check_orders_delta_contract.py" "$project_dir/data/sample_bad_orders_raw.jsonl")"
grep -F "gross_amount must be numeric" <<< "$bad_output" >/dev/null
grep -F "unsupported order_status=unknown" <<< "$bad_output" >/dev/null

echo "delta-batch-assets=pass"
