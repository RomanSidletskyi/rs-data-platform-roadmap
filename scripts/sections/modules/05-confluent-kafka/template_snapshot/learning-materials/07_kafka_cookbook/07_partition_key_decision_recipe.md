# Partition Key Decision Recipe

## Goal

Choose a Kafka partition key that protects correctness first and scaling second, without pretending those two concerns are always identical.

## Why This Matters

Partition-key choice affects:

- ordering guarantees
- consumer correctness
- partition skew risk
- effective throughput
- replay readability

Many teams choose a key too quickly and only discover later that they optimized for the wrong thing.

## Recipe

1. Identify the entity that must preserve local ordering.
2. Check whether that entity key has healthy enough cardinality for distribution.
3. Estimate whether a few dominant keys could create hot partitions.
4. Verify that downstream consumers actually process by that entity.
5. Document why this key was chosen and what trade-off it accepts.

## Decision Questions

### 1. What must remain ordered?

Examples:

- order lifecycle events should often be keyed by `order_id`
- payment lifecycle events should often be keyed by `payment_id`
- telemetry events may be keyed by `device_id`

### 2. Is the key high-cardinality enough?

High-cardinality keys usually distribute better.

Low-cardinality keys often create skew.

Risky examples:

- `country_code`
- `status`
- `event_type`

### 3. Could one key dominate traffic?

Even a correct-looking key can become dangerous if one entity is disproportionately large.

Example:

- `merchant_id` may be correct, but one giant merchant can still overload one partition

## Good Patterns

### Orders

- topic: `sales.order_events`
- key: `order_id`
- reason: order-local correctness matters most

### IoT

- topic: `iot.device_events`
- key: `device_id`
- reason: per-device order matters and device population is often broad enough for distribution

### Clickstream

- topic: `web.clickstream_events`
- possible key: `session_id`
- reason: session-local order may matter more than user-global order

## Bad Patterns

- using `event_type` because it looks readable
- using random keys when downstream state reconstruction needs entity-local ordering
- using `country_code` because it sounds business-friendly

## Trade-Off Example

For clickstream:

- `session_id` improves session-local sequencing
- `user_id` improves user-centric grouping across sessions

Neither is universally correct.

The right answer depends on downstream processing semantics.

## Rule

Choose the partition key around downstream correctness and workload shape, not around convenience or aesthetics.