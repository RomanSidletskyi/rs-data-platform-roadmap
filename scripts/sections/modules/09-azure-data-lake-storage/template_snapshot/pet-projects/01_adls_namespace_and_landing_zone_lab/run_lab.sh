#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
python3 src/run_local_namespace_pipeline.py config/landing_zone_blueprint.json data/sample_storage_objects.json artifacts/namespace_assessment.json
printf 'artifact=artifacts/namespace_assessment.json\n'
