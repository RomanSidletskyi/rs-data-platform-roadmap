#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
python3 src/run_local_contract_pipeline.py config/consumer_contract.json data/sample_consumer_requests.json artifacts/consumer_contract_assessment.json
printf 'artifact=artifacts/consumer_contract_assessment.json\n'
