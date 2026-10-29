# Solution: Task Set 03

## Task 1

(a) A scheduled bulk load using stages and `COPY INTO` is a reasonable starting point if the batch boundary and replay contract are clear. (b) Snowpipe may fit supported continuous file-arrival semantics. (c) Snowpipe Streaming or a supported event/connector pattern may fit lower-latency rows. Final selection needs file/event sizes, delivery guarantees, ordering, replay, schema change, region support, and cost targets. These are candidates, not universal answers.

## Task 2

Record source system, delivery or batch ID, stable file identity or checksum, expected file count, arrival time, schema/version, row counts, load status, rejected rows, target batch, and replay attempt. Exact fields depend on the source contract.

## Task 3

Abort preserves completeness visibility but blocks the batch until remediation. Skip can improve throughput but risks silent loss. Quarantine isolates the bad input while allowing controlled progress only if consumers can identify partial completeness. For financial data, prefer a visible failure or explicit partial-batch contract over silent skip; the business owner defines whether unaffected files may proceed.

## Task 4

File-level load history does not prove that a renamed or corrected file represents the same business events. Use stable source record IDs, batch/version IDs, and a deterministic deduplication or merge rule. Retain the source and document whether corrections replace, append, or version records.

## Task 5

Review Snowflake storage integration trust, cloud IAM principal and path scope, stage grants, allowed network paths, secret rotation, audit logs, and incident ownership. Test with the production service role rather than a broad administrator identity.