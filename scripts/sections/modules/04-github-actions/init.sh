#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="04-github-actions-init"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "04-github-actions")"

log "Creating 04-github-actions structure..."

ensure_dir "$MODULE"

ensure_dir "$MODULE/learning-materials"

ensure_dir "$MODULE/simple-tasks"
ensure_dir "$MODULE/simple-tasks/01_first_workflow"
ensure_dir "$MODULE/simple-tasks/02_events_conditions_and_matrix"
ensure_dir "$MODULE/simple-tasks/03_python_ci_pipeline"
ensure_dir "$MODULE/simple-tasks/04_docker_build_and_release"
ensure_dir "$MODULE/simple-tasks/05_reusable_workflows_and_artifacts"
ensure_dir "$MODULE/simple-tasks/06_environments_security_and_deploys"

ensure_dir "$MODULE/pet-projects"

ensure_dir "$MODULE/pet-projects/01_python_quality_pipeline"
ensure_dir "$MODULE/pet-projects/01_python_quality_pipeline/.github/workflows"
ensure_dir "$MODULE/pet-projects/01_python_quality_pipeline/config"
ensure_dir "$MODULE/pet-projects/01_python_quality_pipeline/data"
ensure_dir "$MODULE/pet-projects/01_python_quality_pipeline/docker"
ensure_dir "$MODULE/pet-projects/01_python_quality_pipeline/src"
ensure_dir "$MODULE/pet-projects/01_python_quality_pipeline/tests"

ensure_dir "$MODULE/pet-projects/02_docker_image_ci_cd"
ensure_dir "$MODULE/pet-projects/02_docker_image_ci_cd/.github/workflows"
ensure_dir "$MODULE/pet-projects/02_docker_image_ci_cd/config"
ensure_dir "$MODULE/pet-projects/02_docker_image_ci_cd/data"
ensure_dir "$MODULE/pet-projects/02_docker_image_ci_cd/docker"
ensure_dir "$MODULE/pet-projects/02_docker_image_ci_cd/src"
ensure_dir "$MODULE/pet-projects/02_docker_image_ci_cd/tests"

ensure_dir "$MODULE/pet-projects/03_data_project_reusable_automation"
ensure_dir "$MODULE/pet-projects/03_data_project_reusable_automation/.github/workflows"
ensure_dir "$MODULE/pet-projects/03_data_project_reusable_automation/config"
ensure_dir "$MODULE/pet-projects/03_data_project_reusable_automation/data"
ensure_dir "$MODULE/pet-projects/03_data_project_reusable_automation/docker"
ensure_dir "$MODULE/pet-projects/03_data_project_reusable_automation/src"
ensure_dir "$MODULE/pet-projects/03_data_project_reusable_automation/tests"

ensure_dir "$MODULE/pet-projects/04_production_style_release_automation"
ensure_dir "$MODULE/pet-projects/04_production_style_release_automation/.github/workflows"
ensure_dir "$MODULE/pet-projects/04_production_style_release_automation/config"
ensure_dir "$MODULE/pet-projects/04_production_style_release_automation/data"
ensure_dir "$MODULE/pet-projects/04_production_style_release_automation/docker"
ensure_dir "$MODULE/pet-projects/04_production_style_release_automation/src"
ensure_dir "$MODULE/pet-projects/04_production_style_release_automation/tests"

ensure_dir "$MODULE/pet-projects/reference_example_python_quality_pipeline"
ensure_dir "$MODULE/pet-projects/reference_example_python_quality_pipeline/.github/workflows"
ensure_dir "$MODULE/pet-projects/reference_example_python_quality_pipeline/config"
ensure_dir "$MODULE/pet-projects/reference_example_python_quality_pipeline/data"
ensure_dir "$MODULE/pet-projects/reference_example_python_quality_pipeline/docker"
ensure_dir "$MODULE/pet-projects/reference_example_python_quality_pipeline/src"
ensure_dir "$MODULE/pet-projects/reference_example_python_quality_pipeline/tests"

ensure_dir "$MODULE/pet-projects/reference_example_docker_image_ci_cd"
ensure_dir "$MODULE/pet-projects/reference_example_docker_image_ci_cd/.github/workflows"
ensure_dir "$MODULE/pet-projects/reference_example_docker_image_ci_cd/config"
ensure_dir "$MODULE/pet-projects/reference_example_docker_image_ci_cd/data"
ensure_dir "$MODULE/pet-projects/reference_example_docker_image_ci_cd/docker"
ensure_dir "$MODULE/pet-projects/reference_example_docker_image_ci_cd/src"
ensure_dir "$MODULE/pet-projects/reference_example_docker_image_ci_cd/tests"

ensure_dir "$MODULE/pet-projects/reference_example_data_project_reusable_automation"
ensure_dir "$MODULE/pet-projects/reference_example_data_project_reusable_automation/.github/workflows"
ensure_dir "$MODULE/pet-projects/reference_example_data_project_reusable_automation/config"
ensure_dir "$MODULE/pet-projects/reference_example_data_project_reusable_automation/data"
ensure_dir "$MODULE/pet-projects/reference_example_data_project_reusable_automation/docker"
ensure_dir "$MODULE/pet-projects/reference_example_data_project_reusable_automation/src"
ensure_dir "$MODULE/pet-projects/reference_example_data_project_reusable_automation/tests"

