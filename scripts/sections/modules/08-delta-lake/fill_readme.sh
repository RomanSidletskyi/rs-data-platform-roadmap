#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="08-delta-lake-fill-readme"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "08-delta-lake")"
TEMPLATE_FILE="$SCRIPT_DIR/template_snapshot/README.md"

log "Creating 08-delta-lake README..."

if [[ ! -f "$TEMPLATE_FILE" ]]; then
	fail "Missing README template snapshot at $TEMPLATE_FILE"
fi

cp "$TEMPLATE_FILE" "$MODULE/README.md"

log "08-delta-lake README created."
