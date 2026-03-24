#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../lib/common.sh"
source "$SCRIPT_DIR/../../lib/fs.sh"
source "$SCRIPT_DIR/../../lib/section.sh"

SCRIPT_NAME="docs-fill-core"
REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
SECTION_ROOT="$REPO_ROOT/docs"

log "Creating docs core md..."


cat <<'EOF' > "$SECTION_ROOT/learning-architecture.md"
# Learning Architecture

This repository is designed as a structured system for learning Data Engineering.

The learning model follows three levels of practice:

1. Learning Materials
2. Simple Tasks
3. Pet Projects
4. Real Projects

---

# Learning Materials

Learning materials provide theoretical understanding of each technology.

Each topic includes:

- Why the topic matters
- What concepts must be understood
- Key theory
- Common mistakes
- Recommended resources
- Interview questions
- Completion checklist

Goal:

Build conceptual understanding before implementation.

---

# Simple Tasks

Simple tasks are small focused exercises.

They help practice individual concepts quickly.

Each task includes:

- Goal
- Input
- Requirements
- Expected Output
- Extra Challenge

Goal:

Turn theoretical knowledge into practical intuition.

---

# Pet Projects

Pet projects simulate real data engineering workflows.

They introduce:

- pipeline structure
- logging
- configuration
- validation
- reproducibility

Goal:

Build portfolio-ready projects.

---

# Real Projects

Real projects combine multiple technologies together.

Examples:

Python + Kafka  
Spark + Delta  
Databricks + ADLS + PowerBI  
Kafka + Flink + Iceberg  

Goal:

Simulate production-grade data platforms.

---

# Learning Progression

The roadmap follows this progression:

Programming → Data Processing → Distributed Systems → Data Platform Architecture

Example path:

Python → SQL → Docker → Kafka → Spark → Databricks → Delta Lake → Airflow → dbt

Later planned continuation:

Power BI / Fabric → Flink → Iceberg

---

# Final Objective

After completing the roadmap the learner should be able to:

- design batch data pipelines
- design streaming architectures
- build lakehouse platforms
- understand data platform trade-offs
- design production data workflows

EOF

cat <<'EOF' > "$SECTION_ROOT/data-platform-map.md"
# Data Platform Map

This document explains how all modules in this repository fit into a modern data platform.

The goal is to understand:

- where each technology sits in the architecture
- what problem it solves
- how systems connect together

---

# Logical Architecture

Sources
↓
Ingestion
↓
Processing
↓
Storage / Lakehouse
↓
Transformation
↓
Serving
↓
BI / Analytics

Supporting layers:

- orchestration
- data quality
- observability
- governance
- infrastructure

---

# Repository Modules and Platform Roles

## Ingestion Layer

Modules:

01-python
02-sql
05-confluent-kafka

Purpose:

Move data from source systems into the platform.

Examples:

API -> Python -> Data Lake

Application -> Kafka -> Stream consumers

---

## Processing Layer

Modules:

06-spark-pyspark
07-databricks

Purpose:

Transform large volumes of data.

Responsibilities:

- joins
- aggregations
- transformations
- data enrichment

Example:

Raw -> Spark -> Curated tables

---

## Storage Layer

Modules:

08-delta-lake
09-azure-data-lake-storage

Purpose:

Reliable storage of raw and processed data.

Typical layout:

data-lake/
raw/
bronze/
silver/
gold/

---

## Analytics Layer

Module:

10-powerbi-fabric

Current status:

- planned placeholder module for a later repository pass

Purpose:

Expose business data to analysts.

Example:

Gold tables -> semantic model -> dashboards

---

## Engineering Enablement

Modules:

03-docker
04-github-actions

Purpose:

Reproducible environments and CI/CD pipelines.

---

# Platform Extensions

## Orchestration

Module:

11-airflow

Purpose:

Coordinate pipeline execution and scheduling.

---

## Transformation Layer

Module:

12-dbt

Purpose:

Maintain SQL transformation models.

Features:

- tests
- lineage
- documentation

---

## Streaming Compute

Module:

13-flink

Current status:

- planned placeholder module for a later repository pass

Purpose:

Stateful real-time stream processing.

Example:

Kafka -> Flink -> aggregated metrics

---

## Open Table Formats

Module:

14-iceberg

Current status:

- planned placeholder module for a later repository pass

Purpose:

Engine-independent lakehouse tables.

---

# Production Layers

## Data Quality

Module:

15-data-quality

Purpose:

Validate datasets before consumption.

---

## Observability

Module:

16-observability

Purpose:

Monitor pipelines and infrastructure.

---

## Cloud Architecture

Module:

17-cloud-architecture

Purpose:

Understand cloud-native data platform design.

---

## Infrastructure as Code

Module:

18-terraform

Purpose:

Provision infrastructure reproducibly.

---

# Full Platform Flow

Sources

↓

Ingestion
Python / Kafka

↓

Processing
Spark / Flink

↓

Storage
ADLS / S3

↓

Lakehouse Tables
Delta / Iceberg

↓

Transformation
dbt

↓

Serving
BI tools

Supporting systems:

Airflow -> orchestration
Data Quality -> validation
Observability -> monitoring
Terraform -> infrastructure

---

# Key Architecture Principle

