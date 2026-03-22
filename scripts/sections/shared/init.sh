#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"
source "$SCRIPT_DIR/../../lib/section.sh"

SCRIPT_NAME="shared-init"
REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
SECTION_ROOT="$REPO_ROOT/shared"

log "Creating shared structure..."

ensure_dir "$SECTION_ROOT"

ensure_dir "$SECTION_ROOT/datasets/raw/csv"
ensure_dir "$SECTION_ROOT/datasets/raw/json"
ensure_dir "$SECTION_ROOT/datasets/raw/parquet"

ensure_dir "$SECTION_ROOT/datasets/sample/csv"
ensure_dir "$SECTION_ROOT/datasets/sample/json"
ensure_dir "$SECTION_ROOT/datasets/sample/parquet"

ensure_dir "$SECTION_ROOT/datasets/processed/parquet"
ensure_dir "$SECTION_ROOT/datasets/generated/parquet"

ensure_dir "$SECTION_ROOT/schemas/sql"
ensure_dir "$SECTION_ROOT/schemas/json"
ensure_dir "$SECTION_ROOT/schemas/avro"
ensure_dir "$SECTION_ROOT/schemas/protobuf"

ensure_dir "$SECTION_ROOT/databases/mysql/docker"
ensure_dir "$SECTION_ROOT/databases/mysql/init"
ensure_dir "$SECTION_ROOT/databases/mysql/schema"
ensure_dir "$SECTION_ROOT/databases/mysql/seed"
ensure_dir "$SECTION_ROOT/databases/mysql/dumps"

ensure_dir "$SECTION_ROOT/databases/mongodb/docker"
ensure_dir "$SECTION_ROOT/databases/mongodb/init"
ensure_dir "$SECTION_ROOT/databases/mongodb/collections"
ensure_dir "$SECTION_ROOT/databases/mongodb/seed"
ensure_dir "$SECTION_ROOT/databases/mongodb/dumps"

ensure_dir "$SECTION_ROOT/docker/compose"
ensure_dir "$SECTION_ROOT/docker/local-stacks"

ensure_dir "$SECTION_ROOT/environments/python"
ensure_dir "$SECTION_ROOT/environments/spark"
ensure_dir "$SECTION_ROOT/environments/dbt"
ensure_dir "$SECTION_ROOT/environments/airflow"

ensure_dir "$SECTION_ROOT/configs/local"
ensure_dir "$SECTION_ROOT/configs/dev"
ensure_dir "$SECTION_ROOT/configs/templates"

ensure_dir "$SECTION_ROOT/scripts/setup"
ensure_dir "$SECTION_ROOT/scripts/data-generation"
ensure_dir "$SECTION_ROOT/scripts/validation"
ensure_dir "$SECTION_ROOT/scripts/helpers"

ensure_dir "$SECTION_ROOT/notebooks/exploratory"
ensure_dir "$SECTION_ROOT/notebooks/demos"

ensure_dir "$SECTION_ROOT/testing/mock-data"
ensure_dir "$SECTION_ROOT/testing/fixtures"
ensure_dir "$SECTION_ROOT/testing/expected-outputs"

ensure_dir "$SECTION_ROOT/architecture/diagrams"
ensure_dir "$SECTION_ROOT/architecture/patterns"
ensure_dir "$SECTION_ROOT/architecture/reference-flows"

ensure_dir "$SECTION_ROOT/templates/module-template"
ensure_dir "$SECTION_ROOT/templates/project-template"
ensure_dir "$SECTION_ROOT/templates/README-template"

ensure_gitkeep "$SECTION_ROOT/datasets/raw/csv"
ensure_gitkeep "$SECTION_ROOT/datasets/raw/json"
ensure_gitkeep "$SECTION_ROOT/datasets/raw/parquet"
ensure_gitkeep "$SECTION_ROOT/datasets/sample/csv"
ensure_gitkeep "$SECTION_ROOT/datasets/sample/json"
ensure_gitkeep "$SECTION_ROOT/datasets/sample/parquet"
ensure_gitkeep "$SECTION_ROOT/datasets/processed/parquet"
ensure_gitkeep "$SECTION_ROOT/datasets/generated/parquet"

ensure_gitkeep "$SECTION_ROOT/schemas/sql"
ensure_gitkeep "$SECTION_ROOT/schemas/json"
ensure_gitkeep "$SECTION_ROOT/schemas/avro"
ensure_gitkeep "$SECTION_ROOT/schemas/protobuf"

ensure_gitkeep "$SECTION_ROOT/databases/mysql/docker"
ensure_gitkeep "$SECTION_ROOT/databases/mysql/init"
ensure_gitkeep "$SECTION_ROOT/databases/mysql/schema"
ensure_gitkeep "$SECTION_ROOT/databases/mysql/seed"
ensure_gitkeep "$SECTION_ROOT/databases/mysql/dumps"

ensure_gitkeep "$SECTION_ROOT/databases/mongodb/docker"
ensure_gitkeep "$SECTION_ROOT/databases/mongodb/init"
ensure_gitkeep "$SECTION_ROOT/databases/mongodb/collections"
ensure_gitkeep "$SECTION_ROOT/databases/mongodb/seed"
ensure_gitkeep "$SECTION_ROOT/databases/mongodb/dumps"

ensure_gitkeep "$SECTION_ROOT/docker/compose"
ensure_gitkeep "$SECTION_ROOT/docker/local-stacks"

ensure_gitkeep "$SECTION_ROOT/environments/python"
ensure_gitkeep "$SECTION_ROOT/environments/spark"
ensure_gitkeep "$SECTION_ROOT/environments/dbt"
ensure_gitkeep "$SECTION_ROOT/environments/airflow"

ensure_gitkeep "$SECTION_ROOT/configs/local"
ensure_gitkeep "$SECTION_ROOT/configs/dev"
ensure_gitkeep "$SECTION_ROOT/configs/templates"

ensure_gitkeep "$SECTION_ROOT/scripts/setup"
ensure_gitkeep "$SECTION_ROOT/scripts/data-generation"
ensure_gitkeep "$SECTION_ROOT/scripts/validation"
ensure_gitkeep "$SECTION_ROOT/scripts/helpers"

ensure_gitkeep "$SECTION_ROOT/notebooks/exploratory"
ensure_gitkeep "$SECTION_ROOT/notebooks/demos"

ensure_gitkeep "$SECTION_ROOT/testing/mock-data"
ensure_gitkeep "$SECTION_ROOT/testing/fixtures"
ensure_gitkeep "$SECTION_ROOT/testing/expected-outputs"

ensure_gitkeep "$SECTION_ROOT/architecture/diagrams"
ensure_gitkeep "$SECTION_ROOT/architecture/patterns"
ensure_gitkeep "$SECTION_ROOT/architecture/reference-flows"

ensure_gitkeep "$SECTION_ROOT/templates/module-template"
ensure_gitkeep "$SECTION_ROOT/templates/project-template"
ensure_gitkeep "$SECTION_ROOT/templates/README-template"

log "Shared structure initialized."