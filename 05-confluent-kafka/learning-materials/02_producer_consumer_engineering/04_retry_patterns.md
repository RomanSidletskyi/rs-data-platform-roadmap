# Retry Patterns

## Why This Topic Matters

Real event systems fail in small ways constantly.

Examples:

- database temporarily unavailable
- downstream API timeout
- serialization bug in one record
- network hiccup

If the retry strategy is weak, the whole event pipeline becomes fragile.

## Retry Is Not One Thing

Different failures need different responses.

Some failures are transient:

- short network issue
- temporary storage lock
- brief downstream overload

Some failures are persistent:

- malformed payload
- unsupported schema version
- missing required field

Treating both kinds the same is a major design mistake.

## Simple Retry Pattern

Basic pattern:

1. consume record
2. attempt processing
3. if transient failure, retry a limited number of times
4. if still failing, move to another handling path

This is reasonable only if the system distinguishes temporary failure from bad data.

## Example 1: Transient Postgres Write Failure

Scenario:

- consumer writes valid order event to Postgres
- Postgres is briefly unavailable

Good behavior:

- retry a limited number of times
- keep processing logic bounded
- avoid infinite silent looping

## Example 2: Malformed Event

Scenario:

- event is missing required field `order_id`

Bad behavior:

- retry the same broken payload forever

Good behavior:

- classify as bad event
- route to DLQ or quarantine path
- make it observable for investigation

## Immediate Retry vs Deferred Retry

Immediate retry is useful when:

- the failure is likely brief
- retry cost is low

Deferred retry is useful when:

- downstream system needs recovery time
- immediate retry would amplify pressure
- poison messages must be separated from healthy flow

## Backoff Thinking

When retries are too aggressive, they can worsen incidents.

That is why backoff matters.

The exact algorithm may vary, but the architectural principle is simple:

- repeated failure should not produce uncontrolled pressure spikes

## Good Strategy

- separate transient failures from bad-data failures
- limit retries
- make failures observable
- combine retries with idempotent processing

## Bad Strategy

- infinite retries for broken payloads
- hidden retry loops that no one can observe
- retry behavior with no DLQ or investigation path

## Cookbook Example

Healthy pattern for an order sink consumer:

- if Postgres times out, retry 3 times with backoff
- if payload cannot be validated, send to DLQ immediately
- if downstream write succeeds, commit offset safely
- if retries are exhausted, route to explicit failure path

## Key Architectural Takeaway

Retries are part of resilience design, but only when paired with bounded behavior, observability, and bad-record isolation.