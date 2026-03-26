#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"

SCRIPT_NAME="shared-fill-readme"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
SECTION_ROOT="$REPO_ROOT/shared"
TEMPLATE_FILE="$SCRIPT_DIR/template_snapshot/README.md"

log "Creating shared README..."

copy_file_from_template "$TEMPLATE_FILE" "$SECTION_ROOT/README.md"

log "Shared README created."