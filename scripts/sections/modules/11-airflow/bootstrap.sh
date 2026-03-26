#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"

SCRIPT_NAME="11-airflow-bootstrap"

log "Starting 11-airflow bootstrap..."

bash "$SCRIPT_DIR/init.sh"
bash "$SCRIPT_DIR/fill_readme.sh"
bash "$SCRIPT_DIR/fill_learning_materials.sh"
bash "$SCRIPT_DIR/fill_simple_tasks.sh"
bash "$SCRIPT_DIR/fill_pet_projects.sh"

log "11-airflow bootstrap finished successfully."