ensure_dir "$MODULE/pet-projects/reference_example_production_style_release_automation"
ensure_dir "$MODULE/pet-projects/reference_example_production_style_release_automation/.github/workflows"
ensure_dir "$MODULE/pet-projects/reference_example_production_style_release_automation/config"
ensure_dir "$MODULE/pet-projects/reference_example_production_style_release_automation/data"
ensure_dir "$MODULE/pet-projects/reference_example_production_style_release_automation/docker"
ensure_dir "$MODULE/pet-projects/reference_example_production_style_release_automation/src"
ensure_dir "$MODULE/pet-projects/reference_example_production_style_release_automation/tests"

log "Adding .gitkeep files where useful..."

ensure_gitkeep "$MODULE/learning-materials"

ensure_gitkeep "$MODULE/simple-tasks/01_first_workflow"
ensure_gitkeep "$MODULE/simple-tasks/02_events_conditions_and_matrix"
ensure_gitkeep "$MODULE/simple-tasks/03_python_ci_pipeline"
ensure_gitkeep "$MODULE/simple-tasks/04_docker_build_and_release"
ensure_gitkeep "$MODULE/simple-tasks/05_reusable_workflows_and_artifacts"
ensure_gitkeep "$MODULE/simple-tasks/06_environments_security_and_deploys"

ensure_gitkeep "$MODULE/pet-projects/01_python_quality_pipeline/config"
ensure_gitkeep "$MODULE/pet-projects/01_python_quality_pipeline/data"
ensure_gitkeep "$MODULE/pet-projects/01_python_quality_pipeline/docker"
ensure_gitkeep "$MODULE/pet-projects/01_python_quality_pipeline/src"
ensure_gitkeep "$MODULE/pet-projects/01_python_quality_pipeline/tests"

ensure_gitkeep "$MODULE/pet-projects/02_docker_image_ci_cd/config"
ensure_gitkeep "$MODULE/pet-projects/02_docker_image_ci_cd/data"
ensure_gitkeep "$MODULE/pet-projects/02_docker_image_ci_cd/docker"
ensure_gitkeep "$MODULE/pet-projects/02_docker_image_ci_cd/src"
ensure_gitkeep "$MODULE/pet-projects/02_docker_image_ci_cd/tests"

ensure_gitkeep "$MODULE/pet-projects/03_data_project_reusable_automation/config"
ensure_gitkeep "$MODULE/pet-projects/03_data_project_reusable_automation/data"
ensure_gitkeep "$MODULE/pet-projects/03_data_project_reusable_automation/docker"
ensure_gitkeep "$MODULE/pet-projects/03_data_project_reusable_automation/src"
ensure_gitkeep "$MODULE/pet-projects/03_data_project_reusable_automation/tests"

ensure_gitkeep "$MODULE/pet-projects/04_production_style_release_automation/config"
ensure_gitkeep "$MODULE/pet-projects/04_production_style_release_automation/data"
ensure_gitkeep "$MODULE/pet-projects/04_production_style_release_automation/docker"
ensure_gitkeep "$MODULE/pet-projects/04_production_style_release_automation/src"
ensure_gitkeep "$MODULE/pet-projects/04_production_style_release_automation/tests"

ensure_gitkeep "$MODULE/pet-projects/reference_example_python_quality_pipeline/config"
ensure_gitkeep "$MODULE/pet-projects/reference_example_python_quality_pipeline/data"
ensure_gitkeep "$MODULE/pet-projects/reference_example_python_quality_pipeline/docker"
ensure_gitkeep "$MODULE/pet-projects/reference_example_python_quality_pipeline/src"
ensure_gitkeep "$MODULE/pet-projects/reference_example_python_quality_pipeline/tests"

ensure_gitkeep "$MODULE/pet-projects/reference_example_docker_image_ci_cd/config"
ensure_gitkeep "$MODULE/pet-projects/reference_example_docker_image_ci_cd/data"
ensure_gitkeep "$MODULE/pet-projects/reference_example_docker_image_ci_cd/docker"
ensure_gitkeep "$MODULE/pet-projects/reference_example_docker_image_ci_cd/src"
ensure_gitkeep "$MODULE/pet-projects/reference_example_docker_image_ci_cd/tests"

ensure_gitkeep "$MODULE/pet-projects/reference_example_data_project_reusable_automation/config"
ensure_gitkeep "$MODULE/pet-projects/reference_example_data_project_reusable_automation/data"
ensure_gitkeep "$MODULE/pet-projects/reference_example_data_project_reusable_automation/docker"
ensure_gitkeep "$MODULE/pet-projects/reference_example_data_project_reusable_automation/src"
ensure_gitkeep "$MODULE/pet-projects/reference_example_data_project_reusable_automation/tests"

ensure_gitkeep "$MODULE/pet-projects/reference_example_production_style_release_automation/config"
ensure_gitkeep "$MODULE/pet-projects/reference_example_production_style_release_automation/data"
ensure_gitkeep "$MODULE/pet-projects/reference_example_production_style_release_automation/docker"
ensure_gitkeep "$MODULE/pet-projects/reference_example_production_style_release_automation/src"
ensure_gitkeep "$MODULE/pet-projects/reference_example_production_style_release_automation/tests"

log "04-github-actions structure initialized."