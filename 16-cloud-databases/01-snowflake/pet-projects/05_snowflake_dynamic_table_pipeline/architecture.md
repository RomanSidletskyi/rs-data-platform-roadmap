# Architecture - 05 Snowflake Dynamic Table Pipeline

## Components

- native raw Snowflake ingestion tables
- dynamic staging layer
- dynamic intermediate layer
- serving mart layer
- warehouse and cost boundaries
- validation and operational controls

## Target Project Shape

The intended implementation should include:

- one clear source model
- one freshness classification by layer
- dynamic table definitions for the layers where declarative refresh is justified
- one explanation of when tasks or dbt should take over

Project milestones (from the README plan):

```mermaid
flowchart LR
    S1["Step 1<br/>read the brief"] --> S2["Step 2<br/>layers and consumers"]
    S2 --> S3["Step 3<br/>lag and warehouse per layer"]
    S3 --> S4["Step 4<br/>dynamic table definitions"]
    S4 --> S5["Step 5<br/>where tasks or dbt win"]
    S5 --> S6["Step 6<br/>validation and cost checks"]
```

## Data Flow

1. raw operational data lands in native tables
2. dynamic staging tables standardize and deduplicate near-ingestion data
3. dynamic intermediate tables compute reusable metrics
4. serving marts expose freshness-appropriate outputs
5. heavy historical or procedural logic stays outside the low-lag dynamic path

Example skeleton to adapt (the brief's flow; lag values are yours to set):

```mermaid
flowchart LR
    RAW["Native raw tables"] --> STG["Dynamic staging<br/>standardize and dedup<br/>lowest lag"]
    STG --> MID["Dynamic intermediate<br/>reusable metrics<br/>medium lag"]
    MID --> MART["Serving marts<br/>lag from consumer need"]
    RAW --> HEAVY["Heavy historical or<br/>procedural logic<br/>tasks or dbt"]
    HEAVY --> BATCH["Batch outputs"]
    MART --> CONS["Consumers"]
    BATCH --> CONS
    WH["Warehouses<br/>cost boundary per layer"] -. "refresh compute" .-> STG
    WH -.-> MID
    WH -.-> MART
```

## Modeling Rules

- low-lag layers should be narrow and operationally meaningful
- heavy transformations should not pretend to be real-time without a real consumer need
- target lag is part of the contract, not a decorative setting

## Trade-Offs

- dynamic tables reduce orchestration work for simple table pipelines
- lower lag increases compute pressure and operational sensitivity
- selective usage is stronger than making every transformation always-on

## What Would Change In Production

- stronger monitoring of actual lag and refresh failures
- warehouse auto-scaling and cost guardrails
- deeper CI and test integration around transformation changes
- explicit incident playbooks for suspending or resuming dynamic refresh

Example incident path to adapt into a playbook:

```mermaid
sequenceDiagram
    participant DT as StagingDT
    participant DS as DownstreamDTs
    participant MON as Monitoring
    participant OPS as OnCall
    DT->>DT: refresh fails after an upstream schema change
    DT-->>DS: downstream data cannot advance past staging
    MON->>MON: refresh history shows lag above target
    MON->>OPS: alert with table, error, and current lag
    OPS->>DT: ALTER DYNAMIC TABLE SUSPEND if failures keep spending credits
    OPS->>DT: fix definition or source, then RESUME
    DT->>DS: refreshes catch up, lag returns under target
```