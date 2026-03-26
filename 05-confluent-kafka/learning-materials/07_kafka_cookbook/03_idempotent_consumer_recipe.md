# Idempotent Consumer Recipe

## Goal

Make repeated delivery safe for downstream business outcomes.

This matters because Kafka pipelines do not become safe merely because retries are configured carefully.

If the sink side creates duplicate business actions, the architecture is still weak.

## Recipe

1. Use a stable event identifier.
2. Check whether the event has already been applied.
3. Use idempotent writes such as upsert or dedup table patterns.
4. Commit offsets only after safe handling.

## Why Duplicates Happen

Duplicates are normal risks in distributed pipelines.

Common causes:

- consumer writes successfully but crashes before offset commit
- producer retries after uncertain acknowledgement
- replay after a bug fix reprocesses historical events
- multiple delivery attempts happen during recovery behavior

## Common Idempotency Patterns

### 1. Dedup By Event ID

Store processed `event_id` values and skip already-applied events.

Strong for:

- billing
- irreversible side effects
- high-correctness sinks

### 2. Upsert By Business Key

Write records in a way that repeated processing updates the same target row rather than creating duplicates.

Strong for:

- operational serving tables
- latest-state sinks

### 3. Append Then Deduplicate Later

Accept duplicate raw landing and clean it later in analytical processing.

Strong for:

- bronze or staging layers
- analytical ingestion where raw lineage matters

Weaker for:

- financial side effects
- operational workflows with immediate external consequences

## Example Thinking

### Billing consumer

Bad outcome:

- same event creates two invoices

Stronger outcome:

- event is ignored if `event_id` already exists in processed ledger

### Lakehouse landing consumer

Acceptable pattern:

- raw events land append-only
- downstream transformation deduplicates by `event_id`

The right idempotency shape depends on business consequences.

## Example

A billing consumer should not create two invoices because the same event was retried.

## Offset Rule Of Thumb

Do not treat offset commit as the idempotency strategy.

Offset commit only records consumer progress.

It does not guarantee that the downstream side effect is unique.

## Anti-Patterns

- assuming Kafka alone prevents duplicates everywhere
- committing offsets before durable handling is safe
- confusing sink overwrite behavior with actual business idempotency

## Rule

Kafka retries are normal; business duplication should not be.