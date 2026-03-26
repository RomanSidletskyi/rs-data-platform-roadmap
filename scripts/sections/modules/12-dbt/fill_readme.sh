#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="12-dbt-fill-readme"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "12-dbt")"
TEMPLATE_DIR="$SCRIPT_DIR/template_snapshot"

log "Creating 12-dbt README..."

if [[ ! -f "$TEMPLATE_DIR/README.md" ]]; then
  fail "Missing template snapshot README at $TEMPLATE_DIR/README.md"
fi

cp "$TEMPLATE_DIR/README.md" "$MODULE/README.md"

log "12-dbt README created."