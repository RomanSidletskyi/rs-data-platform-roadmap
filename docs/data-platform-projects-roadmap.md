# Data Platform Projects Roadmap

This document lists recommended end-to-end projects for mastering the full data platform stack.

The projects gradually combine more modules from the roadmap.

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
