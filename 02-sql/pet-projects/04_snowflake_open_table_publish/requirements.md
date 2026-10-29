# Requirements

## Functional Requirements

- external-table layer must support raw feed profiling
- native raw layer must preserve lineage and replay-friendly metadata
- curated publish layer must be queryable from Snowflake and intended for cross-engine use
- the final contract must support finance-style daily order reporting

## Non-Functional Requirements

- clear boundary between exploratory, operational, and publish layers
- schema changes at the publish layer must be reviewable
- publish logic should be explainable to both data engineers and downstream consumers
- design should avoid unnecessary duplication of the same curated dataset across engines

## Decision Questions

- why is the published dataset Iceberg instead of native?
- why are some source feeds external-table-first while others are native-ingestion-first?
- what would make you de-scope Iceberg and keep the whole design native to Snowflake?