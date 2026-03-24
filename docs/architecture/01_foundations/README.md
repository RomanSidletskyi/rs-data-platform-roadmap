# Data Engineering Foundations

This section introduces the base concepts needed to reason about data-platform architecture rather than only individual tools.

These concepts appear in almost every serious system, no matter whether the stack uses Kafka, Spark, Databricks, Airflow, dbt, Delta Lake, or something else.

## What This Topic Is For

Use this topic to build the vocabulary and mental models behind architecture decisions.

The goal is not to memorize definitions.

The goal is to understand why certain system shapes exist and what breaks when the wrong shape is chosen.

## Core Concepts To Learn

- OLTP vs OLAP
- batch vs streaming
- ETL vs ELT
- schema-on-read vs schema-on-write
- latency vs throughput
- idempotency
- partitioning
- lineage
- data quality basics

## What To Pay Attention To

- where truth is created versus where data is only copied
- whether the workload is operational or analytical
- whether freshness really needs seconds, minutes, or hours
- whether reruns and replay can happen safely
- whether storage layout supports later consumption instead of only initial ingestion

## Good Architecture Signals

- the system separates operational and analytical responsibilities clearly
- data movement and data serving are not confused
- pipeline reruns do not corrupt final outputs
- latency requirements are explicit rather than assumed

## Common Mistakes

- choosing streaming because it sounds more advanced than batch
- treating OLTP systems as analytical stores
- ignoring idempotency until reruns create duplicates
- mixing raw storage, transformed storage, and BI consumption into one layer

## Real Examples To Think Through

- why should reporting usually not hit the application database directly
- why does a raw landing layer exist before curated analytical tables
- why can one company use hourly batch and another require near-real-time streaming for the same domain area

Worked example:

- `worked_example_reporting_should_not_hit_oltp.md`

## Interview Questions

- What is the difference between OLTP and OLAP?
- When should you choose batch processing?
- What is idempotency in data pipelines?
- What is schema-on-read?
- Why is partitioning important?

## Read Next

- `resources.md`
- `anti-patterns.md`
- `worked_example_reporting_should_not_hit_oltp.md`
- `../02_batch_architecture/README.md`
- `../03_streaming_architecture/README.md`

## Completion Checklist

- [ ] I understand OLTP vs OLAP
- [ ] I understand batch vs streaming
- [ ] I understand ETL vs ELT
- [ ] I understand schema-on-read vs schema-on-write
- [ ] I understand idempotency
- [ ] I understand partitioning
