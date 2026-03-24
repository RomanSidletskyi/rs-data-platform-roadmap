# Batch ETL System Design

## Problem Statement

Design a batch pipeline that ingests data from source systems, stores raw input, transforms it, and prepares curated outputs for reporting.

## Typical Use Cases

- daily reporting
- finance or reconciliation pipelines
- scheduled CRM or ERP syncs
- historical backfills

## Typical Architecture

    Source -> Ingestion -> Raw -> Transform -> Curated -> BI

## Core Components

- source extract or ingestion layer
- raw landing
- transformation layer
- curated serving layer
- BI or downstream consumer layer

## Why Each Component Exists

### Raw Landing

Preserves source truth before business reshaping and supports replay or debugging.

### Transformation Layer

Normalizes, validates, and enriches the data.

### Curated Layer

Creates stable business-facing outputs rather than exposing technical source schemas.

## When To Use It

- freshness is measured in hours or days
- reruns and backfills matter more than second-level latency
- analytical trust matters more than immediate reaction

## When Not To Use It

- real-time fraud checks
- user-facing low-latency operational reactions
- cases where stale data would create immediate business damage

## Failure Points

- rerun duplicates because the load is not idempotent
- no raw preservation, so corrections are hard to diagnose
- BI reads intermediate layers instead of curated outputs

## Observability

Watch:

- schedule success and duration
- partition completeness
- late-arriving data rate
- data quality check failures

## Interview Questions

- Why choose batch over streaming?
- What is the role of raw storage?
- How do you rerun a failed job safely?

## Read With

- `README.md`
- `../trade-offs/kafka-vs-batch-ingestion.md`
- `../case-studies/01_batch_lakehouse_for_finance_reporting.md`
