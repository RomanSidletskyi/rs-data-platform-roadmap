# dbt Model Contracts

## Scenario

A team uses dbt to build marts consumed by analysts and dashboards.

The upstream staging logic changes frequently, but downstream users expect stable semantics.

## Core Tension

Should dbt models be treated as flexible transformation outputs or as contract-bearing interfaces for analytics consumers?

## Trade-Offs

- flexible dbt evolution speeds internal change but can destabilize reporting semantics
- stronger model contracts improve trust but require more explicit testing, documentation, and naming discipline
- the right balance depends on which models are internal stepping stones and which are analyst-facing products

## Failure Modes

- a metric model changes grain without clear communication
- a renamed column breaks BI logic silently
- tests validate row shape but not business semantics

## Code-Backed Discussion Point

```sql
select
    customer_id,
    date_trunc('month', order_created_at) as order_month,
    sum(net_revenue) as monthly_revenue
from {{ ref('stg_orders') }}
group by 1, 2
```

The SQL can be correct.

The architecture question is whether `customer_id`, `order_month`, and `monthly_revenue` are now a stable contract or only an implementation detail of the current model.

## Decision Signal

Treat downstream-facing dbt models as contracts with explicit grain, semantics, and change rules.

## Review Questions

- which dbt models are internal stepping stones and which are consumer-facing contracts
- where can grain changes hide behind a seemingly small SQL edit
- what tests prove business semantics rather than only row shape
- what naming or documentation rules distinguish contract models from internal ones

## AI Prompt Pack

```text
Compare flexible dbt model evolution against stronger contract-oriented dbt rules for analyst-facing marts. Focus on grain stability, semantic drift, test design, and change management.
```

```text
Review this dbt contract proposal. Identify where analytics consumers could still be surprised even if technical tests pass.
```