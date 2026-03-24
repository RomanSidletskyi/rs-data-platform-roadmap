#!/usr/bin/env bash

set -euo pipefail

SCRIPT_NAME="run-repo-smoke-checks"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/lib/common.sh"

REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SMOKE_CHECKS=(
  foundational
  generator-backed
)

print_usage() {
  cat <<'EOF'
Usage:
  ./scripts/run_repo_smoke_checks.sh
  ./scripts/run_repo_smoke_checks.sh all
  ./scripts/run_repo_smoke_checks.sh foundational
  ./scripts/run_repo_smoke_checks.sh generator-backed
  ./scripts/run_repo_smoke_checks.sh list

Default behavior:
  - run foundational starter-asset validation
  - run generator-backed module validation
EOF
}

list_checks() {
  for check_name in "${SMOKE_CHECKS[@]}"; do
    printf '%s\n' "$check_name"
  done
}

run_foundational() {
  log "Running foundational starter-asset smoke checks"
  "$REPO_ROOT/scripts/check_foundational_starter_assets.sh"
}

run_generator_backed() {
  log "Running generator-backed module smoke checks"
  "$REPO_ROOT/scripts/check_generator_backed_modules.sh"
}

run_all() {
  run_foundational
  run_generator_backed
  log "All repository smoke checks passed."
}

case "${1:-all}" in
  all)
    run_all
    ;;
  foundational)
    run_foundational
    ;;
  generator-backed)
    run_generator_backed
    ;;
  list)
    list_checks
    ;;
  -h|--help|help)
    print_usage
    ;;
  *)
    print_usage
    exit 1
    ;;
esac