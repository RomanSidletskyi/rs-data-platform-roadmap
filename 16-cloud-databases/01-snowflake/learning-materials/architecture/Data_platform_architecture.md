# Data Platform Architecture — System Design (Senior Cheat Sheet)

## 1. Problem Statement

Design a data platform handling:

- 1B–5B events per day
- near-real-time + batch analytics
- multiple consumers (BI, ML, product)
- replay and backfills
- schema evolution

---

## 2. High-Level Architecture

Standard scalable design:

    Apps / Services
          ↓
        Kafka
          ↓
    ┌───────────────┐
    ↓               ↓
  S3 Raw        Snowflake (optional direct)
    ↓
Snowpipe / COPY
    ↓
Snowflake Raw Layer
    ↓
dbt (staging → intermediate → marts)
    ↓
BI / ML / APIs

---

## 3. Key Design Principles

### 1. Separation of concerns
- transport → Kafka
- storage → S3
- compute → Snowflake
- transform → dbt

### 2. Immutable raw layer
- never mutate raw
- supports replay
- supports debugging

### 3. Replayability
- Kafka → short-term replay
- S3 → long-term replay

### 4. Cost vs latency trade-off
- streaming = low latency, high cost
- micro-batching = balanced

### 5. Observability first
- ingestion must be debuggable
- no silent failures

---

## 4. Ingestion Layer Design

### Option A — Kafka + S3 + Snowflake (recommended default)

    Apps → Kafka → S3 → Snowflake

Pros:
- replayable
- cheaper storage
- decoupled
- scalable

Cons:
- slightly higher latency

### Option B — Kafka → Snowflake directly

    Apps → Kafka → Snowflake

Pros:
- lower latency
- simpler pipeline

Cons:
- weaker replay
- tighter coupling

### Decision rule

- Need replay → use S3
- Need ultra-low latency → direct ingest

---

## 5. Data Layout (S3)

Example:

    s3://company-raw/events/
      domain=orders/dt=2026-03-20/hour=10/file.parquet
      domain=users/dt=2026-03-20/hour=10/file.parquet

Best practices:
- partition by date/time
- domain-based prefixes
- immutable files
- avoid random folder structures

---

## 6. Raw Layer Design (Snowflake)

Example table:

    raw_events (
        event_id STRING,
        user_id STRING,
        event_ts TIMESTAMP,
        payload VARIANT,
        src_filename STRING,
        ingestion_time TIMESTAMP
    )

Key rules:
- minimal transformations
- keep metadata columns
- store raw truth

---

## 7. Handling 1B–5B Events/Day

### Key challenges

- ingestion throughput
- cost explosion
- skew
- query performance
- backfills

### Solutions

#### 1. Micro-batching
- group events into files
- 100–250MB per file

#### 2. Partitioning by time
- enables pruning
- improves clustering

#### 3. Domain separation
- separate tables per event type
- reduces scan size

#### 4. Incremental processing
- dbt incremental models
- avoid full refresh

---

## 8. Micro-batching vs Streaming

### Micro-batching

Pros:
- cheaper
- better micro-partitions
- easier replay
- stable pipelines

Cons:
- slightly higher latency

### Streaming (over-streaming)

Pros:
- low latency

Cons:
- expensive
- poor partitioning
- hard debugging
- hard replay

### Senior insight

Streaming optimizes latency  
Micro-batching optimizes cost and reliability

---

## 9. Replay Strategy

Must-have for large-scale systems.

### Kafka
- short-term replay

### S3
- long-term replay

### Snowflake
- controlled reprocessing

Example:

    COPY INTO raw_events
    FROM @stage/events/dt=2026-03-20/
    FORCE = TRUE;

---

## 10. Transformation Layer (dbt)

Layers:

- staging → cleaning
- intermediate → business logic
- marts → consumption

Example:

    raw_events → stg_events → int_sessions → fct_sessions

---

## 11. Real-time vs Batch Layer

### Near-real-time

- raw + lightweight models
- latency: 1–5 min

### Batch

- heavy joins
- aggregations
- latency: hourly/daily

### Key rule

Do not mix heavy logic with real-time workloads

---

## 12. Data Quality Strategy

Must include:

- ingestion audit
- row count checks
- duplicate detection
- freshness checks
- schema validation

---

## 13. Schema Drift Handling

### Additive changes
- safe
- handle with MATCH_BY_COLUMN_NAME

### Breaking changes
- type changes
- renamed columns

Strategy:
- VARIANT landing
- quarantine
- schema versioning

---

## 14. Cost Optimization

Key levers:

- micro-batching
- incremental models
- selective clustering
- avoid over-streaming
- separate warehouses

---

## 15. Orchestration

### Kafka
- streaming transport

### Airflow / Dagster
- batch orchestration
- dbt triggers
- monitoring

### Important

Airflow ≠ streaming engine

---

## 16. Monitoring

Track:

- ingestion failures
- Kafka lag
- Snowpipe status
- query performance
- warehouse usage

---

## 17. Common Bottlenecks

- small files
- skewed joins
- bad clustering
- full table scans
- expensive merges

---

## 18. Anti-patterns

- real-time everything
- no raw layer
- no replay strategy
- ignoring cost
- overuse of streaming

---

## 19. Strong Interview Answer

> I would design the platform using Kafka for event transport, S3 as immutable raw storage, Snowflake for analytics, and dbt for transformations. I would separate near-real-time and batch workloads, ensure replayability through S3, and optimize cost using micro-batching. I would also design for schema drift, monitoring, and data quality from day one.

---

## 20. One-line Summary

Scalable data platform = decoupled ingestion + immutable storage + optimized transformations + strong observability