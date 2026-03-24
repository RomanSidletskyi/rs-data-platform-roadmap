#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

python3 src/check_replay_boundary.py config/lifecycle_blueprint.json | diff -u tests/fixture_expected_replay_check.txt -
python3 src/plan_cleanup_actions.py config/lifecycle_blueprint.json data/sample_storage_inventory.json | diff -u tests/fixture_expected_cleanup_plan.json -
python3 src/review_cleanup_risks.py config/lifecycle_blueprint.json data/sample_storage_inventory_edge_case.json | diff -u tests/fixture_expected_cleanup_risks.json -
python3 src/preview_retention_windows.py config/lifecycle_blueprint.json | diff -u tests/fixture_expected_retention_preview.json -
python3 src/run_local_lifecycle_pipeline.py config/lifecycle_blueprint.json data/sample_storage_inventory.json | diff -u tests/fixture_expected_local_lifecycle_pipeline.json -
printf 'lifecycle-assets=pass\n'
