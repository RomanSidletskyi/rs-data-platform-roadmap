# Schema Evolution Recipe

## Goal

Change event schemas without silently breaking existing consumers or making replay unsafe.

## Why This Matters

Kafka topics often outlive the services that first created them.

That means schema change is not a local code refactor.

It is a platform compatibility decision.

## Recipe

1. Identify whether the proposed change is additive, semantic, or breaking.
2. Check all known consumers, not only the producer implementation.
3. Prefer additive changes over redefinitions of existing fields.
4. Use compatibility rules or Schema Registry where contracts are shared.
5. Plan rollout and replay behavior before publishing the new shape.

## Change Types

### Usually safer changes

- adding a new optional field
- adding metadata that old consumers can ignore
- extending downstream interpretation without redefining old fields

### Risky or breaking changes

- changing numeric `amount` into a free-form string
- renaming required fields without migration strategy
- changing timestamp semantics or format silently
- removing fields still required by existing consumers

## Example

### Safer evolution

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

### Dangerous evolution

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

## Questions Before Changing A Schema

- who consumes this topic today?
- can old consumers ignore the new field safely?
- would replay of older events still make sense after the change?
- does the field name still mean the same business thing as before?

## Strong Pattern

- additive changes first
- compatibility checks enforced centrally
- rollout notes documented with consumer impact

## Weak Pattern

- producer team changes schema because their local code changed
- downstream teams discover breakage after deployment
- replay later combines old and new semantics inconsistently

## Rule

Treat schema evolution as consumer-facing platform change, not as producer-local implementation detail.