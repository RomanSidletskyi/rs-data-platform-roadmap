#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="14-iceberg-init"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "14-iceberg")"

log "Creating 14-iceberg structure..."

ensure_dir "$MODULE"

ensure_dir "$MODULE/learning-materials"

ensure_dir "$MODULE/simple-tasks"
ensure_dir "$MODULE/simple-tasks/01_iceberg_metadata_and_table_state"
ensure_dir "$MODULE/simple-tasks/02_spark_glue_and_first_writes"
ensure_dir "$MODULE/simple-tasks/03_merge_cdc_and_modeling_patterns"
ensure_dir "$MODULE/simple-tasks/04_schema_partition_and_compatibility"
ensure_dir "$MODULE/simple-tasks/05_branching_retention_and_governance"
ensure_dir "$MODULE/simple-tasks/06_troubleshooting_and_failure_modes"
ensure_dir "$MODULE/simple-tasks/07_maintenance_cost_and_cleanup"

ensure_dir "$MODULE/pet-projects"
ensure_dir "$MODULE/pet-projects/01_spark_glue_orders_lakehouse"
ensure_dir "$MODULE/pet-projects/02_minio_nessie_branching_lab"
ensure_dir "$MODULE/pet-projects/03_cdc_merge_and_history_platform"
ensure_dir "$MODULE/pet-projects/04_multi_engine_open_table_design"
ensure_dir "$MODULE/pet-projects/reference_example_minio_nessie_branching_lab"
ensure_dir "$MODULE/pet-projects/reference_example_spark_glue_orders_lakehouse"

log "Adding .gitkeep files where useful..."

ensure_gitkeep "$MODULE/learning-materials"

ensure_gitkeep "$MODULE/simple-tasks/01_iceberg_metadata_and_table_state"
ensure_gitkeep "$MODULE/simple-tasks/02_spark_glue_and_first_writes"
ensure_gitkeep "$MODULE/simple-tasks/03_merge_cdc_and_modeling_patterns"
ensure_gitkeep "$MODULE/simple-tasks/04_schema_partition_and_compatibility"
ensure_gitkeep "$MODULE/simple-tasks/05_branching_retention_and_governance"
ensure_gitkeep "$MODULE/simple-tasks/06_troubleshooting_and_failure_modes"
ensure_gitkeep "$MODULE/simple-tasks/07_maintenance_cost_and_cleanup"

ensure_gitkeep "$MODULE/pet-projects/01_spark_glue_orders_lakehouse"
ensure_gitkeep "$MODULE/pet-projects/02_minio_nessie_branching_lab"
ensure_gitkeep "$MODULE/pet-projects/03_cdc_merge_and_history_platform"
ensure_gitkeep "$MODULE/pet-projects/04_multi_engine_open_table_design"
ensure_gitkeep "$MODULE/pet-projects/reference_example_minio_nessie_branching_lab"
ensure_gitkeep "$MODULE/pet-projects/reference_example_spark_glue_orders_lakehouse"

log "14-iceberg structure initialized."