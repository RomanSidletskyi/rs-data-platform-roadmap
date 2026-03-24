#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="00-git-init"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "00-git")"

SIMPLE_TASKS=(
  "01_repo_basics_and_first_history"
  "02_diff_and_staging_tasks"
  "03_branching_and_merge_tasks"
  "04_remote_sync_tasks"
  "05_rebase_and_conflict_tasks"
  "06_undo_and_recovery_tasks"
  "07_gitignore_and_repo_hygiene"
  "08_team_workflow_and_pr_tasks"
)

PET_PROJECTS=(
  "01_personal_repo_hygiene_lab"
  "02_team_feature_branch_workflow_lab"
  "03_incident_recovery_git_lab"
  "04_release_and_hotfix_workflow_lab"
)

log "Creating 00-git structure..."

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

log "00-git structure initialized."