# Project 03: Production Snowflake Platform

## Goal

Produce and defend a platform architecture for multiple environments and data domains. This is a design capstone; an account is not required.

## Scenario

A growing organization has development and production workloads, two data domains, batch and near-real-time sources, BI consumers, regulated fields, a small platform team, and a stated recovery objective. You must propose a Snowflake-centered platform that can evolve without overbuilding.

## Work

1. Write explicit functional and non-functional requirements, including freshness, availability, recovery, residency, and cost.
2. Compare account topologies and select environment/domain boundaries.
3. Draw source, ingestion, raw, transformation, curated, and serving flows.
4. Assign ownership for Snowflake, dbt, Airflow, Kafka, and external cloud services.
5. Design role hierarchy, sensitive-data controls, and consumer interfaces.
6. Allocate workloads to warehouses or serverless capabilities with cost attribution.
7. Select recovery mechanisms and define RPO/RTO validation.
8. Define CI/CD, schema promotion, tests, secrets, monitoring, and incident ownership.
9. Compare at least two alternatives and record decisions as short ADRs.
10. Identify the first two simplifications you would make for an initial launch.

## Deliverables

- completed `architecture.md`
- a platform diagram
- account/object/role boundary table
- decision log with trade-offs
- failure-mode and recovery table
- phased implementation plan and operating checklist

## Acceptance Criteria

- Requirements lead to the design; features are not included without a reason.
- Snowflake and surrounding tools have clear responsibility boundaries.
- Security, cost, freshness, and recovery are addressed together.
- The proposal distinguishes current needs from future extensions.
- Trade-offs and assumptions are explicit enough for a design review.