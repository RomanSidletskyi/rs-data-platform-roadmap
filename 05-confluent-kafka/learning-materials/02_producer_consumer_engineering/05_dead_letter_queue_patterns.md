# Dead-Letter Queue Patterns

## Why This Topic Matters

A DLQ is one of the clearest signs that a team understands streaming systems are imperfect.

Bad records happen.

Weak platforms pretend they do not.

## What A DLQ Is

A dead-letter queue or dead-letter topic is a place where records go when the main processing path cannot handle them safely.

Typical reasons:

- malformed payload
- schema mismatch
- missing required field
- persistent downstream rejection

## Why A DLQ Exists

Without a DLQ or equivalent quarantine path, teams often end up with one of two bad choices:

- silently dropping broken records
- blocking the whole consumer pipeline forever on one poison message

Both are bad.

## Example 1: Invalid JSON Event

Scenario:

- producer sends broken JSON
- consumer cannot deserialize it

Good behavior:

- write the original payload and metadata to DLQ
- include reason for failure
- expose metrics and alerting

## Example 2: Unsupported Schema Version

Scenario:

- consumer expects schema version 3
- event arrives with incompatible version 7

Good behavior:

- route record to DLQ
- avoid contaminating main processing
- investigate contract breach

## Example 3: Postgres Rejects One Record Permanently

Scenario:

- downstream table rejects the record because a required business field is impossible to map

Good behavior:

- after bounded retries, move record to DLQ with failure metadata
- continue healthy event flow for valid records

## What Should Be Stored In A DLQ Record

Useful DLQ contents:

- original payload
- original topic and partition
- original offset
- event key
- failure reason
- processing timestamp
- consumer application name

This turns DLQ from a dumping ground into an investigation tool.

## Bad DLQ Practices

- using DLQ as a garbage bin no one ever reads
- storing too little metadata to debug the issue
- routing every transient issue to DLQ instead of retrying appropriately

## Good Strategy

- use DLQ for non-recoverable or exhausted-failure cases
- preserve enough metadata for debugging and replay decisions
- monitor DLQ volume and reasons

## Key Architectural Takeaway

DLQ is not just a failure side topic.

It is an operational safety valve and an observability mechanism for bad-event handling.