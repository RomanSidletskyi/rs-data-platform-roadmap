#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"

SCRIPT_NAME="real-projects-bootstrap"

log "Starting real-projects bootstrap..."

bash "$SCRIPT_DIR/init.sh"
bash "$SCRIPT_DIR/fill_readme.sh"
bash "$SCRIPT_DIR/fill_content.sh"

log "Real-projects bootstrap finished successfully."
