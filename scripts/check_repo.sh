#!/usr/bin/env bash

set -euo pipefail

SCRIPT_NAME="check-repo"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/lib/common.sh"

REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SECTIONS_ROOT="$REPO_ROOT/scripts/sections"
MODULES_ROOT="$SECTIONS_ROOT/modules"

print_usage() {
  cat <<'EOF'
Usage:
  ./scripts/check_repo.sh
  ./scripts/check_repo.sh all
  ./scripts/check_repo.sh foundational
  ./scripts/check_repo.sh template-backed
  ./scripts/check_repo.sh sections
  ./scripts/check_repo.sh modules
  ./scripts/check_repo.sh list

Default behavior:
  - run foundational starter-asset validation
  - run template snapshot validation for sections and modules
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

list_checks() {
  printf '%s\n' foundational template-backed sections modules all
}

is_section_target() {
  local candidate="$1"
  [[ -d "$SECTIONS_ROOT/$candidate/template_snapshot" ]]
}

is_module_target() {
  local candidate="$1"
  [[ -d "$MODULES_ROOT/$candidate/template_snapshot" ]]
}

check_snapshot_target() {
  local target="$1"
  local snapshot_dir
  local live_dir
  local -a diff_args=(-x '.DS_Store')

  if is_section_target "$target"; then
    log "Bootstrapping section $target"
    "$REPO_ROOT/scripts/bootstrap_section.sh" "$target"
    snapshot_dir="$SECTIONS_ROOT/$target/template_snapshot"
    live_dir="$REPO_ROOT/$target"
  elif is_module_target "$target"; then
    log "Bootstrapping module $target"
    "$REPO_ROOT/scripts/bootstrap_section.sh" modules "$target"
    snapshot_dir="$MODULES_ROOT/$target/template_snapshot"
    live_dir="$REPO_ROOT/$target"
    diff_args+=(-x 'PROGRESS.md')
  else
    die "Unsupported template-backed target: $target"
  fi

  if [[ ! -d "$snapshot_dir" ]]; then
    die "Missing template snapshot for $target: $snapshot_dir"
  fi

  log "Verifying snapshot sync for $target"
  if ! diff -qr "${diff_args[@]}" "$snapshot_dir" "$live_dir"; then
    warn "Snapshot drift detected for $target. Unified diff follows."
    diff -ru "${diff_args[@]}" "$snapshot_dir" "$live_dir" || true
    exit 1
  fi
}

run_foundational() {
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
  toolkit_output="$($REPO_ROOT/00-shell-linux/pet-projects/01_local_ops_toolkit/src/run_local_ops_toolkit.sh "$REPO_ROOT/00-shell-linux/pet-projects/01_local_ops_toolkit")"
  while IFS= read -r expected_line; do
    grep -F "$expected_line" <<< "$toolkit_output" >/dev/null
  done < "$REPO_ROOT/00-shell-linux/pet-projects/01_local_ops_toolkit/tests/fixture_expected_report_sections.txt"

  local incident_output
  incident_output="$($REPO_ROOT/00-shell-linux/pet-projects/03_log_triage_and_incident_debugging/src/build_incident_summary.sh)"
  diff -u "$REPO_ROOT/00-shell-linux/pet-projects/03_log_triage_and_incident_debugging/tests/fixture_expected_incident_summary.txt" <(printf '%s\n' "$incident_output") >/dev/null

  log "Validating Git starter assets"
  local hygiene_output
  hygiene_output="$($REPO_ROOT/00-git/pet-projects/01_personal_repo_hygiene_lab/src/setup_dirty_practice_repo.sh)"
  grep -F "Dirty practice repository created" <<< "$hygiene_output" >/dev/null
  test -d /tmp/git-practice/repo-hygiene-lab/.git
  test -f /tmp/git-practice/repo-hygiene-lab/.env

  local release_output
  release_output="$($REPO_ROOT/00-git/pet-projects/04_release_and_hotfix_workflow_lab/src/simulate_release_hotfix_flow.sh)"
  grep -F "Release and hotfix scenario created" <<< "$release_output" >/dev/null
  git -C /tmp/git-practice/release-hotfix-lab tag | grep -Fx 'v0.1.0' >/dev/null
  git -C /tmp/git-practice/release-hotfix-lab branch --list | grep -F 'hotfix/urgent-fix' >/dev/null

  log "Foundational starter assets are healthy."
}

run_sections() {
  local section

  while IFS= read -r section; do
    [[ -n "$section" ]] || continue
    check_snapshot_target "$section"
  done < <(discover_sections)

  log "All template-backed sections are in sync."
}

run_modules() {
  local module

  while IFS= read -r module; do
    [[ -n "$module" ]] || continue
    check_snapshot_target "$module"
  done < <(discover_modules)

  log "All template-backed modules are in sync."
}

run_template_backed() {
  run_sections
  run_modules
  log "All template-backed targets are in sync."
}

run_all() {
  run_foundational
  run_template_backed
  log "All repository checks passed."
}

case "${1:-all}" in
  all)
    run_all
    ;;
  foundational)
    run_foundational
    ;;
  template-backed)
    run_template_backed
    ;;
  sections)
    run_sections
    ;;
  modules)
    run_modules
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