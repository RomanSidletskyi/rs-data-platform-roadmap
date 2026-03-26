#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="01-python-init"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "01-python")"

log "Creating 01-python structure..."

ensure_dir "$MODULE"

ensure_dir "$MODULE/learning-materials"
ensure_dir "$MODULE/learning-materials/api-work"
ensure_dir "$MODULE/learning-materials/data-engineering-focus"
ensure_dir "$MODULE/learning-materials/files-and-json"
ensure_dir "$MODULE/learning-materials/fundamentals"
ensure_dir "$MODULE/learning-materials/packaging-and-env"
ensure_dir "$MODULE/learning-materials/python-cookbook"
ensure_dir "$MODULE/learning-materials/testing-and-logging"

ensure_dir "$MODULE/simple-tasks"
ensure_dir "$MODULE/simple-tasks/01_variables_conditions_loops"
ensure_dir "$MODULE/simple-tasks/02_functions_modules"
ensure_dir "$MODULE/simple-tasks/03_work_with_files_csv_json"
ensure_dir "$MODULE/simple-tasks/04_requests_and_api"
ensure_dir "$MODULE/simple-tasks/05_error_handling_logging"
ensure_dir "$MODULE/simple-tasks/06_virtualenv_and_project_setup"
ensure_dir "$MODULE/simple-tasks/07_pandas_basics"
ensure_dir "$MODULE/simple-tasks/08_data_engineering_python_tasks"

ensure_dir "$MODULE/pet-projects"
ensure_dir "$MODULE/pet-projects/01_api_to_csv_pipeline"
ensure_dir "$MODULE/pet-projects/01_api_to_csv_pipeline/config"
ensure_dir "$MODULE/pet-projects/01_api_to_csv_pipeline/data"
ensure_dir "$MODULE/pet-projects/01_api_to_csv_pipeline/data/processed"
ensure_dir "$MODULE/pet-projects/01_api_to_csv_pipeline/data/raw"
ensure_dir "$MODULE/pet-projects/01_api_to_csv_pipeline/docker"
ensure_dir "$MODULE/pet-projects/01_api_to_csv_pipeline/logs"
ensure_dir "$MODULE/pet-projects/01_api_to_csv_pipeline/src"
ensure_dir "$MODULE/pet-projects/01_api_to_csv_pipeline/tests"

ensure_dir "$MODULE/pet-projects/02_json_normalizer"
ensure_dir "$MODULE/pet-projects/03_log_parser_pipeline"
ensure_dir "$MODULE/pet-projects/04_data_quality_checker"
ensure_dir "$MODULE/pet-projects/05_incremental_ingestion_simulator"
ensure_dir "$MODULE/pet-projects/reference_example_api_to_csv_pipeline"

log "Adding .gitkeep files where useful..."

ensure_gitkeep "$MODULE/learning-materials/api-work"
ensure_gitkeep "$MODULE/learning-materials/data-engineering-focus"
ensure_gitkeep "$MODULE/learning-materials/files-and-json"
ensure_gitkeep "$MODULE/learning-materials/fundamentals"
ensure_gitkeep "$MODULE/learning-materials/packaging-and-env"
ensure_gitkeep "$MODULE/learning-materials/python-cookbook"
ensure_gitkeep "$MODULE/learning-materials/testing-and-logging"

ensure_gitkeep "$MODULE/simple-tasks/01_variables_conditions_loops"
ensure_gitkeep "$MODULE/simple-tasks/02_functions_modules"
ensure_gitkeep "$MODULE/simple-tasks/03_work_with_files_csv_json"
ensure_gitkeep "$MODULE/simple-tasks/04_requests_and_api"
ensure_gitkeep "$MODULE/simple-tasks/05_error_handling_logging"
ensure_gitkeep "$MODULE/simple-tasks/06_virtualenv_and_project_setup"
ensure_gitkeep "$MODULE/simple-tasks/07_pandas_basics"
ensure_gitkeep "$MODULE/simple-tasks/08_data_engineering_python_tasks"

ensure_gitkeep "$MODULE/pet-projects/01_api_to_csv_pipeline/config"
ensure_gitkeep "$MODULE/pet-projects/01_api_to_csv_pipeline/data/processed"
ensure_gitkeep "$MODULE/pet-projects/01_api_to_csv_pipeline/data/raw"
ensure_gitkeep "$MODULE/pet-projects/01_api_to_csv_pipeline/docker"
ensure_gitkeep "$MODULE/pet-projects/01_api_to_csv_pipeline/logs"
ensure_gitkeep "$MODULE/pet-projects/01_api_to_csv_pipeline/src"
ensure_gitkeep "$MODULE/pet-projects/01_api_to_csv_pipeline/tests"

ensure_gitkeep "$MODULE/pet-projects/02_json_normalizer"
ensure_gitkeep "$MODULE/pet-projects/03_log_parser_pipeline"
ensure_gitkeep "$MODULE/pet-projects/04_data_quality_checker"
ensure_gitkeep "$MODULE/pet-projects/05_incremental_ingestion_simulator"
ensure_gitkeep "$MODULE/pet-projects/reference_example_api_to_csv_pipeline"

log "01-python structure initialized."