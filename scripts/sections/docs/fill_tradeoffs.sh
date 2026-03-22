#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"
source "$SCRIPT_DIR/../../lib/section.sh"

SCRIPT_NAME="docs-fill-trade-offs"
REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
SECTION_ROOT="$REPO_ROOT/docs/trade-offs"


log "Creating nested files for trade-offs subdirectories..."


########################################
# docs/trade-offs
########################################

cat << 'EOF' > "$SECTION_ROOT/README.md"
# Trade-Offs

This section is dedicated to one of the most important architecture skills:

understanding trade-offs.

Architecture is not choosing the best tool in general.
Architecture is choosing the best fit for a specific situation.

## Suggested Trade-Off Notes

- Kafka vs batch ingestion
- Spark vs pandas
- Delta vs Iceberg
- dbt vs SQL scripts
- Airflow vs cron
- Flink vs Spark Structured Streaming
EOF

cat << 'EOF' > "$SECTION_ROOT/trade-off-template.md"
# Trade-Off Title

## Decision

Describe the decision being evaluated.

## Context

Explain the use case and constraints.

## Option A

### Benefits

- item 1
- item 2

### Drawbacks

- item 1
- item 2

## Option B

### Benefits

- item 1
- item 2

### Drawbacks

- item 1
- item 2

## Recommendation

Explain which option is better in this context.
EOF

log "Docs trade-offs created successfully."