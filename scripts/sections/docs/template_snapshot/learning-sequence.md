# Learning Sequence

This document describes the recommended order for studying the modules that currently exist in the repository.

Primary goal:

Move from tool knowledge to platform engineering and then to architecture thinking.

## Current Active Scope

The current active and curated module path is:

- `00-shell-linux`
- `00-git`
- `01-python`
- `02-sql`
- `03-docker`
- `04-github-actions`
- `05-confluent-kafka`
- `06-spark-pyspark`
- `07-databricks`
- `08-delta-lake`
- `09-azure-data-lake-storage`
- `11-airflow`
- `12-dbt`
- `15-raspberry-pi-homelab`

Planned placeholder directories already present in the repository, but intentionally outside the current active learning scope, are:

- `10-powerbi-fabric`
- `13-flink`
- `14-iceberg`

---

# Phase 0 - Foundational Workflow

Modules:

- `00-shell-linux`
- `00-git`

Focus:

- command-line execution literacy
- repository and history literacy
- operational confidence before higher-level tooling

Example outcomes:

- shell-based ops toolkit
- Git workflow and recovery lab

---

# Phase 1 - Engineering Basics

Modules:

- `01-python`
- `02-sql`
- `03-docker`
- `04-github-actions`

Focus:

- coding
- automation
- reproducible runtime setup
- CI discipline

Example outcome:

- Python ETL pipeline built, containerized, and checked in CI

---

# Support Module - Homelab Runtime

Module:

- `15-raspberry-pi-homelab`

Focus:

- self-hosted lab machine
- remote Docker runtime
- lightweight service operations
- storage and monitoring basics

When to study it:

- after `03-docker`
- before or alongside `11-airflow` if you want a remote lab environment

---

# Phase 2 - Data Processing

Modules:

- `05-confluent-kafka`
- `06-spark-pyspark`

Focus:

- event ingestion
- distributed data processing

Example outcomes:

- Kafka producer and consumer flow
- Spark ETL pipeline

---

# Phase 3 - Lakehouse Foundations

Modules:

- `07-databricks`
- `08-delta-lake`
- `09-azure-data-lake-storage`

Focus:

- scalable data platform execution
- storage design and governance
- reliability and table semantics

Recommended internal order:

1. `07-databricks`
2. `08-delta-lake`
3. `09-azure-data-lake-storage`

Reason:

- Databricks explains the compute and workspace layer
- Delta explains the table and reliability layer
- ADLS explains the storage and namespace layer

---

# Planned Phase - Analytics Delivery

Module:

- `10-powerbi-fabric`

Current status:

- planned placeholder for a later learning pass

Focus:

- business intelligence delivery
- semantic modeling
- dashboard consumption

Example outcome:

- gold data products exposed to BI consumers

---

# Phase 5 - Orchestration And Transformation

Modules:

- `11-airflow`
- `12-dbt`

Focus:

- scheduling and dependency control
- SQL modeling, tests, and documentation

Recommended internal order:

1. `11-airflow`
2. `12-dbt`

Reason:

- orchestration helps frame execution flow first
- dbt then fits naturally as a transformation layer inside that broader platform

---

# Planned Phase - Streaming And Open Table Formats

Modules:

- `13-flink`
- `14-iceberg`

Current status:

- planned placeholders for later streaming and open-table-format work

Focus:

- stateful streaming systems
- engine-independent lakehouse table formats

Example outcomes:

- Kafka to Flink real-time metrics
- Iceberg tables shared across engines

---

# Suggested End-to-End Path

If the goal is fastest progress toward data-platform architecture thinking, a strong route is:

1. `00-shell-linux`
2. `00-git`
3. `01-python`
4. `02-sql`
5. `03-docker`
6. `04-github-actions`
7. `05-confluent-kafka`
8. `06-spark-pyspark`
9. `07-databricks`
10. `08-delta-lake`
11. `09-azure-data-lake-storage`
12. `11-airflow`
13. `12-dbt`

Then add these later when you intentionally open the planned placeholders:

1. `10-powerbi-fabric`
2. `13-flink`
3. `14-iceberg`

Use `15-raspberry-pi-homelab` alongside the engineering and orchestration phases when a persistent remote lab host is useful.

---

# Future Expansion

Future phases may later include additional modules for:

- data quality
- observability
- cloud architecture
- infrastructure as code

Those are roadmap extensions, not current repository modules.
