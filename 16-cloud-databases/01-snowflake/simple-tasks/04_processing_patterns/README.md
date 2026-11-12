# Task Set 04: Processing Patterns

For each scenario, select among full rebuild, `MERGE`, streams and tasks, dynamic tables, dbt, and external orchestration. More than one design may be valid; state the constraints that drive your choice.

## Task 1: Small Daily Dimension

A 20,000-row dimension is rebuilt nightly from a complete source snapshot. Freshness within one day is acceptable.

## Task 2: Mutable Orders

Orders receive updates and deletes; consumers need a curated table within ten minutes and a retryable process.

## Task 3: Multi-System Workflow

A pipeline waits for files, loads Snowflake, calls an external API, and publishes a notification. Operators need one view of retries and run state.

## Task 4: Declarative SQL Models

Several SQL transformations form a DAG, need tests and lineage, and can tolerate a defined freshness lag.

## Task 5: Transaction Semantics

Explain why stream consumption and target writes should be coordinated, and what you would test after a task failure.