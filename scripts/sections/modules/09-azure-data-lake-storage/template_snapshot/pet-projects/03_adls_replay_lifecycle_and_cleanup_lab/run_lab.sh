#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
python3 src/run_local_lifecycle_pipeline.py config/lifecycle_blueprint.json data/sample_storage_inventory.json artifacts/lifecycle_assessment.json
printf 'artifact=artifacts/lifecycle_assessment.json\n'
