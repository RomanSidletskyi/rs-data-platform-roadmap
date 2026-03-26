# Architecture Review Exercises

Use these exercises to practice architectural judgment rather than only reading concepts.

For each exercise:

1. summarize the system in plain language
2. choose the most relevant checklist from this directory
3. list the 3 highest-risk weaknesses
4. propose one simpler alternative
5. write one short ADR title that captures the main decision

## Exercise 1: Daily Finance Pipeline With No Raw Layer

### Scenario

A finance team loads sales data once per night directly into a reporting table.

The transformation job overwrites the previous data each run, and no raw landing is preserved.

### What To Review

- recovery after transformation bugs
- auditability
- backfill strategy
- whether one table is doing too many responsibilities

### Expected Findings

- raw preservation is missing
- recovery and replay are weak
- the serving table is acting as both transformation output and source-of-truth copy

## Exercise 2: Kafka Introduced For Hourly CRM Sync

### Scenario

A team replaces an hourly CRM batch sync with Kafka even though there is one producer, one consumer, and no low-latency user need.

### What To Review

- whether streaming complexity is justified
- replay value versus scheduled extraction simplicity
- real business latency requirement

### Expected Findings

- the design may be overbuilt for the need
- batch likely remains the stronger default
- operational cost exceeds demonstrated business value

## Exercise 3: Bronze Tables Queried Directly By Dashboards

### Scenario

Power BI dashboards query bronze tables directly because curated marts are not ready yet.

The dashboard authors also redefine KPI logic inside the BI tool.

### What To Review

- serving-layer boundaries
- semantic consistency
- consumer safety

### Expected Findings

- unstable technical data is exposed directly to business users
- metric drift is likely
- curated or semantic serving layers are missing or bypassed

## Exercise 4: Shared Sensitive Mart With Broad Team Access

### Scenario

A curated finance mart contains payroll-adjacent data, but access is granted to a wide analytics group because permission management is slow.

### What To Review

- least privilege
- ownership and approval boundaries
- auditability

### Expected Findings

- convenience has replaced access design
- blast radius is too large
- explicit owner-driven access review is needed

## Exercise 5: Streaming Pipeline Retries Forever On Bad Records

### Scenario

A streaming consumer retries failed records indefinitely, causing lag to grow for the whole topic whenever a poison message appears.

### What To Review

- permanent versus transient failure handling
- DLQ or quarantine design
- operational recovery behavior

### Expected Findings

- bad-record isolation is missing
- reliability design is overly optimistic
- throughput is hostage to one error class

## Exercise 6: Startup Uses Spark For Small Local Jobs

### Scenario

A small team with modest data volume builds every transformation in Spark because they expect future scale.

Most jobs run on small datasets and could fit on one machine comfortably.

### What To Review

- whether distributed compute is justified
- cost versus future-proofing
- simpler alternatives

### Expected Findings

- platform complexity is ahead of actual need
- local processing could likely satisfy the current workload
- the architecture is optimizing for imagined scale instead of present constraints

## Exercise 7: One Airflow DAG Owns Every Domain Pipeline

### Scenario

A central team has one very large Airflow DAG that orchestrates ingestion, transformation, and publishing for several business domains.

Every new dependency is added into the same DAG because it is easier to keep "everything in one place".

### What To Review

- ownership boundaries
- blast radius during failure
- whether workflow organization mirrors domain responsibilities

### Expected Findings

- one orchestration object is becoming a shared failure domain
- domain boundaries are weak
- central visibility is being achieved by over-centralizing execution logic

## Exercise 8: CDC Events Used Directly As Analytics Tables

### Scenario

Teams consume raw CDC topics directly for dashboards and self-service analysis.

Deletes, updates, and schema changes are handled differently by each downstream consumer.

### What To Review

- separation between transport and business-serving layers
- consistency of update semantics
- consumer safety

### Expected Findings

- raw change transport is being confused with curated analytical truth
- downstream consumers are re-implementing semantics inconsistently
- a modeled consolidation layer is missing

## Exercise 9: Every Domain Defines Revenue Differently

### Scenario

Sales, finance, and product dashboards all publish a "revenue" metric, but each team computes it differently based on local assumptions.

Leadership receives conflicting numbers in executive meetings.

### What To Review

- semantic consistency
- KPI ownership
- whether a shared serving model exists

### Expected Findings

- there is no governed semantic definition for a core KPI
- domain autonomy has exceeded semantic guardrails
- a shared semantic or curated metric layer is needed

## Exercise 10: Silver Layer Bug Was Discovered After Three Days

### Scenario

A logic bug in silver transformations silently corrupted gold outputs for three days before anyone noticed.

The team is unsure how to identify affected tables and rebuild safely.

### What To Review

- replay and rebuild strategy
- lineage and impact analysis
- data quality detection speed

### Expected Findings

- quality detection came too late
- repair path and lineage visibility are weak
- layer separation exists, but operational recovery is underdesigned

## Exercise 11: Real-Time Feature Store For Weekly Model Refresh

### Scenario

A team proposes a low-latency online feature store even though model training happens weekly and inference is performed in overnight batch scoring.

### What To Review

- whether low-latency serving is justified
- simpler alternatives
- cost versus real ML delivery need

### Expected Findings

- the online serving path may be unjustified
- a batch-oriented feature pipeline could likely satisfy the requirement
- platform design is being led by fashionable architecture rather than usage pattern

## Exercise 12: Shared Landing Bucket For Dev, Test, And Prod

### Scenario

To reduce setup effort, the team stores development, test, and production raw files in the same landing bucket with folder prefixes.

Access controls are broad because separation by environment is considered inconvenient.

### What To Review

- environment isolation
- access and publish controls
- incident blast radius

### Expected Findings

- trust boundaries are weak
- accidental cross-environment contamination risk is high
- storage convenience is overriding governance and operational safety

## Exercise 13: Gold Tables Rebuilt Hourly Even Though Dashboards Refresh Daily

### Scenario

Curated marts are rebuilt every hour because the platform can do it, but all important dashboards refresh once per day and users check them mainly in the morning.

### What To Review

- refresh cadence versus actual business use
- compute and storage cost drivers
- whether freshness promises are realistic or unnecessary

### Expected Findings

- refresh cost is ahead of user value
- the platform is paying for latency that the business does not consume
- cadence should be aligned to decision cycles, not technical ability alone

## Exercise 14: Stream Processor Scales But Sink Cannot Keep Up

### Scenario

The team keeps adding compute to a streaming job, but end-to-end lag remains high because the downstream sink writes slowly and occasionally locks.

### What To Review

- real bottleneck identification
- sink idempotency and throughput
- scaling strategy

### Expected Findings

- scaling focused on the most visible component instead of the bottleneck
- sink behavior is limiting throughput and recovery
- compute scaling alone will not solve the system problem

## Read With

- `README.md`
- `reviewer-notes.md`
- `system-shape-review-checklist.md`
- `batch-pipeline-review-checklist.md`
- `streaming-platform-review-checklist.md`
- `lakehouse-serving-review-checklist.md`
- `governance-security-review-checklist.md`
- `reliability-cost-review-checklist.md`
- `../synthesis/README.md`