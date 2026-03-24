#!/usr/bin/env bash

set -euo pipefail

SCRIPT_NAME="bootstrap-section"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SECTIONS_DIR="$SCRIPT_DIR/sections"

SPECIAL_SECTIONS=(
  docs
  shared
  ai-learning
  real-projects
)

usage() {
  cat <<'EOF'
Usage:
  ./scripts/bootstrap_section.sh <section>
  ./scripts/bootstrap_section.sh modules <module-name>
  ./scripts/bootstrap_section.sh modules --all
  ./scripts/bootstrap_section.sh all

Supported sections:
  docs
  shared
  ai-learning
  real-projects
  modules
  all
EOF
}

log() {
  printf '[%s] INFO  %s\n' "$SCRIPT_NAME" "$1"
}

run_all() {
  local section
  local module_dir

  log "Bootstrapping repository sections..."
  for section in "${SPECIAL_SECTIONS[@]}"; do
    bash "$SCRIPT_DIR/bootstrap_section.sh" "$section"
  done

  log "Bootstrapping all script-backed modules..."
  shopt -s nullglob
  for module_dir in "$SECTIONS_DIR"/modules/*; do
    if [[ -d "$module_dir" ]]; then
      bash "$SCRIPT_DIR/bootstrap_section.sh" modules "$(basename "$module_dir")"
    fi
  done
  shopt -u nullglob

  log "Repository bootstrap finished successfully."
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

SECTION="$1"
NAME="${2:-}"

case "$SECTION" in
  all)
    run_all
    ;;

  modules)
    if [[ -z "$NAME" ]]; then
      echo "[ERROR] modules requires module name or --all"
      exit 1
    fi

    if [[ "$NAME" == "--all" ]]; then
      shopt -s nullglob
      for module_dir in "$SECTIONS_DIR"/modules/*; do
        if [[ -d "$module_dir" ]]; then
          bash "$module_dir/bootstrap.sh"
        fi
      done
      shopt -u nullglob
      exit 0
    fi

    MODULE_DIR="$SECTIONS_DIR/modules/$NAME"

    if [[ ! -d "$MODULE_DIR" ]]; then
      echo "[ERROR] module scripts not found: $MODULE_DIR"
      exit 1
    fi

    bash "$MODULE_DIR/bootstrap.sh"
    ;;

  docs|shared|real-projects|ai-learning)
    SECTION_DIR="$SECTIONS_DIR/$SECTION"

    if [[ ! -d "$SECTION_DIR" ]]; then
      echo "[ERROR] section scripts not found: $SECTION_DIR"
      exit 1
    fi

    bash "$SECTION_DIR/bootstrap.sh"
    ;;

  *)
    echo "[ERROR] unsupported section: $SECTION"
    usage
    exit 1
    ;;
esac