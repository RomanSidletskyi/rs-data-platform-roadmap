# Replay And Reprocessing Recipe

## Goal

Use Kafka replay deliberately for recovery, backfill, and recomputation without damaging downstream systems.

## Why This Matters

Replay is one of Kafka's biggest architectural advantages.

But replay only helps if the surrounding system can absorb repeated processing safely.

## Recipe

1. Confirm that the required event window is still retained.
2. Identify which consumers and sinks are affected by the replay.
3. Verify whether downstream writes are idempotent or need isolation.
4. Decide whether replay should run in-place or through a separate backfill path.
5. Measure impact on lag, sink throughput, and downstream correctness.

## Common Replay Use Cases

### Recovery after consumer bug

Example:

- a transformation bug wrote wrong tax category values for two days

### New consumer bootstrap

Example:

- a new lakehouse landing consumer must load historical events from Kafka

### Reprocessing after logic change

Example:

- enrichment rules changed and analytical outputs must be recalculated

## Safety Questions

- are the events still available in Kafka?
- can the sink handle duplicate writes safely?
- should replay traffic be separated from live traffic?
- will replay overload a slow database or API dependency?

## Strong Patterns

### Raw landing replay

- often safe when landing is append-first and downstream dedup exists

### Idempotent operational replay

- safe when event IDs or upsert semantics prevent duplicate side effects

### Separate backfill path

- useful when replay volume is large and should not compete directly with live traffic

## Weak Patterns

- replaying directly into non-idempotent sinks without preparation
- assuming replay is safe because Kafka retained the data
- forgetting that replay can create lag and downstream pressure even when logically correct

## Example Decision

Topic:

- `sales.order_events`

Scenario:

- warehouse loader had a bug for 3 days

Good response:

- fix transformation
- confirm raw landing can tolerate duplicates or dedup by `event_id`
- replay the affected window only

Bad response:

- replay the whole topic blindly into the same fragile sink path

## Rule

Replay is only a strength when retention, sink behavior, and operational capacity were designed for it in advance.