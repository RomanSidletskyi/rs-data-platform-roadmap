#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"
source "$SCRIPT_DIR/../../lib/section.sh"

SCRIPT_NAME="docs-fill-system-design"
REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
SECTION_ROOT="$REPO_ROOT/docs/system-design"


log "Creating nested system design files for system design subdirectories..."


########################################
# docs/system-design
########################################

cat <<'EOF' > "$SECTION_ROOT/README.md"
# System Design

This section contains system design notes for common data engineering scenarios.

The goal is to practice thinking in systems, not only in scripts or tools.

## Suggested System Design Topics

- batch ETL pipeline
- Kafka ingestion platform
- lakehouse + BI architecture
- streaming analytics platform
- hybrid batch + streaming platform
EOF

cat << 'EOF' > "$SECTION_ROOT/batch-etl-template.md"
# Batch ETL Design Template

## Problem Statement

Describe a batch data pipeline use case.

## Architecture

Source -> ingestion -> raw storage -> transformation -> curated data -> BI

## Interview Questions

- Why choose batch over streaming?
- What is the role of raw storage?
- How would you rerun the job safely?
EOF

cat << 'EOF' > "$SECTION_ROOT/streaming-template.md"
# Streaming Design Template

## Problem Statement

Describe a real-time or near real-time data use case.

## Architecture

Producers -> Kafka -> stream processing -> serving/storage

## Interview Questions

- When is streaming worth the complexity?
- What is replay?
- How do you handle duplicates?
EOF

cat << 'EOF' > "$SECTION_ROOT/batch-etl.md"
# Batch ETL System Design

## Problem Statement

Design a batch pipeline that ingests data from source systems, stores raw input, transforms it, and prepares curated outputs for reporting.

## Typical Architecture

    Source -> Ingestion -> Raw -> Transform -> Curated -> BI

## Interview Questions

- Why choose batch over streaming?
- What is the role of raw storage?
- How do you rerun a failed job safely?
EOF

cat << 'EOF' > "$SECTION_ROOT/kafka-ingestion.md"
# Kafka Ingestion System Design

## Problem Statement

Design a near real-time ingestion system that receives events from producers, transports them through Kafka, and processes them downstream.

## Typical Architecture

    Producers -> Kafka Topics -> Consumers -> Storage / Serving

## Interview Questions

- Why use Kafka instead of polling?
- What is a consumer group?
- Why do partitions matter?
EOF

cat << 'EOF' > "$SECTION_ROOT/lakehouse-bi.md"
# Lakehouse to BI System Design

## Problem Statement

Design a data platform that ingests raw data into a lakehouse and serves business-ready data to a BI tool.

## Typical Architecture

    Sources -> Bronze -> Silver -> Gold -> Semantic Layer -> Dashboards

## Interview Questions

- Why not connect BI directly to raw files?
- What is the purpose of bronze, silver, and gold?
- Why use a semantic layer?
EOF

cat << 'EOF' > "$SECTION_ROOT/streaming-analytics.md"
# Streaming Analytics System Design

## Problem Statement

Design a system that receives events continuously, processes them in near real time, and exposes analytics outputs.

## Typical Architecture

    Producers -> Kafka -> Stream Processing -> Analytical Storage -> Dashboard / Alerts

## Interview Questions

- Why is checkpointing important?
- How do you handle late or duplicate events?
- When is near real-time worth the complexity?
EOF

log "System design docs created successfully."