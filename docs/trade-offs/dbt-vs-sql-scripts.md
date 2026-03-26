# dbt Vs SQL Scripts

## Decision

Choose between a transformation framework and plain SQL-script orchestration.

## Context

This decision appears when curated analytical modeling grows beyond a few ad hoc transformations.

## Decision Criteria

- transformation scale
- lineage and documentation needs
- testing discipline
- team workflow maturity

## Option A

### Benefits

- stronger structure for models, tests, and documentation
- good fit for governed analytical transformation layers
- clearer lineage and modular SQL model organization

### Drawbacks

- extra framework overhead
- can be unnecessary for tiny or short-lived workloads

## Option B

### Benefits

- minimal tooling overhead
- flexible for small and simple tasks
- easy to start quickly

### Drawbacks

- weaker standardization as model count grows
- tests, lineage, and documentation often become inconsistent

## Recommendation

Choose dbt when analytical modeling is a real layer with shared ownership, lineage, testing, and repeatable business logic.

Choose simple SQL scripts when the workload is small enough that framework overhead would dominate the value.

## Revisit Trigger

Revisit when model count, team count, or governance expectations grow beyond what loose scripts can support cleanly.