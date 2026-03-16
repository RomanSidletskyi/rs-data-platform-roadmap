#!/usr/bin/env bash

set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <module-name>"
  echo "Example: $0 03-docker"
  exit 1
fi

MODULE="$1"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULE_SCRIPT_DIR="$SCRIPT_DIR/sections/modules/$MODULE"

create_dir() {
  local dir="$1"

  if [ -d "$dir" ]; then
    echo "[SKIP] dir exists: $dir"
  else
    mkdir -p "$dir"
    echo "[CREATE] dir: $dir"
  fi
}

create_file() {
  local file="$1"

  if [ -f "$file" ]; then
    echo "[SKIP] file exists: $file"
  else
    mkdir -p "$(dirname "$file")"
    touch "$file"
    echo "[CREATE] file: $file"
  fi
}

echo "Creating scripts for module: $MODULE"

create_dir "$MODULE_SCRIPT_DIR"

create_file "$MODULE_SCRIPT_DIR/init.sh"
create_file "$MODULE_SCRIPT_DIR/fill_learning_materials.sh"
create_file "$MODULE_SCRIPT_DIR/fill_simple_tasks.sh"
create_file "$MODULE_SCRIPT_DIR/fill_pet_projects.sh"
create_file "$MODULE_SCRIPT_DIR/bootstrap.sh"

echo ""
echo "Module scaffolding created:"
echo "scripts/sections/modules/$MODULE/"
echo ""
echo "Next steps:"
echo "1. Implement logic in the created scripts"
echo "2. Run:"
echo "./scripts/bootstrap_section.sh modules $MODULE"