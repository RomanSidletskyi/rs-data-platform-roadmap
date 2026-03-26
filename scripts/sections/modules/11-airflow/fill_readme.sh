#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="11-airflow-fill-readme"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "11-airflow")"
TEMPLATE_DIR="$SCRIPT_DIR/template_snapshot"

log "Creating 11-airflow README..."

if [[ ! -f "$TEMPLATE_DIR/README.md" ]]; then
  fail "Missing template snapshot README at $TEMPLATE_DIR/README.md"
fi

cp "$TEMPLATE_DIR/README.md" "$MODULE/README.md"

log "11-airflow README created."