Every tool exists because it solves a specific problem.

Examples:

Kafka -> event transport
Spark -> distributed compute
Flink -> real-time processing
dbt -> SQL transformation layer
Delta / Iceberg -> lakehouse tables
Power BI -> analytics consumption
EOF

########################################
# docs/learning-sequence.md
########################################

cat << 'EOF' > "$SECTION_ROOT/learning-sequence.md"
# Learning Sequence

This roadmap describes the recommended order for learning modules.

Goal:

Move from tool knowledge -> platform engineering -> architecture thinking.

Current note:

10-powerbi-fabric, 13-flink, and 14-iceberg are already present as directories but are intentionally being kept as planned placeholders rather than active generated scope.

---

# Phase 1 — Engineering Basics

Modules:

01-python
02-sql
03-docker
04-github-actions

Focus:

- coding
- automation
- reproducible environments

Example project:

Python ETL pipeline in Docker.

---

# Phase 2 — Data Processing

Modules:

05-confluent-kafka
06-spark-pyspark

Focus:

- event ingestion
- distributed processing

Example project:

Kafka -> Python consumer
Spark ETL pipeline

---

# Phase 3 — Lakehouse

Modules:

07-databricks
08-delta-lake
09-azure-data-lake-storage

Focus:

- scalable data platforms
- medallion architecture

Example project:

API -> Spark -> Delta pipeline

---

# Planned Phase — Analytics

Module:

10-powerbi-fabric

Current status:

- planned placeholder for a later learning pass

Focus:

- business intelligence
- dashboards
- semantic models

Example project:

Gold tables -> Power BI dashboards

---

# Phase 5 — Orchestration

Module:

11-airflow

Focus:

- scheduling pipelines
- DAG design
- dependencies

Example project:

Airflow orchestrated ETL pipeline

---

# Phase 6 — Transformation Modeling

Module:

12-dbt

Focus:

- SQL models
- testing
- documentation

Example project:

dbt transformation layer

---

# Planned Phase — Streaming Systems

Module:

13-flink

Current status:

- planned placeholder for a later learning pass

Focus:

- event time
- streaming windows
- checkpointing

Example project:

Kafka -> Flink -> real-time metrics

---

# Planned Phase — Lakehouse Formats

Module:

14-iceberg

Current status:

- planned placeholder for a later learning pass

Focus:

- open table formats
- schema evolution

Example project:

Spark + Flink reading Iceberg tables

---

# Phase 9 — Reliability

Modules:

15-data-quality
16-observability

Focus:

- validation
- monitoring
- alerting

---

# Phase 10 — Platform Architecture

Modules:

17-cloud-architecture
18-terraform

Focus:

- cloud systems
- infrastructure automation
EOF

########################################
# docs/data-platform-projects-roadmap.md
########################################

cat << 'EOF' > "$SECTION_ROOT/data-platform-projects-roadmap.md"
# Data Platform Projects Roadmap

This document lists recommended end-to-end projects for mastering the full data platform stack.

The projects gradually combine more modules from the roadmap.

Note:

The later portfolio projects may reference planned placeholder modules, especially 10-powerbi-fabric, before those modules are fully activated in the learning path.

---

# Project 1 — Python Batch ETL

Modules used:

- Python
- SQL
- Docker

Architecture:

API -> Python -> CSV / Parquet

Goal:

Learn basic ingestion pipelines.

---

# Project 2 — Event Streaming Pipeline

Modules used:

- Python
- Kafka

Architecture:

Producer -> Kafka -> Consumer -> storage

Goal:

Understand event streaming.

---

# Project 3 — Spark Batch Processing

Modules used:

- Spark
- ADLS

Architecture:

Raw files -> Spark -> processed datasets

Goal:

Process large datasets.

---

# Project 4 — Lakehouse Pipeline

Modules used:

- Databricks
- Delta Lake
- ADLS

Architecture:

Raw -> Bronze -> Silver -> Gold

Goal:

Implement medallion architecture.

---

# Project 5 — Analytics Pipeline

Modules used:

- Databricks
- Power BI

Architecture:

Gold tables -> BI dashboards

Goal:

Deliver business insights.

---

# Project 6 — Orchestrated Data Platform

Modules used:

- Airflow
- Spark
- Delta

Architecture:

Airflow -> Spark jobs -> Delta tables

Goal:

Understand orchestration.

---

# Project 7 — Transformation Layer

Modules used:

- dbt
- Delta

Architecture:

Silver tables -> dbt models -> marts

Goal:

Create maintainable SQL models.

---

# Project 8 — Real-time Metrics Platform

Modules used:

- Kafka
- Flink

Architecture:

Events -> Flink -> real-time aggregates

Goal:

Implement streaming analytics.

---

# Project 9 — Observability Pipeline

Modules used:

- monitoring
- logging
- metrics

Goal:

Monitor pipeline health and performance.

---

# Project 10 — Full Data Platform

Modules used:

All modules.

Architecture:

Sources
-> Kafka ingestion
-> Spark / Flink processing
-> Delta / Iceberg tables
-> dbt transformation
-> BI dashboards
-> Airflow orchestration
-> monitoring + data quality

Goal:

Build a production-style data platform.
EOF


log "Docs core md created."