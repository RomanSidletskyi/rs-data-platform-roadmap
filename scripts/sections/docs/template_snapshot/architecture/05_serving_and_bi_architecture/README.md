# Serving and BI Architecture

## What This Topic Is For

Serving and BI architecture is about turning transformed data into trusted, understandable, and performant business consumption layers.

This is the point where architecture must care about business meaning, not only data movement.

## Typical Architecture

    Curated Data -> Semantic Layer -> BI Tool -> Dashboards / Reports

## When This Architecture Is A Strong Fit

- reporting
- dashboards
- self-service analytics
- KPI delivery
- executive or operational decision-making based on curated metrics

## When It Is A Weak Fit

- raw exploratory ingestion
- low-level source archival
- unmodeled event streams or technical landing zones

## What To Pay Attention To

- whether business users see stable definitions instead of raw technical fields
- whether fact and dimension design matches analytical questions
- whether semantic models isolate BI from raw storage complexity
- whether freshness and query performance are realistic for the audience

## Good Architecture Signals

- business definitions are explicit and reusable
- dashboards do not depend directly on raw ingestion tables
- metrics are governed centrally enough to avoid many conflicting definitions
- serving models match usage patterns instead of mirroring raw storage layout

## Common Mistakes

- letting BI tools query raw bronze or source tables directly
- building dashboards on unstable intermediate layers
- mixing operational truth and reporting truth carelessly
- optimizing table shape for loaders instead of consumers

## Real Examples To Think Through

- gold fact tables feeding Power BI semantic models
- finance marts separated from raw operational data
- operational KPI dashboards built on curated near-real-time aggregates

Worked example:

- `worked_example_executive_kpi_serving.md`

## Interview Questions

- Why should Power BI not read raw data directly?
- What is a semantic layer?
- What is the difference between fact and dimension tables?
- Why use data marts?

## Read Next

- `resources.md`
- `anti-patterns.md`
- `worked_example_executive_kpi_serving.md`
- `../../case-studies/README.md`
- `../../trade-offs/README.md`

## Completion Checklist

- [ ] I understand the purpose of semantic models
- [ ] I understand fact vs dimension tables
- [ ] I understand why curated layers exist
