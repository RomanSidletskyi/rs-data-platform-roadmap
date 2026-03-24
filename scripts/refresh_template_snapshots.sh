#!/usr/bin/env bash

set -euo pipefail

SCRIPT_NAME="refresh-template-snapshots"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/lib/common.sh"

REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SECTIONS_ROOT="$REPO_ROOT/scripts/sections"
MODULES_ROOT="$SECTIONS_ROOT/modules"

print_usage() {
  cat <<'EOF'
Usage:
  ./scripts/refresh_template_snapshots.sh
  ./scripts/refresh_template_snapshots.sh all
  ./scripts/refresh_template_snapshots.sh sections
  ./scripts/refresh_template_snapshots.sh modules
  ./scripts/refresh_template_snapshots.sh list [sections|modules]
  ./scripts/refresh_template_snapshots.sh <target-name> [target-name...]

Default behavior:
  - sync every discovered template_snapshot from live repository content

Targets:
  - top-level sections such as docs, shared, ai-learning, real-projects
  - generator-backed modules such as 00-git, 11-airflow, 12-dbt
EOF
}

discover_sections() {
  local section_dir

  shopt -s nullglob
  for section_dir in "$SECTIONS_ROOT"/*; do
    if [[ -d "$section_dir" && "$(basename "$section_dir")" != "modules" && -d "$section_dir/template_snapshot" ]]; then
      printf '%s\n' "$(basename "$section_dir")"
    fi
  done
  shopt -u nullglob
}

discover_modules() {
  local module_dir

  shopt -s nullglob
  for module_dir in "$MODULES_ROOT"/*; do
    if [[ -d "$module_dir" && -d "$module_dir/template_snapshot" ]]; then
      printf '%s\n' "$(basename "$module_dir")"
    fi
  done
  shopt -u nullglob
}

list_targets() {
  local scope="${1:-all}"

  case "$scope" in
    all)
      log "Sections with template snapshots:"
      discover_sections
      log "Modules with template snapshots:"
      discover_modules
      ;;
    sections)
      discover_sections
      ;;
    modules)
      discover_modules
      ;;
    *)
      die "Unsupported list scope: $scope"
      ;;
  esac
}

is_section_target() {
  local candidate="$1"
  [[ -d "$SECTIONS_ROOT/$candidate/template_snapshot" ]]
}

is_module_target() {
  local candidate="$1"
  [[ -d "$MODULES_ROOT/$candidate/template_snapshot" ]]
}

refresh_target() {
  local target="$1"
  local live_dir
  local snapshot_dir
  local -a rsync_args=(-a --delete --exclude '.DS_Store')

  if is_section_target "$target"; then
    live_dir="$REPO_ROOT/$target"
    snapshot_dir="$SECTIONS_ROOT/$target/template_snapshot"
  elif is_module_target "$target"; then
    live_dir="$REPO_ROOT/$target"
    snapshot_dir="$MODULES_ROOT/$target/template_snapshot"
    rsync_args+=(--exclude 'PROGRESS.md')
  else
    die "Unsupported template target: $target"
  fi

  if [[ ! -d "$live_dir" ]]; then
    die "Live directory not found: $live_dir"
  fi

  log "Refreshing template snapshot for $target"
  rsync "${rsync_args[@]}" "$live_dir/" "$snapshot_dir/"
}

refresh_sections() {
  local target

  while IFS= read -r target; do
    [[ -n "$target" ]] || continue
    refresh_target "$target"
  done < <(discover_sections)
}

refresh_modules() {
  local target

  while IFS= read -r target; do
    [[ -n "$target" ]] || continue
    refresh_target "$target"
  done < <(discover_modules)
}

refresh_named_targets() {
  local target

  for target in "$@"; do
    refresh_target "$target"
  done
}

case "${1:-all}" in
  all)
    refresh_sections
    refresh_modules
    log "All template snapshots refreshed."
    ;;
  sections)
    refresh_sections
    log "Section template snapshots refreshed."
    ;;
  modules)
    if [[ $# -eq 1 ]]; then
      refresh_modules
    else
      shift
      refresh_named_targets "$@"
    fi
    log "Module template snapshots refreshed."
    ;;
  list)
    list_targets "${2:-all}"
    ;;
  -h|--help|help)
    print_usage
    ;;
  *)
    refresh_named_targets "$@"
    log "Selected template snapshots refreshed."
    ;;
esac