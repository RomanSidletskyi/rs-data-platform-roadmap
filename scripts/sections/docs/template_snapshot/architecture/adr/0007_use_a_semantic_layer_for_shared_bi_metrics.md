# ADR 0007: Use A Semantic Layer For Shared BI Metrics

## Status

Accepted

## Context

Several dashboards and teams depend on the same KPIs, but metric definitions drift when every report implements its own logic.

## Decision

Use a semantic layer or an equivalent governed serving model for shared BI metrics.

## Consequences

Benefits:

- more consistent KPI definitions
- better reuse across dashboards
- cleaner separation between storage and business meaning

Drawbacks:

- additional modeling layer to own
- requires stronger governance discipline