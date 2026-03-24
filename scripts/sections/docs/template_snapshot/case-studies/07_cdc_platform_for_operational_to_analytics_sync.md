# Case Study: CDC Platform For Operational To Analytics Sync

## Scenario

A company has several operational databases that power orders, inventory, payments, and customer accounts.

The analytics team currently receives daily exports, but business users want fresher reporting and data engineers are tired of fragile extraction jobs.

The platform team decides to introduce CDC from operational systems into the analytical platform.

## Main Problem

The company needs fresher analytical data without overloading transactional systems and without forcing full-table extraction jobs every hour.

## Why A Simpler Design Is Not Enough

Simple scheduled exports worked when reporting was daily and the number of source systems was small.

That design now fails because:

- extraction windows collide with production load
- full reloads are wasteful
- schema changes are discovered too late
- downstream teams want a more continuous flow of changes

## High-Level Architecture

    Operational Databases
        ->
    CDC Connectors
        ->
    Kafka Topics / Change Stream
        ->
    Raw Change Landing
        ->
    Consolidation / Upsert Modeling
        ->
    Curated Analytical Tables
        ->
    Dashboards / Data Products

## Key Decisions

### CDC Instead Of Scheduled Full Extraction

The system is optimized around change capture because the real business need is freshness with lower extraction pressure, not just more frequent batch jobs.

### Raw Change History Before Curated State

The team keeps raw change events first so schema drift, replay, and correction remain possible.

### Separate Change Transport From Analytical Modeling

Transporting row-level changes and building business tables are treated as different responsibilities.

## What Makes This Architecture Strong

- transactional systems are less stressed than under repeated full pulls
- downstream consumers can move closer to near-real-time without losing replayability
- data engineers can diagnose source changes through preserved raw events

## What Could Go Wrong

- teams treat raw change events as business-ready tables
- delete and update semantics are handled inconsistently
- schema evolution is not governed, causing downstream breakage
- exactly-once assumptions are made where only idempotent sinks are realistic

## Simpler Alternative

Use scheduled incremental extraction with watermark columns.

That is still valid when source systems are few, freshness targets are moderate, and CDC operational cost is not justified.

## Lessons Learned

- CDC is strongest when source pressure, freshness, and replay all matter at the same time
- raw change streams and curated business truth should not be collapsed into one layer
- freshness without schema discipline creates faster failure, not better architecture

## Read With

- `../architecture/03_streaming_architecture/README.md`
- `../architecture/07_scalability_reliability/README.md`
- `../system-design/kafka-ingestion.md`
- `../system-design/hybrid-batch-streaming.md`
- `../trade-offs/kafka-vs-batch-ingestion.md`