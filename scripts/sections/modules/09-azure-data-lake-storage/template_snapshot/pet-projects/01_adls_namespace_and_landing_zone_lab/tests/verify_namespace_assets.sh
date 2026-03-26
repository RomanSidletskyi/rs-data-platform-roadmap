#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

python3 src/check_namespace_contract.py config/landing_zone_blueprint.json | diff -u tests/fixture_expected_namespace_check.txt -
python3 src/plan_landing_zone.py config/landing_zone_blueprint.json | diff -u tests/fixture_expected_landing_plan.json -
python3 src/preview_storage_layout.py data/sample_storage_objects.json | diff -u tests/fixture_expected_layout_preview.json -
python3 src/review_namespace_risks.py data/sample_storage_objects_edge_case.json | diff -u tests/fixture_expected_namespace_risks.json -
python3 src/run_local_namespace_pipeline.py config/landing_zone_blueprint.json data/sample_storage_objects.json | diff -u tests/fixture_expected_local_namespace_pipeline.json -
printf 'namespace-assets=pass\n'
