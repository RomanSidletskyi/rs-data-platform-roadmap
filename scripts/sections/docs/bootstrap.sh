#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"

SCRIPT_NAME="docs-bootstrap"

log "Starting docs bootstrap..."

bash "$SCRIPT_DIR/init.sh"
bash "$SCRIPT_DIR/fill_core_docs.sh"
bash "$SCRIPT_DIR/fill_architecture.sh"
bash "$SCRIPT_DIR/fill_case_studies.sh"
bash "$SCRIPT_DIR/fill_system_design.sh"
bash "$SCRIPT_DIR/fill_tradeoffs.sh"

log "Docs bootstrap finished successfully."