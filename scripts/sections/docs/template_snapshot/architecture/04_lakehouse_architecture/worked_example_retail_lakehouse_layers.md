# Worked Example - Retail Lakehouse Layers

## Scenario

A retail analytics platform ingests:

- order events
- product snapshots
- inventory extracts
- refund records

The company wants historical analysis, reliable table semantics, and BI-ready outputs.

## Why A Lakehouse Is A Good Fit

- raw data must be preserved
- several transformation stages are needed
- different consumers need different levels of refinement
- historical repair and backfill matter

## Architecture Shape

    ingestion
        -> bronze raw tables
        -> silver cleaned tables
        -> gold business marts
        -> BI / ML / serving

## Layer Responsibilities

### Bronze

- preserve raw shape
- keep replay and forensic value
- minimal transformation

### Silver

- normalize schemas
- apply deduplication and quality rules
- standardize keys and timestamps

### Gold

- expose business-level facts and dimensions
- optimize for reporting and analytical consumption

## What Good Looks Like

- bronze is not used directly for dashboards
- silver fixes technical quality before business logic is layered on top
- gold has stable business semantics
- table format features support recovery, merge, and governance

## What Bad Looks Like

- only one giant analytics table with mixed responsibilities
- no raw layer, so source debugging becomes impossible
- dashboards read silver because gold is missing
- plain files are treated as if they had reliable table semantics

## Questions To Review

- what belongs in bronze versus silver
- what business contracts become stable in gold
- what replay strategy exists after a transformation bug
- what engine or workflow owns each layer

## Key Takeaway

Lakehouse architecture is valuable when layer boundaries are real operational boundaries, not just folder names.