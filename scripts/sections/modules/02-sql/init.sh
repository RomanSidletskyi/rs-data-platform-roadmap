#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="02-sql-init"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "02-sql")"

log "Creating 02-sql structure..."

ensure_dir "$MODULE"

ensure_dir "$MODULE/learning-materials"
ensure_dir "$MODULE/learning-materials/01_sql_analytics_patterns"
ensure_dir "$MODULE/learning-materials/02_sql_for_lakehouse"
ensure_dir "$MODULE/learning-materials/03_sql_vs_nosql_architecture"
ensure_dir "$MODULE/learning-materials/04_document_database_modeling"
ensure_dir "$MODULE/learning-materials/05_mongodb"
ensure_dir "$MODULE/learning-materials/06_dynamodb"
ensure_dir "$MODULE/learning-materials/07_azure_databases_for_databricks"
ensure_dir "$MODULE/learning-materials/08_snowflake"

ensure_dir "$MODULE/simple-tasks"
ensure_dir "$MODULE/simple-tasks/01_analytics_queries"
ensure_dir "$MODULE/simple-tasks/02_window_queries"
ensure_dir "$MODULE/simple-tasks/03_document_queries"
ensure_dir "$MODULE/simple-tasks/04_nosql_modeling"

ensure_dir "$MODULE/pet-projects"
ensure_dir "$MODULE/pet-projects/01_sql_analytics_engine"
ensure_dir "$MODULE/pet-projects/02_mongodb_event_store"
ensure_dir "$MODULE/pet-projects/03_relational_to_document_migration"
ensure_dir "$MODULE/pet-projects/reference_example_sql_analytics_engine"
ensure_dir "$MODULE/pet-projects/reference_example_relational_to_document_migration"

log "Adding .gitkeep files where useful..."

ensure_gitkeep "$MODULE/learning-materials/01_sql_analytics_patterns"
ensure_gitkeep "$MODULE/learning-materials/02_sql_for_lakehouse"
ensure_gitkeep "$MODULE/learning-materials/03_sql_vs_nosql_architecture"
ensure_gitkeep "$MODULE/learning-materials/04_document_database_modeling"
ensure_gitkeep "$MODULE/learning-materials/05_mongodb"
ensure_gitkeep "$MODULE/learning-materials/06_dynamodb"
ensure_gitkeep "$MODULE/learning-materials/07_azure_databases_for_databricks"
ensure_gitkeep "$MODULE/learning-materials/08_snowflake"

ensure_gitkeep "$MODULE/simple-tasks/01_analytics_queries"
ensure_gitkeep "$MODULE/simple-tasks/02_window_queries"
ensure_gitkeep "$MODULE/simple-tasks/03_document_queries"
ensure_gitkeep "$MODULE/simple-tasks/04_nosql_modeling"

ensure_gitkeep "$MODULE/pet-projects/01_sql_analytics_engine"
ensure_gitkeep "$MODULE/pet-projects/02_mongodb_event_store"
ensure_gitkeep "$MODULE/pet-projects/03_relational_to_document_migration"
ensure_gitkeep "$MODULE/pet-projects/reference_example_sql_analytics_engine"
ensure_gitkeep "$MODULE/pet-projects/reference_example_relational_to_document_migration"

log "02-sql structure initialized."