#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="00-shell-linux-init"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "00-shell-linux")"

SIMPLE_TASKS=(
  "01_navigation_and_files"
  "02_text_reading_and_redirection"
  "03_search_filter_and_extract"
  "04_permissions_and_execution"
  "05_process_and_signal_tasks"
  "06_environment_and_path_tasks"
  "07_ssh_and_remote_tasks"
  "08_shell_scripting_tasks"
)

PET_PROJECTS=(
  "01_local_ops_toolkit"
  "02_remote_server_bootstrap_and_audit"
  "03_log_triage_and_incident_debugging"
  "04_shell_automation_for_data_jobs"
)

log "Creating 00-shell-linux structure..."

ensure_dir "$MODULE"
ensure_dir "$MODULE/learning-materials"
ensure_dir "$MODULE/simple-tasks"
ensure_dir "$MODULE/pet-projects"

for task_dir in "${SIMPLE_TASKS[@]}"; do
  ensure_dir "$MODULE/simple-tasks/$task_dir"
  ensure_gitkeep "$MODULE/simple-tasks/$task_dir"
done

for project_dir in "${PET_PROJECTS[@]}"; do
  ensure_dir "$MODULE/pet-projects/$project_dir"
  ensure_dir "$MODULE/pet-projects/$project_dir/config"
  ensure_dir "$MODULE/pet-projects/$project_dir/data"
  ensure_dir "$MODULE/pet-projects/$project_dir/docker"
  ensure_dir "$MODULE/pet-projects/$project_dir/src"
  ensure_dir "$MODULE/pet-projects/$project_dir/tests"

  ensure_gitkeep "$MODULE/pet-projects/$project_dir/config"
  ensure_gitkeep "$MODULE/pet-projects/$project_dir/data"
  ensure_gitkeep "$MODULE/pet-projects/$project_dir/docker"
  ensure_gitkeep "$MODULE/pet-projects/$project_dir/src"
  ensure_gitkeep "$MODULE/pet-projects/$project_dir/tests"
done

ensure_gitkeep "$MODULE/learning-materials"

log "00-shell-linux structure initialized."