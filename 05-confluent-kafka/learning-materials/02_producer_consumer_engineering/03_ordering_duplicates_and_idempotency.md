# Ordering, Duplicates, And Idempotency

## Why This Topic Matters

This is one of the most important sections in the whole Kafka module.

A learner who understands topics and partitions but does not understand duplicates and idempotency is still not ready for real event systems.

## Ordering Reality

Kafka gives ordering within a partition.

Kafka does not give global ordering across the whole topic.

That means ordering guarantees depend on:

- partition-key choice
- downstream assumptions
- how many entities are mixed into the same stream

## Example: Order Lifecycle Events

Suppose an order emits:

- `order_created`
- `order_paid`
- `order_shipped`

If all of them use key `order_id`, they are likely to stay in the same partition, which preserves per-order ordering.

If they use random keys or no key, downstream systems may see weaker ordering behavior for one order's lifecycle.

## Duplicates Are Normal Enough To Design For

Duplicates can appear because of:

- producer retries
- consumer restarts
- offset commit timing
- replay
- downstream uncertainty about whether a write succeeded

The right mental model is not:

- can duplicates happen?

The right mental model is:

- where can duplicates appear, and how does the system stay correct when they do?

## Idempotency

Idempotency means applying the same event multiple times does not corrupt the final state.

This can be achieved in different ways.

### Example 1: Event-ID dedup table

If each event has a stable `event_id`, a sink can record processed event IDs.

If the same event arrives again:

- skip re-applying it

### Example 2: Upsert by business key

If an event represents the latest state for an entity, downstream storage may use an upsert keyed by that entity.

Example:

- payment event keyed by `payment_id`
- storage row updated idempotently for the same event sequence

### Example 3: Append with downstream dedup

In analytical landing zones, duplicates may be accepted temporarily if:

- event IDs are preserved
- downstream jobs deduplicate explicitly

This can be valid in warehouse-style pipelines.

## Example: Non-Idempotent Consumer

Bad pattern:

- read order event
- add amount to total revenue row blindly
- restart and reprocess same event
- add amount again

Now the downstream system is wrong because replay or duplicate processing inflated revenue.

## Example: Idempotent Consumer

Better pattern:

- read event with `event_id`
- check whether `event_id` already processed
- if not processed, apply change and record the event ID
- if already processed, skip safely

Now retries and restarts become operationally survivable.

## Architecture Implications

Duplicates and replay affect the whole architecture:

- transport design
- consumer storage design
- schema design
- event key design
- analytical modeling

This is why idempotency should be discussed at system-design time, not added as an afterthought during incidents.

## Good Strategy

- choose keys to support the ordering you truly need
- assume duplicates are possible
- design sink behavior to remain correct under replay and retry

## Bad Strategy

- assume Kafka removed duplicates by magic
- aggregate directly in non-idempotent ways
- ignore event IDs or safe dedup keys

## Key Architectural Takeaway

Ordering is scoped, duplicates are normal enough to expect, and idempotency is one of the main correctness tools in event-driven systems.