#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="08-delta-lake-init"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "08-delta-lake")"

log "Creating 08-delta-lake structure..."

ensure_dir "$MODULE"

ensure_dir "$MODULE/learning-materials/01_delta_lake_foundations"
ensure_dir "$MODULE/learning-materials/02_table_operations_and_change_patterns"
ensure_dir "$MODULE/learning-materials/03_reliability_quality_and_recovery"
ensure_dir "$MODULE/learning-materials/04_delta_in_lakehouse_architecture"
ensure_dir "$MODULE/learning-materials/05_serving_governance_and_interoperability"
ensure_dir "$MODULE/learning-materials/06_operating_delta_lake_tables"
ensure_dir "$MODULE/learning-materials/07_delta_lake_cookbook"

ensure_dir "$MODULE/simple-tasks/01_delta_lake_foundations"
ensure_dir "$MODULE/simple-tasks/02_table_operations_and_change_patterns"
ensure_dir "$MODULE/simple-tasks/03_reliability_quality_and_recovery"
ensure_dir "$MODULE/simple-tasks/04_delta_in_lakehouse_architecture"
ensure_dir "$MODULE/simple-tasks/05_serving_governance_and_interoperability"
ensure_dir "$MODULE/simple-tasks/06_operating_delta_lake_tables"
ensure_dir "$MODULE/simple-tasks/07_delta_lake_cookbook"

ensure_dir "$MODULE/pet-projects/01_delta_batch_repairable_orders_lab/artifacts"
ensure_dir "$MODULE/pet-projects/01_delta_batch_repairable_orders_lab/config"
ensure_dir "$MODULE/pet-projects/01_delta_batch_repairable_orders_lab/data"
ensure_dir "$MODULE/pet-projects/01_delta_batch_repairable_orders_lab/src"
ensure_dir "$MODULE/pet-projects/01_delta_batch_repairable_orders_lab/tests"

ensure_dir "$MODULE/pet-projects/02_delta_cdc_customer_state_lab/artifacts"
ensure_dir "$MODULE/pet-projects/02_delta_cdc_customer_state_lab/config"
ensure_dir "$MODULE/pet-projects/02_delta_cdc_customer_state_lab/data"
ensure_dir "$MODULE/pet-projects/02_delta_cdc_customer_state_lab/src"
ensure_dir "$MODULE/pet-projects/02_delta_cdc_customer_state_lab/tests"

ensure_dir "$MODULE/pet-projects/03_delta_quality_recovery_and_retention_lab/artifacts"
ensure_dir "$MODULE/pet-projects/03_delta_quality_recovery_and_retention_lab/config"
ensure_dir "$MODULE/pet-projects/03_delta_quality_recovery_and_retention_lab/data"
ensure_dir "$MODULE/pet-projects/03_delta_quality_recovery_and_retention_lab/src"
ensure_dir "$MODULE/pet-projects/03_delta_quality_recovery_and_retention_lab/tests"

ensure_dir "$MODULE/pet-projects/04_delta_serving_contracts_and_schema_change_lab/artifacts"
ensure_dir "$MODULE/pet-projects/04_delta_serving_contracts_and_schema_change_lab/config"
ensure_dir "$MODULE/pet-projects/04_delta_serving_contracts_and_schema_change_lab/data"
ensure_dir "$MODULE/pet-projects/04_delta_serving_contracts_and_schema_change_lab/src"
ensure_dir "$MODULE/pet-projects/04_delta_serving_contracts_and_schema_change_lab/tests"

ensure_dir "$MODULE/pet-projects/reference_example_delta_batch_repairable_orders_lab"
ensure_dir "$MODULE/pet-projects/reference_example_delta_serving_contracts_and_schema_change_lab"

ensure_gitkeep "$MODULE/learning-materials"
ensure_gitkeep "$MODULE/simple-tasks/01_delta_lake_foundations"
ensure_gitkeep "$MODULE/simple-tasks/02_table_operations_and_change_patterns"
ensure_gitkeep "$MODULE/simple-tasks/03_reliability_quality_and_recovery"
ensure_gitkeep "$MODULE/simple-tasks/04_delta_in_lakehouse_architecture"
ensure_gitkeep "$MODULE/simple-tasks/05_serving_governance_and_interoperability"
ensure_gitkeep "$MODULE/simple-tasks/06_operating_delta_lake_tables"
ensure_gitkeep "$MODULE/simple-tasks/07_delta_lake_cookbook"

log "08-delta-lake structure initialized."
