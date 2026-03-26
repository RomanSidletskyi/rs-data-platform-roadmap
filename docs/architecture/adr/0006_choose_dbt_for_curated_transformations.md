# ADR 0006: Choose dbt For Curated Transformations

## Status

Accepted

## Context

Curated analytical models need repeatable SQL structure, lineage, testing, and shared ownership across several transformations.

## Decision

Use dbt for curated transformation layers when business models are becoming a maintained platform layer rather than a few ad hoc scripts.

## Consequences

Benefits:

- stronger model structure
- tests and documentation
- clearer lineage for shared analytical logic

Drawbacks:

- more framework overhead
- unnecessary for very small workloads