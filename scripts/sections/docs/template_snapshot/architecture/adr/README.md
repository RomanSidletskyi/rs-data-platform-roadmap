# Architecture Decision Records

This directory contains architecture decisions used across the repository.

The goal is to document not only what was built, but why specific design choices were made.

## Suggested Reading Order

- 0001 Store Raw Data Before Transformation
- 0002 Separate Raw, Processed, and Curated Layers
- 0003 Choose Batch for Reporting Pipelines
- 0004 Use Kafka for Event Streaming
- 0005 Use Delta Lake for Lakehouse Tables
- 0006 Choose dbt For Curated Transformations
- 0007 Use A Semantic Layer For Shared BI Metrics
- 0008 Prefer Hybrid Batch And Streaming When Latency Is Mixed
- 0009 Enforce Least Privilege For Sensitive Data Products
- 0010 Introduce Quality Gates For Shared Data Products

## How To Use ADRs Here

Read ADRs after you understand the problem shape, trade-off, and system pattern.

An ADR in this repository should answer:

- what decision was made
- why this choice fits the context
- what benefits it creates
- what cost or constraint it introduces

## Read With

- `../README.md`
- `../reviews/README.md`
- `../synthesis/README.md`
- `template.md`

## Template

Use `template.md` when turning a review or trade-off into a concrete architecture decision record.
