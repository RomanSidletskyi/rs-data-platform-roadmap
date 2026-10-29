# Project 02: Reliable File Ingestion

## Goal

Design a replayable batch-file pipeline that lands orders in Snowflake, validates the delivery, and produces a typed curated table. The core learning objective is reliability, not choosing the newest ingestion feature.

## Scenario

A source system exports daily order files to object storage. Files can arrive late, be resent, contain malformed rows, or represent corrections. Analysts expect a daily dataset with a visible completeness status.

## Work

1. Define the file naming, batch ID, schema version, and expected-delivery manifest.
2. Choose `COPY INTO`, Snowpipe, or another pattern based on a stated freshness target.
3. Define stage, file format, and external-storage trust boundary.
4. Record load history, rejected rows/files, and source/target row counts.
5. Specify duplicate, renamed-file, correction, and replay behavior.
6. Design quarantine and alerting for malformed input.
7. Transform raw values into typed curated columns and validate grain.
8. Define the process for source schema changes and late-arriving records.
9. Document how a failed batch is recovered and reconciled.

## Deliverables

- `architecture.md` with the flow and selected pattern
- sample manifest and fictional file contract
- illustrative SQL for file format, stage, load, and validation
- failure/replay matrix
- monitoring fields and alert ownership

## Acceptance Criteria

- A retry has a deterministic effect on the target.
- Expected input can be reconciled with loaded and rejected data.
- No malformed data is silently discarded.
- The selected ingestion pattern is justified by latency, volume, and operations.
- External access uses a managed trust design rather than committed credentials.

## Cost and Safety

The project can be design-only. Do not create real cloud storage credentials or put secrets in SQL files. If executing, use synthetic files and a disposable stage and schema.