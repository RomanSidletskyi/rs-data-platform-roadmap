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

Purpose:

Expose business data to analysts.

Example:

Gold tables -> semantic model -> dashboards

---

## Engineering Enablement

Modules:

00-shell-linux
00-git
03-docker
04-github-actions
15-raspberry-pi-homelab

Purpose:

Command-line runtime literacy, repository control, reproducible environments, CI/CD pipelines, and self-hosted lab runtime.

---

## Self-Hosted Lab Environment

Module:

15-raspberry-pi-homelab

Purpose:

Provide a lightweight remote host for Docker workloads, persistent volumes, and service operations practice.

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

Purpose:

Stateful real-time stream processing.

Example:

Kafka -> Flink -> aggregated metrics

---

## Open Table Formats

Module:

14-iceberg

Purpose:

Engine-independent lakehouse tables.

---

# Production Layers

## Data Quality

Module:

16-data-quality

Purpose:

Validate datasets before consumption.

---

## Observability

Module:

17-observability

Purpose:

Monitor pipelines and infrastructure.

---

## Cloud Architecture

Module:

18-cloud-architecture

Purpose:

Understand cloud-native data platform design.

---

## Infrastructure as Code

Module:

19-terraform

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
