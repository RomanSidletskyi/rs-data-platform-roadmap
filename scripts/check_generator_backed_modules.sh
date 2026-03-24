#!/usr/bin/env bash

set -euo pipefail

SCRIPT_NAME="check-generator-backed-modules"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/lib/common.sh"

REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
GENERATOR_MODULES=(
  00-shell-linux
  00-git
  02-sql
  03-docker
  04-github-actions
  11-airflow
  12-dbt
  15-raspberry-pi-homelab
)

print_usage() {
  cat <<'EOF'
Usage:
  ./scripts/check_generator_backed_modules.sh
  ./scripts/check_generator_backed_modules.sh list

Default behavior:
  - bootstrap all generator-backed modules
  - verify each module matches its template_snapshot
EOF
}

list_modules() {
  for module in "${GENERATOR_MODULES[@]}"; do
    printf '%s\n' "$module"
  done
}

check_modules() {
  chmod +x "$REPO_ROOT/scripts/bootstrap_section.sh"

  for module in "${GENERATOR_MODULES[@]}"; do
    log "Bootstrapping $module"
    "$REPO_ROOT/scripts/bootstrap_section.sh" modules "$module"
  done

  for module in "${GENERATOR_MODULES[@]}"; do
    local snapshot_dir="$REPO_ROOT/scripts/sections/modules/$module/template_snapshot"
    local module_dir="$REPO_ROOT/$module"

    if [[ ! -d "$snapshot_dir" ]]; then
      die "Missing template snapshot for $module: $snapshot_dir"
    fi

    log "Verifying snapshot sync for $module"
    if ! diff -qr "$snapshot_dir" "$module_dir"; then
      warn "Snapshot drift detected for $module. Unified diff follows."
      diff -ru "$snapshot_dir" "$module_dir" || true
      exit 1
    fi
  done

  log "All generator-backed modules are in sync."
}

case "${1:-check}" in
  check)
    check_modules
    ;;
  list)
    list_modules
    ;;
  -h|--help|help)
    print_usage
    ;;
  *)
    print_usage
    exit 1
    ;;
esac