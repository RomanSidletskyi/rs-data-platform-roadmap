#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"

SCRIPT_NAME="real-projects-init"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
SECTION_ROOT="$REPO_ROOT/real-projects"

PROJECTS=(
	01_python_sql_etl
	02_python_docker_github_actions
	03_python_kafka
	04_python_kafka_databricks
	05_python_spark_delta
	06_databricks_adls_powerbi
	07_kafka_databricks_powerbi
	08_end_to_end_data_platform
)

log "Creating real-projects structure..."

ensure_dir "$SECTION_ROOT"

for project in "${PROJECTS[@]}"; do
	ensure_dir "$SECTION_ROOT/$project"
done

log "Real-projects structure initialized."
