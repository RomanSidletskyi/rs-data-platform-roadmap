#!/usr/bin/env bash

set -euo pipefail

SCRIPT_NAME="check-foundational-starter-assets"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/lib/common.sh"

REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

print_usage() {
  cat <<'EOF'
Usage:
  ./scripts/check_foundational_starter_assets.sh

Default behavior:
  - bootstrap foundational generator-backed modules
  - verify foundational starter scripts remain executable
  - validate representative shell and Git starter assets
EOF
}

check_foundational_assets() {
  chmod +x "$REPO_ROOT/scripts/bootstrap_section.sh"

  git config --global user.name "Starter Assets CI"
  git config --global user.email "starter-assets-ci@example.com"

  log "Bootstrapping foundational modules"
  "$REPO_ROOT/scripts/bootstrap_section.sh" modules 00-shell-linux
  "$REPO_ROOT/scripts/bootstrap_section.sh" modules 00-git

  log "Verifying starter scripts remain executable"
  test -x "$REPO_ROOT/00-shell-linux/pet-projects/01_local_ops_toolkit/src/run_local_ops_toolkit.sh"
  test -x "$REPO_ROOT/00-shell-linux/pet-projects/02_remote_server_bootstrap_and_audit/src/render_remote_audit_plan.sh"
  test -x "$REPO_ROOT/00-shell-linux/pet-projects/03_log_triage_and_incident_debugging/src/build_incident_summary.sh"
  test -x "$REPO_ROOT/00-shell-linux/pet-projects/04_shell_automation_for_data_jobs/src/run_data_job_wrapper.sh"
  test -x "$REPO_ROOT/00-git/pet-projects/01_personal_repo_hygiene_lab/src/setup_dirty_practice_repo.sh"
  test -x "$REPO_ROOT/00-git/pet-projects/02_team_feature_branch_workflow_lab/src/simulate_feature_branch_flow.sh"
  test -x "$REPO_ROOT/00-git/pet-projects/03_incident_recovery_git_lab/src/create_recovery_scenarios.sh"
  test -x "$REPO_ROOT/00-git/pet-projects/04_release_and_hotfix_workflow_lab/src/simulate_release_hotfix_flow.sh"

  log "Validating shell starter assets"
  local toolkit_output
  toolkit_output="$("$REPO_ROOT/00-shell-linux/pet-projects/01_local_ops_toolkit/src/run_local_ops_toolkit.sh" "$REPO_ROOT/00-shell-linux/pet-projects/01_local_ops_toolkit")"
  while IFS= read -r expected_line; do
    grep -F "$expected_line" <<< "$toolkit_output" >/dev/null
  done < "$REPO_ROOT/00-shell-linux/pet-projects/01_local_ops_toolkit/tests/fixture_expected_report_sections.txt"

  local incident_output
  incident_output="$("$REPO_ROOT/00-shell-linux/pet-projects/03_log_triage_and_incident_debugging/src/build_incident_summary.sh")"
  diff -u "$REPO_ROOT/00-shell-linux/pet-projects/03_log_triage_and_incident_debugging/tests/fixture_expected_incident_summary.txt" <(printf '%s\n' "$incident_output") >/dev/null

  log "Validating Git starter assets"
  local hygiene_output
  hygiene_output="$("$REPO_ROOT/00-git/pet-projects/01_personal_repo_hygiene_lab/src/setup_dirty_practice_repo.sh")"
  grep -F "Dirty practice repository created" <<< "$hygiene_output" >/dev/null
  test -d /tmp/git-practice/repo-hygiene-lab/.git
  test -f /tmp/git-practice/repo-hygiene-lab/.env

  local release_output
  release_output="$("$REPO_ROOT/00-git/pet-projects/04_release_and_hotfix_workflow_lab/src/simulate_release_hotfix_flow.sh")"
  grep -F "Release and hotfix scenario created" <<< "$release_output" >/dev/null
  git -C /tmp/git-practice/release-hotfix-lab tag | grep -Fx 'v0.1.0' >/dev/null
  git -C /tmp/git-practice/release-hotfix-lab branch --list | grep -F 'hotfix/urgent-fix' >/dev/null

  log "Foundational starter assets are healthy."
}

case "${1:-check}" in
  check)
    check_foundational_assets
    ;;
  -h|--help|help)
    print_usage
    ;;
  *)
    print_usage
    exit 1
    ;;
esac