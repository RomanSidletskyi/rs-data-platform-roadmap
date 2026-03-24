#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="09-azure-data-lake-storage-init"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "09-azure-data-lake-storage")"

log "Creating 09-azure-data-lake-storage structure..."

ensure_dir "$MODULE"

ensure_dir "$MODULE/learning-materials/01_adls_foundations"
ensure_dir "$MODULE/learning-materials/02_namespace_layout_and_storage_modeling"
ensure_dir "$MODULE/learning-materials/03_security_identity_and_governance"
ensure_dir "$MODULE/learning-materials/04_ingestion_access_and_operating_patterns"
ensure_dir "$MODULE/learning-materials/05_cost_performance_and_reliability"
ensure_dir "$MODULE/learning-materials/06_adls_in_data_platform_architecture"
ensure_dir "$MODULE/learning-materials/07_adls_cookbook"

ensure_dir "$MODULE/simple-tasks/01_adls_foundations"
ensure_dir "$MODULE/simple-tasks/02_namespace_layout_and_storage_modeling"
ensure_dir "$MODULE/simple-tasks/03_security_identity_and_governance"
ensure_dir "$MODULE/simple-tasks/04_ingestion_access_and_operating_patterns"
ensure_dir "$MODULE/simple-tasks/05_cost_performance_and_reliability"
ensure_dir "$MODULE/simple-tasks/06_adls_in_data_platform_architecture"
ensure_dir "$MODULE/simple-tasks/07_adls_cookbook"

ensure_dir "$MODULE/pet-projects/01_adls_namespace_and_landing_zone_lab/artifacts"
ensure_dir "$MODULE/pet-projects/01_adls_namespace_and_landing_zone_lab/config"
ensure_dir "$MODULE/pet-projects/01_adls_namespace_and_landing_zone_lab/data"
ensure_dir "$MODULE/pet-projects/01_adls_namespace_and_landing_zone_lab/src"
ensure_dir "$MODULE/pet-projects/01_adls_namespace_and_landing_zone_lab/tests"

ensure_dir "$MODULE/pet-projects/02_adls_identity_acl_and_publish_boundary_lab/artifacts"
ensure_dir "$MODULE/pet-projects/02_adls_identity_acl_and_publish_boundary_lab/config"
ensure_dir "$MODULE/pet-projects/02_adls_identity_acl_and_publish_boundary_lab/data"
ensure_dir "$MODULE/pet-projects/02_adls_identity_acl_and_publish_boundary_lab/src"
ensure_dir "$MODULE/pet-projects/02_adls_identity_acl_and_publish_boundary_lab/tests"

ensure_dir "$MODULE/pet-projects/03_adls_replay_lifecycle_and_cleanup_lab/artifacts"
ensure_dir "$MODULE/pet-projects/03_adls_replay_lifecycle_and_cleanup_lab/config"
ensure_dir "$MODULE/pet-projects/03_adls_replay_lifecycle_and_cleanup_lab/data"
ensure_dir "$MODULE/pet-projects/03_adls_replay_lifecycle_and_cleanup_lab/src"
ensure_dir "$MODULE/pet-projects/03_adls_replay_lifecycle_and_cleanup_lab/tests"

ensure_dir "$MODULE/pet-projects/04_adls_multi_engine_contracts_and_consumption_lab/artifacts"
ensure_dir "$MODULE/pet-projects/04_adls_multi_engine_contracts_and_consumption_lab/config"
ensure_dir "$MODULE/pet-projects/04_adls_multi_engine_contracts_and_consumption_lab/data"
ensure_dir "$MODULE/pet-projects/04_adls_multi_engine_contracts_and_consumption_lab/src"
ensure_dir "$MODULE/pet-projects/04_adls_multi_engine_contracts_and_consumption_lab/tests"

ensure_dir "$MODULE/pet-projects/reference_example_adls_namespace_and_landing_zone_lab"
ensure_dir "$MODULE/pet-projects/reference_example_adls_multi_engine_contracts_and_consumption_lab"

ensure_gitkeep "$MODULE/learning-materials"
ensure_gitkeep "$MODULE/simple-tasks/01_adls_foundations"
ensure_gitkeep "$MODULE/simple-tasks/02_namespace_layout_and_storage_modeling"
ensure_gitkeep "$MODULE/simple-tasks/03_security_identity_and_governance"
ensure_gitkeep "$MODULE/simple-tasks/04_ingestion_access_and_operating_patterns"
ensure_gitkeep "$MODULE/simple-tasks/05_cost_performance_and_reliability"
ensure_gitkeep "$MODULE/simple-tasks/06_adls_in_data_platform_architecture"
ensure_gitkeep "$MODULE/simple-tasks/07_adls_cookbook"

log "09-azure-data-lake-storage structure initialized."
