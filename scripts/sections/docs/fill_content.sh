#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"

SCRIPT_NAME="docs-fill-content"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
SECTION_ROOT="$REPO_ROOT/docs"
TEMPLATE_DIR="$SCRIPT_DIR/template_snapshot"

log "Synchronizing docs content from template snapshot..."

sync_dir_contents_from_template "$TEMPLATE_DIR" "$SECTION_ROOT" "README.md"

log "Docs content synchronized."