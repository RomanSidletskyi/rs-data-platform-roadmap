#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
python3 src/run_local_access_pipeline.py config/access_blueprint.json data/sample_access_requests.json artifacts/access_assessment.json
printf 'artifact=artifacts/access_assessment.json\n'
