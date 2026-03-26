# Event Contracts And Schema Evolution

## Why This Topic Matters

Kafka systems often fail not because the broker is broken, but because producers and consumers stop agreeing on what events mean.

That is a contract failure.

## What An Event Contract Is

An event contract is the shared definition of:

- event meaning
- required fields
- optional fields
- field types
- compatible evolution rules

If producers change the event shape casually, consumers may break silently or process incorrect data.

## Schema Evolution Problem

Real systems change over time.

Examples:

- adding a new field
- renaming a field
- changing a numeric field to string
- changing timestamp format
- removing a field that older consumers still expect

Without evolution discipline, Kafka becomes a stream of surprises instead of a reliable transport layer.

## Safe Evolution Example

Version 1:

```json
{
  "event_id": "evt-1001",
  "order_id": "ord-501",
  "amount": 149.90
}
```

Version 2:

```json
{
  "event_id": "evt-1001",
  "order_id": "ord-501",
  "amount": 149.90,
  "currency": "EUR"
}
```

Why this is relatively safe:

- new field added
- older consumers may ignore it
- existing meaning is preserved

## Dangerous Evolution Example

Version 1:

```json
{
  "amount": 149.90
}
```

Version 2:

```json
{
  "amount": "149.90 EUR"
}
```

Why this is dangerous:

- field type and meaning changed radically
- downstream parsing logic may fail or produce wrong results

## Field Removal Risk

If a consumer still requires `order_id` and a producer removes it, replay and sink processing may become impossible.

This is why schema evolution needs governance rather than ad hoc producer changes.

## Good Strategy

- evolve schemas intentionally
- add fields more easily than removing or radically redefining them
- preserve stable semantics for existing fields
- version contracts when change is materially meaningful

## Bad Strategy

- let every producer team change fields whenever convenient
- change field type and meaning without downstream review
- assume JSON flexibility is automatically good engineering

## Example: Multi-Consumer Impact

One topic may feed:

- analytics loader
- fraud detection
- operational storage updater

A careless schema change can break all three in different ways.

That is why event contracts are part of platform governance, not only app-level convenience.

## Key Architectural Takeaway

Event contracts are how Kafka streams remain stable as systems evolve.