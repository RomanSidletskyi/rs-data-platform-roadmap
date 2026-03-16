# Learning Sequence

This roadmap describes the recommended order for learning modules.

Goal:

Move from tool knowledge -> platform engineering -> architecture thinking.

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

# Phase 4 — Analytics

Module:

10-powerbi-fabric

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

# Phase 7 — Streaming Systems

Module:

13-flink

Focus:

- event time
- streaming windows
- checkpointing

Example project:

Kafka -> Flink -> real-time metrics

---

# Phase 8 — Lakehouse Formats

Module:

14-iceberg

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
