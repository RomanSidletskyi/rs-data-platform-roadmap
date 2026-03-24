#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="00-git-fill-pet-projects"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "00-git")"
TEMPLATE_DIR="$SCRIPT_DIR/template_snapshot/pet-projects"

log "Filling Git pet projects..."

if [[ ! -d "$TEMPLATE_DIR" ]]; then
  fail "Missing pet projects template snapshot at $TEMPLATE_DIR"
fi

rm -rf "$MODULE/pet-projects"
cp -R "$TEMPLATE_DIR" "$MODULE/pet-projects"

log "Git pet projects created."