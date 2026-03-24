# Retention, Replay, And Compaction

## Why This Topic Matters

Kafka is not only a transport layer.

It is also a data retention system with replay capabilities.

That means storage policy decisions affect:

- recovery options
- auditability
- reprocessing ability
- storage cost
- downstream reliability

## Retention

Retention answers a basic question:

- how long should records remain available in Kafka?

This is an architectural decision, not just a broker setting.

### Example

If `sales.order_events` has 7-day retention:

- reprocessing after 2 days is possible
- reprocessing after 30 days is not possible from Kafka alone

So retention must match realistic recovery and replay needs.

## Replay

Replay means reading old events again.

Teams rely on replay for:

- rebuilding downstream state
- recovering after consumer bugs
- backfilling new sinks
- debugging historical flows

### Example

An analytics consumer had a bug and skipped discounts for 3 days.

If Kafka still retains the relevant events, the consumer can be fixed and re-run from an earlier offset.

If retention is too short, replay may be impossible.

## Log Compaction

Compaction keeps the latest value per key instead of preserving every historical record indefinitely.

This can be useful for:

- entity snapshots
- reference data
- latest known state topics

### Example

Topic:

- `customer_profile_latest`

Key:

- `customer_id`

Compaction helps keep the most recent profile per customer.

That is different from a full event-history topic like `customer_profile_changes`.

## Event History Vs State Snapshot

This distinction matters a lot.

### Event history topic

- preserves sequence of changes
- useful for audit and reconstruction

### Snapshot topic

- preserves latest value by key
- useful for serving or syncing current state

Architecture becomes weaker when teams confuse these two models.

## Good Strategy

- set retention based on replay and recovery requirements
- use compaction intentionally for latest-state topics
- keep historical topics when downstream consumers need event history

## Bad Strategy

- use short retention because storage seems expensive without checking replay needs
- compact topics that should preserve event history
- assume all downstream systems can recover from outside Kafka

## Key Architectural Takeaway

Retention and compaction policies define what Kafka can remember for the platform.