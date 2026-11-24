#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd -P)"
RUN_TMP_DIR=""

usage() {
  cat <<'EOF'
Usage:
  ./scripts/check_repo.sh
  ./scripts/check_repo.sh all
  ./scripts/check_repo.sh structure
  ./scripts/check_repo.sh foundational
  ./scripts/check_repo.sh list

Checks are read-only with respect to repository content. The foundational mode
runs starter-asset smoke checks in a temporary directory and never changes
Git's global configuration.
EOF
}

log() {
  printf '[check-repo] INFO  %s\n' "$1"
}

fail() {
  printf '[check-repo] ERROR %s\n' "$1" >&2
  exit 1
}

cleanup() {
  if [[ -n "$RUN_TMP_DIR" && -d "$RUN_TMP_DIR" ]]; then
    rm -rf "$RUN_TMP_DIR"
  fi
}
trap cleanup EXIT

check_module_shape() {
  local module_dir="$1"
  local required_path

  [[ -f "$module_dir/README.md" ]] || fail "Missing module README: ${module_dir#"$REPO_ROOT"/}/README.md"
  for required_path in learning-materials simple-tasks pet-projects; do
    [[ -d "$module_dir/$required_path" ]] || fail "Missing module directory: ${module_dir#"$REPO_ROOT"/}/$required_path"
  done
}

run_structure() {
  local module_dir
  local database_module_dir
  local required_path

  for required_path in README.md docs/README.md docs/learning-sequence.md docs/data-platform-map.md docs/learning-progress.md scripts/README.md structure.txt; do
    [[ -f "$REPO_ROOT/$required_path" ]] || fail "Missing repository entrypoint: $required_path"
  done

  shopt -s nullglob
  for module_dir in "$REPO_ROOT"/[0-9][0-9]-*; do
    [[ -d "$module_dir" ]] || continue
    case "$(basename "$module_dir")" in
      10-powerbi-fabric|13-flink|14-iceberg)
        continue
        ;;
      16-cloud-databases)
        [[ -f "$module_dir/README.md" ]] || fail "Missing cloud database index README"
        for database_module_dir in "$module_dir"/[0-9][0-9]-*; do
          [[ -d "$database_module_dir" ]] || continue
          check_module_shape "$database_module_dir"
        done
        ;;
      *)
        check_module_shape "$module_dir"
        ;;
    esac
  done
  shopt -u nullglob

  [[ -d "$REPO_ROOT/real-projects" ]] || fail "Missing real-projects directory"
  [[ -f "$REPO_ROOT/real-projects/README.md" ]] || fail "Missing real-projects README"
  log "Repository and module structure is healthy."
}

run_foundational() {
  local toolkit_output
  local incident_output
  local hygiene_output
  local release_output

  RUN_TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/rs-data-platform-check.XXXXXX")"
  export PRACTICE_ROOT="$RUN_TMP_DIR/git-practice"
  export GIT_CONFIG_NOSYSTEM=1
  export GIT_AUTHOR_NAME="Starter Assets CI"
  export GIT_AUTHOR_EMAIL="starter-assets-ci@example.com"
  export GIT_COMMITTER_NAME="Starter Assets CI"
  export GIT_COMMITTER_EMAIL="starter-assets-ci@example.com"

  log "Validating starter scripts remain executable"
  test -x "$REPO_ROOT/00-shell-linux/pet-projects/01_local_ops_toolkit/src/run_local_ops_toolkit.sh"
  test -x "$REPO_ROOT/00-shell-linux/pet-projects/02_remote_server_bootstrap_and_audit/src/render_remote_audit_plan.sh"
  test -x "$REPO_ROOT/00-shell-linux/pet-projects/03_log_triage_and_incident_debugging/src/build_incident_summary.sh"
  test -x "$REPO_ROOT/00-shell-linux/pet-projects/04_shell_automation_for_data_jobs/src/run_data_job_wrapper.sh"
  test -x "$REPO_ROOT/00-git/pet-projects/01_personal_repo_hygiene_lab/src/setup_dirty_practice_repo.sh"
  test -x "$REPO_ROOT/00-git/pet-projects/02_team_feature_branch_workflow_lab/src/simulate_feature_branch_flow.sh"
  test -x "$REPO_ROOT/00-git/pet-projects/03_incident_recovery_git_lab/src/create_recovery_scenarios.sh"
  test -x "$REPO_ROOT/00-git/pet-projects/04_release_and_hotfix_workflow_lab/src/simulate_release_hotfix_flow.sh"

  log "Validating shell starter assets"
  toolkit_output="$("$REPO_ROOT/00-shell-linux/pet-projects/01_local_ops_toolkit/src/run_local_ops_toolkit.sh" "$REPO_ROOT/00-shell-linux/pet-projects/01_local_ops_toolkit")"
  while IFS= read -r expected_line; do
    grep -F "$expected_line" <<< "$toolkit_output" >/dev/null
  done < "$REPO_ROOT/00-shell-linux/pet-projects/01_local_ops_toolkit/tests/fixture_expected_report_sections.txt"

  incident_output="$("$REPO_ROOT/00-shell-linux/pet-projects/03_log_triage_and_incident_debugging/src/build_incident_summary.sh")"
  diff -u "$REPO_ROOT/00-shell-linux/pet-projects/03_log_triage_and_incident_debugging/tests/fixture_expected_incident_summary.txt" <(printf '%s\n' "$incident_output") >/dev/null

  log "Validating Git starter assets in temporary repositories"
  hygiene_output="$("$REPO_ROOT/00-git/pet-projects/01_personal_repo_hygiene_lab/src/setup_dirty_practice_repo.sh")"
  grep -F "Dirty practice repository created" <<< "$hygiene_output" >/dev/null
  test -d "$PRACTICE_ROOT/repo-hygiene-lab/.git"
  test -f "$PRACTICE_ROOT/repo-hygiene-lab/.env"

  release_output="$("$REPO_ROOT/00-git/pet-projects/04_release_and_hotfix_workflow_lab/src/simulate_release_hotfix_flow.sh")"
  grep -F "Release and hotfix scenario created" <<< "$release_output" >/dev/null
  git -C "$PRACTICE_ROOT/release-hotfix-lab" tag | grep -Fx 'v0.1.0' >/dev/null
  git -C "$PRACTICE_ROOT/release-hotfix-lab" branch --list | grep -F 'hotfix/urgent-fix' >/dev/null

  log "Foundational starter assets are healthy."
}

case "${1:-all}" in
  all)
    run_structure
    run_foundational
    log "All repository checks passed."
    ;;
  structure)
    run_structure
    ;;
  foundational)
    run_foundational
    ;;
  list)
    printf '%s\n' structure foundational all
    ;;
  -h|--help|help)
    usage
    ;;
  *)
    usage >&2
    exit 1
    ;;
esac