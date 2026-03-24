#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="08-delta-lake-fill-simple-tasks"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "08-delta-lake")"
TEMPLATE_DIR="$SCRIPT_DIR/template_snapshot/simple-tasks"

log "Creating 08-delta-lake simple tasks..."

if [[ ! -d "$TEMPLATE_DIR" ]]; then
	fail "Missing simple tasks template snapshot at $TEMPLATE_DIR"
fi

rm -rf "$MODULE/simple-tasks"
cp -R "$TEMPLATE_DIR" "$MODULE/simple-tasks"

log "08-delta-lake simple tasks created."
