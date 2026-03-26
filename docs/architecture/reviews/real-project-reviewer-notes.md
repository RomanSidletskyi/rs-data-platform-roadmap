# Reviewer Notes For Real Project Architecture Exercises

Use this file as the reviewer guide for `real-project-review-exercises.md`.

## Project 01: Python Plus SQL ETL

- Best checklist: `batch-pipeline-review-checklist.md`
- Key risk: no raw-preservation or rerun design in an otherwise simple ETL flow
- Simpler architecture: scheduled extraction, raw landing, curated SQL outputs
- Good ADR title: `Use Scheduled Batch ETL With Raw Preservation`

## Project 02: Python Plus Docker Plus GitHub Actions

- Best checklist: `system-shape-review-checklist.md`
- Key risk: delivery tooling added without a clear quality or reproducibility need
- Simpler architecture: local workflow plus lightweight validation until packaging pain is real
- Good ADR title: `Use Containerized Execution For Reproducible ETL Delivery`

## Project 03: Python Plus Kafka

- Best checklist: `streaming-platform-review-checklist.md`
- Key risk: Kafka added before low-latency, replay, or multi-consumer value is explicit
- Simpler architecture: incremental batch ingestion if freshness and fan-out remain modest
- Good ADR title: `Use Kafka Only Where Replayable Event Flow Adds Clear Value`

## Project 04: Python Plus Kafka Plus Databricks

- Best checklist: `system-shape-review-checklist.md`
- Key risk: transport, storage, and analytical transformation responsibilities become blurred
- Simpler architecture: explicit raw event landing plus separate curated analytical models
- Good ADR title: `Separate Event Transport From Analytical Transformation`

## Project 05: Python Plus Spark Plus Delta

- Best checklist: `lakehouse-serving-review-checklist.md`
- Key risk: lakehouse stack chosen for label value instead of operational need
- Simpler architecture: batch ETL on simpler storage if scale and repair needs remain small
- Good ADR title: `Adopt Delta Tables Only When Repairability And Layering Matter`

## Project 06: Databricks Plus ADLS Plus Power BI

- Best checklist: `lakehouse-serving-review-checklist.md`
- Key risk: dashboards consume technical layers directly or KPI logic drifts into BI
- Simpler architecture: curated marts plus governed semantic definitions
- Good ADR title: `Serve BI From Curated Semantic Models Over Lakehouse Layers`

## Project 07: Kafka Plus Databricks Plus Power BI

- Best checklist: `streaming-platform-review-checklist.md`
- Key risk: all data is treated as real time even though reporting and governance need curated scheduled layers
- Simpler architecture: hybrid streaming ingestion with scheduled business marts
- Good ADR title: `Use Hybrid Streaming And Batch For Mixed-Latency Analytics`

## Project 08: End-To-End Data Platform

- Best checklist: `system-shape-review-checklist.md`
- Key risk: the platform becomes a tool inventory instead of a small set of understandable responsibilities
- Simpler architecture: retain only the layers needed for source truth, processing, serving, governance, and recovery
- Good ADR title: `Organize The Platform Around Clear Layer Responsibilities`

## What Good Answers Should Show

- the project is evaluated as an architecture stage, not only a tooling bundle
- the main new responsibility added by each project is explicit
- complexity growth is questioned at every step
- each project can produce at least one defendable ADR