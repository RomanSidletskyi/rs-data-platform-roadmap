#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"

SCRIPT_NAME="06-spark-pyspark-bootstrap"

log "Starting 06-spark-pyspark bootstrap..."

bash "$SCRIPT_DIR/init.sh"
bash "$SCRIPT_DIR/fill_readme.sh"
bash "$SCRIPT_DIR/fill_learning_materials.sh"
bash "$SCRIPT_DIR/fill_simple_tasks.sh"
bash "$SCRIPT_DIR/fill_pet_projects.sh"

log "06-spark-pyspark bootstrap finished successfully."