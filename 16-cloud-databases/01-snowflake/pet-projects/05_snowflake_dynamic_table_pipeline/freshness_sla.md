# Freshness SLA Notes

Use this file to propose different latency classes.

Suggested classes:

- operational visibility: 5 minutes
- product analytics: 15 to 30 minutes
- finance reconciliation: hourly or daily

Why lag is a cost decision: the upper bound on scheduled refreshes per day grows quickly as lag shrinks (illustrative arithmetic; real cost depends on changed data, refresh mode, and warehouse size).

```mermaid
xychart-beta
    title "Max refreshes per day by target lag"
    x-axis ["5 min", "15 min", "30 min", "60 min", "24 h"]
    y-axis "Refreshes per day" 0 --> 300
    bar [288, 96, 48, 24, 1]
```

Questions to answer:

- which stakeholders actually need freshness, and which only say they do?
- which models are narrow enough to justify low lag?
- which models are too heavy for low-lag dynamic maintenance?

Rule:

- every lag choice should map to a consumer need and a cost trade-off.

A thinking aid for the questions above. The placements are illustrative only; move them based on your own consumers and model sizes.

```mermaid
quadrantChart
    title Freshness need vs model weight - illustrative
    x-axis Narrow model --> Heavy model
    y-axis Relaxed need --> Tight need
    quadrant-1 Redesign or push back
    quadrant-2 Low-lag dynamic table candidate
    quadrant-3 Cheap but question the value
    quadrant-4 Batch or relaxed lag
    Operational visibility: [0.2, 0.9]
    Product analytics: [0.45, 0.55]
    Finance reconciliation: [0.8, 0.15]
```