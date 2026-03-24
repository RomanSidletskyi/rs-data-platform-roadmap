# Lakehouse Ingestion Recipe

## Goal

Move Kafka events into analytical storage without losing replay and modeling discipline.

This recipe matters because teams often confuse three different layers:

- Kafka transport
- raw analytical landing
- curated analytical models

When those layers blur, replay and lineage become hard to reason about.

## Recipe

1. Land raw events into bronze or staging storage.
2. Preserve metadata needed for replay and lineage.
3. Transform raw events into curated analytical models.
4. Keep Kafka as upstream event transport, not the final analytics layer.

## What Raw Landing Should Preserve

Strong raw landing usually keeps:

- original event payload
- event timestamp
- ingestion timestamp
- topic name
- partition and offset when available
- event ID or business key

This helps with:

- lineage
- replay diagnostics
- deduplication logic
- backfill analysis

## Example

`sales.order_events` lands in bronze first, then feeds curated order facts and dimensions.

## Typical Multi-Layer Shape

### Bronze

- raw landed event records
- minimal transformation
- keeps evidence and lineage

### Silver

- normalized and cleaned records
- deduplicated and typed correctly

### Gold

- business-facing analytical models
- facts, dimensions, KPI-ready tables

Kafka usually belongs upstream of all three.

## Good Questions To Ask

- what metadata is needed to debug replay later?
- should duplicates be tolerated in bronze and removed later?
- which transformation belongs in streaming compute versus analytical modeling layers?
- what must remain queryable long after Kafka retention expires?

## Anti-Patterns

- using Kafka itself as long-term analytics storage
- landing only transformed data and losing raw lineage
- skipping metadata that would later help dedup or audit replay

## Rule

Do not confuse durable event transport with analytical data modeling.