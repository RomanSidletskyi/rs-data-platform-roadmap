# Reference Architecture Patterns

## Why This Topic Matters

Learners become much stronger when they stop seeing Spark as a list of features and start seeing recurring system patterns.

Reference patterns help connect Spark decisions to platform shape.

## Pattern 1: Batch Lakehouse Builder

Flow:

- raw files land in object storage
- Spark runs on bounded windows
- silver and gold outputs are written for analytics

Strong when:

- daily or hourly publication is acceptable
- replay and controlled rebuilds matter

Architectural idea:

- Spark acts as a bounded transformation engine over durable landed inputs
- the platform values repeatability and recovery more than constant freshness

## Pattern 2: Kafka To Curated Lakehouse

Flow:

- Kafka receives events or CDC
- Spark Structured Streaming builds bronze outputs
- downstream Spark jobs publish conformed and curated layers

Strong when:

- the platform needs continuous ingestion with recoverable analytical outputs

Architectural idea:

- Spark sits between operational event flow and durable analytical storage
- bronze, silver, and gold responsibilities are kept explicit

## Pattern 3: Hybrid Serving Platform

Flow:

- Spark produces reusable curated datasets
- warehouse and BI tools consume stable outputs
- selected operational or near-real-time views are updated more frequently

Strong when:

- different consumers need different latency and interaction models

Architectural idea:

- one platform can support both stable curated outputs and faster operational-facing views without forcing every consumer into the same latency model

## Pattern 4: Historical Rebuild Engine

Flow:

- raw or bronze history is preserved
- Spark performs replay and backfill for corrected logic or restatements

Strong when:

- the organization must recover cleanly from logic bugs or late data corrections

Architectural idea:

- Spark's value here is not only transformation scale but replay discipline and recoverability

## Real Pattern Fragments

Batch lakehouse builder:

```python
daily_orders = spark.read.parquet("/lake/bronze/orders").filter("event_date = '2026-03-24'")
```

Kafka to curated lakehouse:

```python
stream = spark.readStream.format("kafka").option("subscribe", "orders.events").load()
```

Historical rebuild engine:

```python
rebuild_window = spark.read.parquet("/lake/bronze/orders").filter("event_date BETWEEN '2026-03-01' AND '2026-03-07'")
```

These fragments are intentionally small.

They help the learner see that each architecture pattern starts from a different processing shape even before the business logic grows.

## What These Patterns Usually Clarify

Reference patterns help answer:

- where Spark should sit in the platform
- which layers own raw normalization versus consumer semantics
- whether replay is first-class or improvised
- whether latency expectations match the system design

## What These Patterns Teach

These patterns show that Spark's main value is often not in one isolated job.

Its value appears when it supports:

- transformation reuse
- replayability
- scalable modeling
- clear platform layering

They also teach that a healthy Spark platform is usually built around a few repeatable shapes rather than a growing pile of unrelated jobs.

## Common Mistake

The mistake is not choosing the wrong pattern once.

The bigger mistake is building Spark systems without any pattern awareness at all.

Another common mistake is copying a pattern without understanding its assumptions.

For example, a Kafka-to-curated-lakehouse pattern is not automatically healthy if the team has no replay plan, weak schema control, or unclear gold-layer ownership.

## How To Use These Patterns Well

- choose the pattern that matches business latency and recovery needs
- adapt the pattern to the platform's real ownership model
- avoid mixing patterns carelessly in one output path without explicit reasoning

## Key Architectural Takeaway

Reference patterns help architects place Spark intentionally inside the data platform rather than growing the platform from disconnected jobs.