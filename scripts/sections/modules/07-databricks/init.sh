#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="07-databricks-init"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "07-databricks")"

log "Creating 07-databricks structure..."

ensure_dir "$MODULE"

ensure_dir "$MODULE/learning-materials/01_databricks_foundations"
ensure_dir "$MODULE/learning-materials/02_workspace_compute_and_runtime"
ensure_dir "$MODULE/learning-materials/03_data_engineering_patterns"
ensure_dir "$MODULE/learning-materials/04_unity_catalog_governance_and_security"
ensure_dir "$MODULE/learning-materials/05_databricks_sql_and_analytics_serving"
ensure_dir "$MODULE/learning-materials/06_operating_databricks_platforms"
ensure_dir "$MODULE/learning-materials/07_databricks_cookbook"

ensure_dir "$MODULE/simple-tasks/01_databricks_foundations"
ensure_dir "$MODULE/simple-tasks/02_workspace_compute_and_runtime"
ensure_dir "$MODULE/simple-tasks/03_data_engineering_patterns"
ensure_dir "$MODULE/simple-tasks/04_unity_catalog_governance_and_security"
ensure_dir "$MODULE/simple-tasks/05_databricks_sql_and_analytics_serving"
ensure_dir "$MODULE/simple-tasks/06_operating_databricks_platforms"
ensure_dir "$MODULE/simple-tasks/07_databricks_cookbook"

ensure_dir "$MODULE/pet-projects/01_medallion_batch_pipeline_workspace_lab/config"
ensure_dir "$MODULE/pet-projects/01_medallion_batch_pipeline_workspace_lab/data"
ensure_dir "$MODULE/pet-projects/01_medallion_batch_pipeline_workspace_lab/docker"
ensure_dir "$MODULE/pet-projects/01_medallion_batch_pipeline_workspace_lab/src"
ensure_dir "$MODULE/pet-projects/01_medallion_batch_pipeline_workspace_lab/tests"

ensure_dir "$MODULE/pet-projects/02_unity_catalog_governed_gold_layer_lab/config"
ensure_dir "$MODULE/pet-projects/02_unity_catalog_governed_gold_layer_lab/data"
ensure_dir "$MODULE/pet-projects/02_unity_catalog_governed_gold_layer_lab/docker"
ensure_dir "$MODULE/pet-projects/02_unity_catalog_governed_gold_layer_lab/src"
ensure_dir "$MODULE/pet-projects/02_unity_catalog_governed_gold_layer_lab/tests"

ensure_dir "$MODULE/pet-projects/03_jobs_and_asset_bundle_release_lab/config"
ensure_dir "$MODULE/pet-projects/03_jobs_and_asset_bundle_release_lab/data"
ensure_dir "$MODULE/pet-projects/03_jobs_and_asset_bundle_release_lab/docker"
ensure_dir "$MODULE/pet-projects/03_jobs_and_asset_bundle_release_lab/src"
ensure_dir "$MODULE/pet-projects/03_jobs_and_asset_bundle_release_lab/tests"

ensure_dir "$MODULE/pet-projects/04_kafka_to_databricks_serving_pipeline_lab/config"
ensure_dir "$MODULE/pet-projects/04_kafka_to_databricks_serving_pipeline_lab/data"
ensure_dir "$MODULE/pet-projects/04_kafka_to_databricks_serving_pipeline_lab/docker"
ensure_dir "$MODULE/pet-projects/04_kafka_to_databricks_serving_pipeline_lab/src"
ensure_dir "$MODULE/pet-projects/04_kafka_to_databricks_serving_pipeline_lab/tests"

ensure_dir "$MODULE/pet-projects/reference_example_medallion_batch_pipeline_workspace_lab/config"
ensure_dir "$MODULE/pet-projects/reference_example_medallion_batch_pipeline_workspace_lab/data"
ensure_dir "$MODULE/pet-projects/reference_example_medallion_batch_pipeline_workspace_lab/src"
ensure_dir "$MODULE/pet-projects/reference_example_medallion_batch_pipeline_workspace_lab/tests"

ensure_dir "$MODULE/pet-projects/reference_example_kafka_to_databricks_serving_pipeline_lab/config"
ensure_dir "$MODULE/pet-projects/reference_example_kafka_to_databricks_serving_pipeline_lab/data"
ensure_dir "$MODULE/pet-projects/reference_example_kafka_to_databricks_serving_pipeline_lab/src"
ensure_dir "$MODULE/pet-projects/reference_example_kafka_to_databricks_serving_pipeline_lab/tests"

ensure_gitkeep "$MODULE/learning-materials"
ensure_gitkeep "$MODULE/simple-tasks/01_databricks_foundations"
ensure_gitkeep "$MODULE/simple-tasks/02_workspace_compute_and_runtime"
ensure_gitkeep "$MODULE/simple-tasks/03_data_engineering_patterns"
ensure_gitkeep "$MODULE/simple-tasks/04_unity_catalog_governance_and_security"
ensure_gitkeep "$MODULE/simple-tasks/05_databricks_sql_and_analytics_serving"
ensure_gitkeep "$MODULE/simple-tasks/06_operating_databricks_platforms"
ensure_gitkeep "$MODULE/simple-tasks/07_databricks_cookbook"

log "07-databricks structure initialized."