# Solutions: Cost Performance And Reliability

## Task 1

Cost is driven by storage volume, transaction patterns, redundancy choices, retention length, listing behavior, and unnecessary copies.

## Task 2

Small files increase metadata pressure, path listing overhead, and downstream processing inefficiency.

That makes them a storage-layout and operating-discipline issue, not only a compute tuning issue.

## Task 3

Raw often needs longer retention for replay and audit.

Curated retention depends on rebuild cost and downstream dependency.

Publish retention should protect consumer stability.

Temporary and backfill paths should usually have tighter cleanup rules.

## Task 4

Useful signals include file-count growth, abnormal path depth, transaction spikes, storage growth, stale temporary paths, failed cleanup activity, and unexpected consumer reads from unstable zones.

## Task 5

Deleting old raw or publish data without review can destroy replay capability, remove audit evidence, or break consumers that depend on stable historical outputs.

Cleanup should first verify path purpose, retention policy, downstream usage, and recovery expectations.
