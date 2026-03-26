# Batch Architecture Anti-Patterns

## Why This Note Exists

Batch systems fail most often when teams assume scheduled processing automatically means safe and simple processing.

## Anti-Pattern 1: Full Refresh Everywhere

Why it is bad:

- costs and runtimes grow unnecessarily
- one late upstream dependency can delay the whole chain

Better signal:

- full refresh is used deliberately where correctness is simpler than incremental state

## Anti-Pattern 2: No Backfill Strategy

Why it is bad:

- incidents become manual firefights
- reruns corrupt downstream layers or produce duplicates

Better signal:

- backfills, reruns, and partial recovery are designed before the first serious failure

## Anti-Pattern 3: BI Reads Intermediate Layers

Why it is bad:

- users consume unstable schemas
- technical cleanup tables become accidental business contracts

Better signal:

- BI reads curated and stable serving outputs only

## Anti-Pattern 4: Hourly Batch Presented As Real Time

Why it is bad:

- stakeholders trust freshness that the platform does not actually provide
- operational decisions are made from stale data

Better signal:

- freshness promises match the real update model

## Review Questions

- if yesterday's load failed, how would we rerun safely
- which layers are allowed to be queried by business users
- what breaks first if volume doubles