# Real Project Architecture Review Exercises

Use these exercises to review the planned `real-projects/` path as if each project were an architecture proposal.

This is useful even before implementation exists, because it trains the habit of asking architecture questions before code and tooling details dominate the work.

For each project:

1. state the simplest viable architecture
2. identify what new layer or responsibility this project adds compared with the previous one
3. choose the most relevant checklist from this directory
4. list the highest-risk architectural mistake for this stage
5. write one possible ADR title for the project

## Project 01: Python Plus SQL ETL

Path:

- `../../../real-projects/01_python_sql_etl/`

Review focus:

- batch pipeline shape
- raw versus curated boundaries
- rerun and backfill safety

Main question:

- is this still a simple scheduled ETL or is hidden orchestration complexity already appearing

## Project 02: Python Plus Docker Plus GitHub Actions

Path:

- `../../../real-projects/02_python_docker_github_actions/`

Review focus:

- packaging and delivery boundaries
- CI validation versus local-only workflows
- reproducibility across environments

Main question:

- does containerization add real delivery value here or only ceremony

## Project 03: Python Plus Kafka

Path:

- `../../../real-projects/03_python_kafka/`

Review focus:

- when streaming is justified
- topic and consumer responsibilities
- replay and idempotency design

Main question:

- what business value makes Kafka stronger than scheduled extraction here

## Project 04: Python Plus Kafka Plus Databricks

Path:

- `../../../real-projects/04_python_kafka_databricks/`

Review focus:

- transition from event transport into analytical processing
- separation between raw event landing and modeled outputs
- platform complexity growth

Main question:

- are streaming ingestion and analytical transformation responsibilities separated clearly

## Project 05: Python Plus Spark Plus Delta

Path:

- `../../../real-projects/05_python_spark_delta/`

Review focus:

- lakehouse layer responsibilities
- distributed compute justification
- table-format operational value

Main question:

- what real need justifies Spark and Delta instead of a simpler batch stack

## Project 06: Databricks Plus ADLS Plus Power BI

Path:

- `../../../real-projects/06_databricks_adls_powerbi/`

Review focus:

- medallion-to-serving flow
- semantic consistency
- BI consumption boundaries

Main question:

- where does business-facing truth become stable enough for dashboards

## Project 07: Kafka Plus Databricks Plus Power BI

Path:

- `../../../real-projects/07_kafka_databricks_powerbi/`

Review focus:

- mixed latency architecture
- streaming ingestion versus curated reporting layers
- freshness promises versus actual business need

Main question:

- which parts truly need low latency and which should remain scheduled and curated

## Project 08: End-To-End Data Platform

Path:

- `../../../real-projects/08_end_to_end_data_platform/`

Review focus:

- whole-system architecture shape
- governance and ownership
- reliability, cost, and reviewability of the platform as a whole

Main question:

- can the full platform still be explained as a small number of clear responsibilities and decisions

## Read With

- `review-exercises.md`
- `reviewer-notes.md`
- `real-project-reviewer-notes.md`
- `system-shape-review-checklist.md`
- `batch-pipeline-review-checklist.md`
- `streaming-platform-review-checklist.md`
- `lakehouse-serving-review-checklist.md`
- `governance-security-review-checklist.md`
- `reliability-cost-review-checklist.md`
- `../../../real-projects/README.md`