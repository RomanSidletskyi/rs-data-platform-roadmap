# Task Set 03: Ingestion and Replay

## Task 1: Choose a Pattern

Choose a loading approach for (a) a nightly 200 GB file batch, (b) a steady stream of small files with a five-minute freshness target, and (c) row events with a seconds-level target. State what additional information is needed before a final choice.

## Task 2: Design a File Contract

Define the minimum metadata needed to reconcile expected files with loaded rows and identify a retry.

## Task 3: Failure Handling

A batch contains one malformed file. Compare abort, quarantine, and skip behaviors. Select one for a financial dataset and justify it.

## Task 4: Idempotency

Explain why re-running `COPY INTO` or reprocessing a renamed file may not satisfy business idempotency. Propose a stable key and replay rule.

## Task 5: External Storage Access

Describe the identity and permission boundaries to review when a Snowflake stage reads cloud object storage.