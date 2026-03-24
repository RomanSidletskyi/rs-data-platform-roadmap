#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"

SCRIPT_NAME="05-confluent-kafka-bootstrap"

log "Starting 05-confluent-kafka bootstrap..."

bash "$SCRIPT_DIR/init.sh"
bash "$SCRIPT_DIR/fill_readme.sh"
bash "$SCRIPT_DIR/fill_learning_materials.sh"
bash "$SCRIPT_DIR/fill_simple_tasks.sh"
bash "$SCRIPT_DIR/fill_pet_projects.sh"

log "05-confluent-kafka bootstrap finished successfully."