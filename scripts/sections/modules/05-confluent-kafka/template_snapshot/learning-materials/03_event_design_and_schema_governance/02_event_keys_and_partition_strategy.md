# Event Keys And Partition Strategy

## Why This Topic Matters

The event key is one of the most important fields in Kafka design.

It influences:

- partition placement
- ordering behavior
- hot-spot risk
- consumer correctness
- replay and debugging patterns

So key choice is not a cosmetic decision.

It is architecture.

## What A Key Usually Does

In many Kafka designs, the key determines which partition receives the record.

That means the key shapes two things at once:

- ordering scope
- load distribution

## Example: Orders

Events:

- `order_created`
- `order_paid`
- `order_shipped`

Good key:

- `order_id`

Why:

- all lifecycle events for the same order stay together
- downstream order-state consumers get stable per-order ordering

## Example: Payments

Events:

- `payment_initiated`
- `payment_authorized`
- `payment_captured`

Good key:

- `payment_id`

Why:

- payment lifecycle remains coherent

## Example: IoT

Events:

- telemetry reports from devices

Good key:

- `device_id`

Why:

- per-device ordering matters more than global ordering
- partitions can spread across large device populations

## Example: Clickstream

Possible keys:

- user ID
- session ID

Trade-off:

- user ID improves per-user grouping across sessions
- session ID improves session-local ordering

This choice should follow the downstream use case, not intuition alone.

## Bad Key Choices

### Random key or no key

This may spread load, but weakens entity-local ordering.

### Country as key

This often creates hot partitions if one country dominates traffic.

### Status as key

Very low-cardinality fields usually create unhealthy skew.

## Partition Strategy Questions

Before choosing a key, ask:

- what entity needs ordered processing?
- how many distinct key values will exist?
- could one key dominate traffic?
- will consumers process by entity or by broad aggregate?
- what replay or debugging patterns will matter later?

## Example Comparison

### Good topic design

Topic:

- `sales.order_events`

Key:

- `order_id`

Result:

- order-local ordering
- sensible downstream reconstruction

### Weak topic design

Topic:

- `sales.order_events`

Key:

- `status`

Problems:

- low-cardinality skew
- poor entity-local ordering
- weak downstream state modeling

## Good Strategy

- pick keys around entity-local ordering or consumer correctness needs
- avoid low-cardinality hot-spot keys
- document why the chosen key exists

## Key Architectural Takeaway

Partition-key choice is one of the most important correctness and scale decisions in Kafka architecture.