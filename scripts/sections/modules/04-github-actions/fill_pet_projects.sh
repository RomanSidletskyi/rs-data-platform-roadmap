#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="04-github-actions-fill-pet-projects"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "04-github-actions")"
TEMPLATE_DIR="$SCRIPT_DIR/template_snapshot/pet-projects"

log "Filling GitHub Actions pet projects..."

if [[ ! -d "$TEMPLATE_DIR" ]]; then
  fail "Missing pet projects template snapshot at $TEMPLATE_DIR"
fi

rm -rf "$MODULE/pet-projects"
cp -R "$TEMPLATE_DIR" "$MODULE/pet-projects"

log "GitHub Actions pet projects created."