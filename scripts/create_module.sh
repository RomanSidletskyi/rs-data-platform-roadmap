#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <module-name>"
  echo "Example: $0 03-docker"
  exit 1
fi

MODULE="$1"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

SCRIPT_NAME="create-module"

source "$REPO_ROOT/scripts/lib/common.sh"
source "$REPO_ROOT/scripts/lib/fs.sh"

MODULE_SCRIPT_DIR="$REPO_ROOT/scripts/sections/modules/$MODULE"

log "Creating script scaffold for module: $MODULE"

ensure_dir "$MODULE_SCRIPT_DIR"

ensure_file "$MODULE_SCRIPT_DIR/init.sh"
ensure_file "$MODULE_SCRIPT_DIR/fill_readme.sh"
ensure_file "$MODULE_SCRIPT_DIR/fill_learning_materials.sh"
ensure_file "$MODULE_SCRIPT_DIR/fill_simple_tasks.sh"
ensure_file "$MODULE_SCRIPT_DIR/fill_pet_projects.sh"
ensure_file "$MODULE_SCRIPT_DIR/bootstrap.sh"

chmod +x "$MODULE_SCRIPT_DIR/init.sh"
chmod +x "$MODULE_SCRIPT_DIR/fill_readme.sh"
chmod +x "$MODULE_SCRIPT_DIR/fill_learning_materials.sh"
chmod +x "$MODULE_SCRIPT_DIR/fill_simple_tasks.sh"
chmod +x "$MODULE_SCRIPT_DIR/fill_pet_projects.sh"
chmod +x "$MODULE_SCRIPT_DIR/bootstrap.sh"

log "Module script scaffold created: scripts/sections/modules/$MODULE"
log "Next step: implement the scripts"
log "Run with: ./scripts/bootstrap_section.sh modules $MODULE"