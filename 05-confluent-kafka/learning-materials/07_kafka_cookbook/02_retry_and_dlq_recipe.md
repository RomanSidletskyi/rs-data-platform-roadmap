# Retry And DLQ Recipe

## When To Use

Use this pattern when consumers interact with systems that may fail transiently or permanently.

Typical cases:

- database sink writes
- downstream HTTP APIs
- schema or payload validation
- storage landing pipelines

The goal is not "retry everything."

The goal is to keep healthy traffic moving while isolating records that cannot currently or ever be processed safely.

## Recipe

1. Validate the event early.
2. Separate transient failures from permanent failures.
3. Retry transient failures with bounded policy.
4. Route permanent or exhausted failures to DLQ.
5. Add diagnostic metadata for later triage.

## How To Think About Failure Types

### Transient failures

These may succeed later without changing the event.

Examples:

- temporary Postgres timeout
- short network issue
- sink service restart
- rate limit that clears after backoff

### Permanent failures

These will not succeed just by waiting.

Examples:

- missing required business field
- invalid schema version
- malformed JSON
- impossible data type for required sink field

## Basic Pattern

### Step 1: Validate before side effects

Reject obviously bad events before attempting expensive writes.

### Step 2: Retry only boundedly

Retries without limits turn one bad dependency into a platform slowdown.

### Step 3: Preserve evidence in DLQ

A DLQ record without metadata is only slightly better than dropping the event.

Include enough fields to answer:

- what failed?
- why did it fail?
- where did it come from?
- when did it fail?
- which event was affected?

## Example Flow

Event:

- `payment_captured`

Consumer responsibility:

- write to operational Postgres sink

Possible outcomes:

- success: write record, then commit offset
- transient DB failure: retry with backoff up to a limit
- malformed event: send to DLQ immediately
- repeated sink timeout after max retries: send to DLQ with retry metadata

## Example

- transient: temporary Postgres timeout
- permanent: malformed payload missing required business field

## Good DLQ Shape

Useful metadata often includes:

- original topic
- event ID
- failure time
- error type
- error reason
- original payload
- optional retry count

## Anti-Patterns

- infinite retries for poison messages
- silent dropping of permanently bad events
- DLQ without enough metadata to debug later
- offset commits before safe handling is complete

## Rule

Do not keep poison messages in infinite retry loops.