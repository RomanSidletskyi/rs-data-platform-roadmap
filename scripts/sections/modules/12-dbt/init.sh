#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="12-dbt-init"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "12-dbt")"

log "Creating 12-dbt structure..."

ensure_dir "$MODULE"

ensure_dir "$MODULE/learning-materials"

ensure_dir "$MODULE/simple-tasks"
ensure_dir "$MODULE/simple-tasks/01_dbt_basics_and_project_structure"
ensure_dir "$MODULE/simple-tasks/02_sources_yaml_and_staging"
ensure_dir "$MODULE/simple-tasks/03_materializations_and_models"
ensure_dir "$MODULE/simple-tasks/04_jinja_macros_and_generate_schema"
ensure_dir "$MODULE/simple-tasks/05_incremental_models_and_cdc_patterns"
ensure_dir "$MODULE/simple-tasks/06_tests_tags_selectors_and_dag"
ensure_dir "$MODULE/simple-tasks/07_snowflake_envs_warehouses_and_configs"
ensure_dir "$MODULE/simple-tasks/08_ci_cd_github_actions_airflow_databricks"



ensure_dir "$MODULE/pet-projects"
ensure_dir "$MODULE/pet-projects/01_snowflake_dbt_warehouse_foundation"
ensure_dir "$MODULE/pet-projects/01_snowflake_dbt_warehouse_foundation/config"
ensure_dir "$MODULE/pet-projects/01_snowflake_dbt_warehouse_foundation/src"
ensure_dir "$MODULE/pet-projects/01_snowflake_dbt_warehouse_foundation/tests"
ensure_dir "$MODULE/pet-projects/01_snowflake_dbt_warehouse_foundation/docker"
ensure_dir "$MODULE/pet-projects/01_snowflake_dbt_warehouse_foundation/data"
ensure_dir "$MODULE/pet-projects/02_kafka_snowflake_dbt_incremental_platform"
ensure_dir "$MODULE/pet-projects/02_kafka_snowflake_dbt_incremental_platform/config"
ensure_dir "$MODULE/pet-projects/02_kafka_snowflake_dbt_incremental_platform/src"
ensure_dir "$MODULE/pet-projects/02_kafka_snowflake_dbt_incremental_platform/tests"
ensure_dir "$MODULE/pet-projects/02_kafka_snowflake_dbt_incremental_platform/docker"
ensure_dir "$MODULE/pet-projects/02_kafka_snowflake_dbt_incremental_platform/data"
ensure_dir "$MODULE/pet-projects/03_dbt_ci_cd_multi_env_platform"
ensure_dir "$MODULE/pet-projects/03_dbt_ci_cd_multi_env_platform/config"
ensure_dir "$MODULE/pet-projects/03_dbt_ci_cd_multi_env_platform/src"
ensure_dir "$MODULE/pet-projects/03_dbt_ci_cd_multi_env_platform/tests"
ensure_dir "$MODULE/pet-projects/03_dbt_ci_cd_multi_env_platform/docker"
ensure_dir "$MODULE/pet-projects/03_dbt_ci_cd_multi_env_platform/data"



log "12-dbt structure initialized."