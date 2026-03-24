# Reviewer Notes For Architecture Review Exercises

Use this file as the answer key for `review-exercises.md`.

It does not provide the only valid answer.

It gives the strongest expected review direction for each exercise.

## Exercise 1: Daily Finance Pipeline With No Raw Layer

- Best checklist: `batch-pipeline-review-checklist.md`
- Core finding: raw preservation and replay are missing
- Simpler alternative: still batch, but with raw landing plus curated serving
- Good ADR title: `Store Raw Finance Input Before Reporting Transformations`

## Exercise 2: Kafka Introduced For Hourly CRM Sync

- Best checklist: `streaming-platform-review-checklist.md`
- Core finding: streaming complexity is weakly justified
- Simpler alternative: incremental batch extraction
- Good ADR title: `Choose Batch For Scheduled CRM Synchronization`

## Exercise 3: Bronze Tables Queried Directly By Dashboards

- Best checklist: `lakehouse-serving-review-checklist.md`
- Core finding: serving boundaries and KPI governance are broken
- Simpler alternative: curated gold marts plus semantic layer
- Good ADR title: `Serve Dashboards From Curated Semantic Models`

## Exercise 4: Shared Sensitive Mart With Broad Team Access

- Best checklist: `governance-security-review-checklist.md`
- Core finding: convenience has replaced least privilege
- Simpler alternative: owner-approved role model with narrower access groups
- Good ADR title: `Enforce Least Privilege For Sensitive Analytical Marts`

## Exercise 5: Streaming Pipeline Retries Forever On Bad Records

- Best checklist: `reliability-cost-review-checklist.md`
- Core finding: permanent-failure isolation is missing
- Simpler alternative: bounded retries plus DLQ or quarantine path
- Good ADR title: `Isolate Poison Records Instead Of Infinite Retry`

## Exercise 6: Startup Uses Spark For Small Local Jobs

- Best checklist: `reliability-cost-review-checklist.md`
- Core finding: distributed compute is unjustified for current need
- Simpler alternative: local Python or pandas pipelines
- Good ADR title: `Prefer Local Processing Until Data Scale Requires Distribution`

## Exercise 7: One Airflow DAG Owns Every Domain Pipeline

- Best checklist: `system-shape-review-checklist.md`
- Core finding: orchestration shape is collapsing domain boundaries
- Simpler alternative: smaller DAGs aligned to domain or bounded workflow ownership
- Good ADR title: `Separate Workflow Orchestration By Domain Boundary`

## Exercise 8: CDC Events Used Directly As Analytics Tables

- Best checklist: `streaming-platform-review-checklist.md`
- Core finding: change transport is being mistaken for curated analytical truth
- Simpler alternative: raw CDC landing plus consolidation modeling layer
- Good ADR title: `Model CDC Events Into Curated Analytical Tables`

## Exercise 9: Every Domain Defines Revenue Differently

- Best checklist: `lakehouse-serving-review-checklist.md`
- Core finding: a governed semantic definition for a core KPI is missing
- Simpler alternative: one shared curated metric definition reused by domains
- Good ADR title: `Use A Shared Semantic Definition For Revenue`

## Exercise 10: Silver Layer Bug Was Discovered After Three Days

- Best checklist: `reliability-cost-review-checklist.md`
- Core finding: detection and rebuild capabilities are weaker than the layer model suggests
- Simpler alternative: stronger quality gates, lineage, and controlled rebuild process
- Good ADR title: `Introduce Impact-Aware Rebuild And Quality Gates For Curated Layers`

## Exercise 11: Real-Time Feature Store For Weekly Model Refresh

- Best checklist: `system-shape-review-checklist.md`
- Core finding: low-latency feature serving is not justified by usage pattern
- Simpler alternative: batch feature generation and offline serving only
- Good ADR title: `Prefer Batch Feature Pipelines For Weekly Model Refresh`

## Exercise 12: Shared Landing Bucket For Dev, Test, And Prod

- Best checklist: `governance-security-review-checklist.md`
- Core finding: environment isolation is too weak for safe operation
- Simpler alternative: physically separate environment storage and narrower access policies
- Good ADR title: `Separate Raw Storage By Environment Boundary`

## Exercise 13: Gold Tables Rebuilt Hourly Even Though Dashboards Refresh Daily

- Best checklist: `batch-pipeline-review-checklist.md`
- Core finding: refresh cadence is driven by capability, not business value
- Simpler alternative: schedule curated rebuilds to match real dashboard usage
- Good ADR title: `Align Curated Refresh Cadence With Business Consumption`

## Exercise 14: Stream Processor Scales But Sink Cannot Keep Up

- Best checklist: `reliability-cost-review-checklist.md`
- Core finding: the sink is the bottleneck, not compute
- Simpler alternative: redesign sink throughput, buffering, or write pattern before scaling compute further
- Good ADR title: `Optimize Sink Throughput Before Scaling Stream Compute`

## How To Judge A Good Review Answer

- it identifies the real pressure behind the design
- it distinguishes tool choice from system-shape choice
- it proposes a simpler alternative before adding complexity
- it surfaces one main accepted trade-off clearly