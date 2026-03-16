#!/bin/bash

set -e

ROOT="01-python/pet-projects/01_api_to_csv_pipeline"

mkdir -p \
  "$ROOT/src" \
  "$ROOT/config" \
  "$ROOT/data/raw" \
  "$ROOT/data/processed" \
  "$ROOT/logs" \
  "$ROOT/tests"

touch \
  "$ROOT/README.md" \
  "$ROOT/src/main.py" \
  "$ROOT/src/api_client.py" \
  "$ROOT/src/processor.py" \
  "$ROOT/src/writer.py" \
  "$ROOT/src/config_loader.py" \
  "$ROOT/config/config.yaml" \
  "$ROOT/requirements.txt" \
  "$ROOT/.env.example"

echo "Python API project structure created successfully at: $ROOT"