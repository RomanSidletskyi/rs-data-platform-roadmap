# Lakehouse to BI System Design

## Problem Statement

Design a data platform that ingests raw data into a lakehouse and serves business-ready data to a BI tool.

## Typical Use Cases

- executive and operational dashboards
- curated analytical marts
- historical analytics on raw plus refined data

## Typical Architecture

    Sources -> Bronze -> Silver -> Gold -> Semantic Layer -> Dashboards

## Core Components

- raw ingestion layer
- bronze, silver, and gold tables
- semantic or serving layer
- dashboard or BI consumption layer

## Why Each Component Exists

### Bronze

Preserves raw enough data for replay, debugging, and lineage.

### Silver

Applies technical cleanup and standardization.

### Gold

Exposes stable business-facing facts and dimensions.

### Semantic Layer

Protects BI from raw storage complexity and metric drift.

## When To Use It

- business users need curated, trusted, and performant analytics
- historical depth plus layered transformation matter
- raw and business-serving concerns should stay separated

## When Not To Use It

- tiny local workflows
- one-off ad hoc analysis with no reuse value
- cases where raw files or a single-table report fully satisfy the need

## Failure Points

- dashboards query silver or bronze directly
- gold logic is unstable or duplicated across reports
- raw history is not preserved, making correction or replay weak

## Observability

Watch:

- data freshness by layer
- quality checks between layers
- semantic-model refresh health
- dashboard query failures or latency

## Interview Questions

- Why not connect BI directly to raw files?
- What is the purpose of bronze, silver, and gold?
- Why use a semantic layer?

## Read With

- `README.md`
- `../trade-offs/dbt-vs-sql-scripts.md`
- `../case-studies/03_semantic_serving_layer_for_executive_bi.md`
