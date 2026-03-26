#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"

SCRIPT_NAME="real-projects-fill-readme"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
SECTION_ROOT="$REPO_ROOT/real-projects"
TEMPLATE_FILE="$SCRIPT_DIR/template_snapshot/README.md"

log "Creating real-projects README..."

copy_file_from_template "$TEMPLATE_FILE" "$SECTION_ROOT/README.md"

log "Real-projects README created."