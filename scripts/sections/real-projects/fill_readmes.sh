#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"

SCRIPT_NAME="real-projects-fill-readmes"
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

log "Creating real-projects starter documentation..."

write_file_safe "$SECTION_ROOT/README.md" <<'EOF'
# Real Projects

This directory is the cross-technology portfolio layer of the repository.

Each project should start as a scoped learning implementation, not as a fully prebuilt solution.

Current project path:

1. `01_python_sql_etl`
2. `02_python_docker_github_actions`
3. `03_python_kafka`
4. `04_python_kafka_databricks`
5. `05_python_spark_delta`
6. `06_databricks_adls_powerbi`
7. `07_kafka_databricks_powerbi`
8. `08_end_to_end_data_platform`
EOF

for project in "${PROJECTS[@]}"; do
	write_file_safe "$SECTION_ROOT/$project/README.md" <<EOF
# $project

Starter real-project slot.

Use this directory to add your own implementation during the learning process.
EOF

	write_file_safe "$SECTION_ROOT/$project/architecture-notes.md" <<'EOF'
# Architecture Notes

- problem statement
- system shape
- key trade-offs
- open questions
EOF

	write_file_safe "$SECTION_ROOT/$project/adr.md" <<'EOF'
# ADR

- decision
- context
- consequences
EOF

	write_file_safe "$SECTION_ROOT/$project/implementation-plan.md" <<'EOF'
# Implementation Plan

1. define scope
2. add starter assets
3. build first runnable slice
4. validate and document trade-offs
EOF
done

log "Real-projects starter documentation prepared."
