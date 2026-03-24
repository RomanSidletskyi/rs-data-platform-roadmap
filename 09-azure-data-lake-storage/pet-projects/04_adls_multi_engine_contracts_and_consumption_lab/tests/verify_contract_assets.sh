#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

python3 src/check_consumer_contract.py config/consumer_contract.json | diff -u tests/fixture_expected_consumer_check.txt -
python3 src/review_engine_access_paths.py data/sample_consumer_requests.json | diff -u tests/fixture_expected_engine_review.json -
python3 src/plan_publish_interface.py config/consumer_contract.json | diff -u tests/fixture_expected_publish_plan.json -
python3 src/review_schema_contract_risks.py config/consumer_contract_edge_case.json | diff -u tests/fixture_expected_schema_contract_risks.json -
python3 src/run_local_contract_pipeline.py config/consumer_contract.json data/sample_consumer_requests.json | diff -u tests/fixture_expected_local_contract_pipeline.json -
printf 'contract-assets=pass\n'
