# Serving Layer Contracts

## Scenario

Analytics users depend on curated tables or semantic datasets for dashboards and reporting.

Engineering teams want to evolve upstream processing without breaking trusted outputs.

## Core Tension

How stable should the serving layer be compared with upstream bronze and silver layers?

## Trade-Offs

- a rigid serving layer improves trust but slows change
- a flexible serving layer speeds delivery but increases dashboard fragility
- the right answer usually requires stronger boundaries at the serving interface than upstream transformation layers

## Failure Modes

- serving schemas changing without version or communication
- internal transformation refactors leaking into analyst-facing outputs
- semantic meaning drifting while column names stay the same

## Code-Backed Discussion Point

```sql
CREATE VIEW serving.customer_revenue AS
SELECT customer_id,
       month,
       net_revenue
FROM curated.customer_monthly_revenue
```

The SQL is small.

The architectural question is whether `customer_id`, `month`, and `net_revenue` are treated as stable consumer contracts or just current implementation details.

## Decision Signal

Serving layers should behave like product interfaces, not just convenient query outputs.

## Review Questions

- which serving fields are true consumer contracts
- what changes should require versioning or communication
- how much upstream flexibility can exist without destabilizing the serving layer
- what semantic drift could happen even if column names stay the same

## AI Prompt Pack

```text
Design serving-layer contract rules for a data platform where upstream curated logic evolves often but BI consumers need stable outputs. Focus on versioning, semantic stability, and change communication.
```

```text
Review this serving-layer design and identify where analyst-facing contracts are still treated like internal implementation details.
```