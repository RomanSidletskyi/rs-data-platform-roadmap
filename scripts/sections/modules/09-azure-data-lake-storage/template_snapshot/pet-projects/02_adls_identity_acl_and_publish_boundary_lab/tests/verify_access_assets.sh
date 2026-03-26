#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

python3 src/check_access_model.py config/access_blueprint.json | diff -u tests/fixture_expected_access_check.txt -
python3 src/build_acl_assignment_plan.py config/access_blueprint.json | diff -u tests/fixture_expected_acl_plan.json -
python3 src/detect_access_risks.py config/access_blueprint_edge_case.json | diff -u tests/fixture_expected_access_risks.json -
python3 src/review_publish_boundary.py data/sample_access_requests.json | diff -u tests/fixture_expected_publish_review.json -
python3 src/run_local_access_pipeline.py config/access_blueprint.json data/sample_access_requests.json | diff -u tests/fixture_expected_local_access_pipeline.json -
printf 'access-assets=pass\n'
