#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="03-docker-fill-learning-materials"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "03-docker")"
TEMPLATE_DIR="$SCRIPT_DIR/template_snapshot/learning-materials"

log "Creating learning materials..."

if [[ ! -d "$TEMPLATE_DIR" ]]; then
  fail "Missing learning materials template snapshot at $TEMPLATE_DIR"
fi

rm -rf "$MODULE/learning-materials"
cp -R "$TEMPLATE_DIR" "$MODULE/learning-materials"

log "Learning materials created."