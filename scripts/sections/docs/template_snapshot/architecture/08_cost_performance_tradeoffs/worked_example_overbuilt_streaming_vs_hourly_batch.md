# Worked Example - Overbuilt Streaming Vs Hourly Batch

## Scenario

A team ingests partner data every 30 minutes.

The feed volume is modest, but the initial proposal is:

- Kafka
- stream processor
- low-latency serving layer
- continuous alerting stack

## Why This Needs Trade-Off Analysis

The business only needs hourly freshness for internal dashboards.

The proposed architecture may be technically impressive but economically weak.

## Simpler Alternative

    partner extract every 30 minutes
        -> raw landing
        -> hourly batch transform
        -> curated serving tables
        -> dashboards

## What Good Looks Like

- latency target matches business value
- compute cost is proportional to workload size
- operational burden stays understandable for the team
- replay and backfill are simpler than in a full streaming stack

## What Bad Looks Like

- streaming chosen because it sounds more modern
- continuous compute running for a low-frequency feed
- several components exist with no clear justification
- the architecture team optimizes theoretical future scale instead of current constraints

## Questions To Review

- what business action becomes better because of low latency
- what extra operational cost streaming introduces
- whether batch already satisfies freshness and reliability needs
- what the first true scaling signal would be before redesign is needed

## Key Takeaway

Cost and performance architecture is often about refusing unnecessary complexity, not only tuning the chosen stack harder.