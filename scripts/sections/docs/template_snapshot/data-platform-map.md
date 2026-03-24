# Data Platform Map

This document explains how all modules in this repository fit into a modern data platform.

The goal is to understand:

- where each technology sits in the architecture
- what problem it solves
- how systems connect together

This document describes the current repository scope first.

Where future platform layers are mentioned, they should be read as planned extensions rather than existing modules.

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

- `01-python`
- `02-sql`
- `05-confluent-kafka`

Purpose:

Move data from source systems into the platform.

Examples:

API -> Python -> Data Lake

Application -> Kafka -> Stream consumers

---

## Processing Layer

Modules:

- `06-spark-pyspark`
- `07-databricks`

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

- `08-delta-lake`
- `09-azure-data-lake-storage`

Purpose:

Reliable storage of raw and processed data.

Typical layout:

`data-lake/`
`raw/`
`bronze/`
`silver/`
`gold/`

---

## Analytics Layer

Module:

- `10-powerbi-fabric`

Current status:

- planned placeholder module for a later repository pass

Purpose:

Expose business data to analysts.

Example:

Gold tables -> semantic model -> dashboards

---

## Engineering Enablement

Modules:

- `00-shell-linux`
- `00-git`
- `03-docker`
- `04-github-actions`
- `15-raspberry-pi-homelab`

Purpose:

Command-line runtime literacy, repository control, reproducible environments, CI/CD pipelines, and self-hosted lab runtime.

---

## Self-Hosted Lab Environment

Module:

- `15-raspberry-pi-homelab`

Purpose:

Provide a lightweight remote host for Docker workloads, persistent volumes, and service operations practice.

---

# Platform Extensions

## Orchestration

Module:

- `11-airflow`

Purpose:

Coordinate pipeline execution and scheduling.

---

## Transformation Layer

Module:

- `12-dbt`

Purpose:

Maintain SQL transformation models.

Features:

- tests
- lineage
- documentation

---

## Streaming Compute

Module:

- `13-flink`

Current status:

- planned placeholder module for a later repository pass

Purpose:

Stateful real-time stream processing.

Example:

Kafka -> Flink -> aggregated metrics

---

## Open Table Formats

Module:

- `14-iceberg`

Current status:

- planned placeholder module for a later repository pass

Purpose:

Engine-independent lakehouse tables.

---

# Current End-to-End Flow

One practical repository flow is:

- source systems
- Python or Kafka ingestion
- Spark or Databricks processing
- Delta Lake and ADLS storage design
- dbt transformation layer where needed
- Power BI serving
- Airflow orchestration

Supporting layers already represented in the repository include:

- shell and Git operational literacy
- Docker runtime packaging
- CI through GitHub Actions
- homelab runtime practice

# Future Platform Layers

These are useful platform layers that may later become first-class modules.

They are listed here so the architecture map stays complete, but they are not current repository modules.

## Data Quality

Module:

`16-data-quality` planned

Purpose:

Validate datasets before consumption.

---

## Observability

Module:

`17-observability` planned

Purpose:

Monitor pipelines and infrastructure.

---

## Cloud Architecture

Module:

`18-cloud-architecture` planned

Purpose:

Understand cloud-native data platform design.

---

## Infrastructure as Code

Module:

`19-terraform` planned

Purpose:

Provision infrastructure reproducibly.

---

# Working Interpretation

Use this map as a placement guide:

- modules explain one technology or platform layer deeply
- `docs/` explains how several layers combine
- `real-projects/` is where those layers should later converge into full end-to-end implementations

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
