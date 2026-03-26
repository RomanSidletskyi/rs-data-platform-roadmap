# Structured Streaming Foundations

## Why This Topic Matters

When teams first meet Spark streaming, they often imagine a completely different system from Spark batch.

The stronger mental model is that Spark Structured Streaming lets you express continuous processing through a model that stays close to the DataFrame and SQL style.

This matters because it reduces conceptual fragmentation between batch and streaming work.

## What Structured Streaming Gives You

Structured Streaming helps teams:

- read unbounded inputs like Kafka topics
- express transformations in familiar DataFrame or SQL form
- publish outputs incrementally
- reason about progress through checkpoints and controlled state

It is not magic real-time intelligence.

It is a framework for incremental distributed processing.

That distinction matters because teams often expect streaming systems to solve latency, correctness, and operational recovery all at once.

## Why This Matters In Data Platforms

Spark Structured Streaming becomes useful when the platform needs something between raw event ingestion and final consumer outputs.

Examples:

- parse raw Kafka events into structured bronze data
- maintain sessionized or aggregated near-real-time views
- enrich live events with reference data
- publish incremental curated layers to lakehouse storage

In many platforms, this makes Structured Streaming the place where operational event flow first becomes analytically usable.

## Real Example

Suppose order events arrive through Kafka.

Structured Streaming can help:

- read those events continuously
- parse schema and reject invalid records
- attach processing metadata
- write partitioned outputs for downstream batch or BI layers

That is already a full architectural role, not just a demo.

Another realistic example:

- payment events arrive continuously
- a near-real-time risk feature layer must stay current within minutes
- Spark Structured Streaming enriches the events and writes a conformed intermediate dataset
- downstream bounded jobs still publish more stable curated summaries

That is a healthy hybrid use of streaming rather than an attempt to make every consumer read directly from raw events.

## Real Structured Streaming Example

```python
from pyspark.sql import functions as F

raw_orders = (
	spark.readStream
	.format("kafka")
	.option("kafka.bootstrap.servers", "broker:9092")
	.option("subscribe", "orders.events")
	.load()
)

parsed_orders = (
	raw_orders
	.selectExpr("CAST(value AS STRING) AS payload", "timestamp AS kafka_timestamp")
	.withColumn("ingested_at", F.current_timestamp())
)
```

This snippet already shows the essential streaming shape:

- read continuously from Kafka
- parse the payload into a structured form
- attach processing metadata for downstream traceability

## Longer Bronze-Layer Example

```python
from pyspark.sql import functions as F

orders_stream = (
	spark.readStream
	.format("kafka")
	.option("kafka.bootstrap.servers", "broker:9092")
	.option("subscribe", "orders.events")
	.load()
)

bronze_orders = (
	orders_stream
	.selectExpr(
		"CAST(key AS STRING) AS event_key",
		"CAST(value AS STRING) AS payload",
		"timestamp AS kafka_timestamp"
	)
	.withColumn("ingested_at", F.current_timestamp())
	.withColumn("event_date", F.to_date("kafka_timestamp"))
)

(bronze_orders.writeStream
	.format("parquet")
	.option("checkpointLocation", "/lake/checkpoints/bronze_orders")
	.option("path", "/lake/bronze/orders")
	.partitionBy("event_date")
	.start()
)
```

## Why This Example Is Closer To Production

- it keeps the first streaming layer source-near instead of trying to do all business logic immediately
- it persists raw payload and processing metadata for replay and debugging
- it uses a checkpoint because restart correctness is part of the design, not an afterthought
- it partitions the landed data by `event_date` so downstream bounded reads stay practical

## What To Review In Code Like This

1. Should the first streaming job land bronze only, or also parse into silver immediately?
2. Is the checkpoint location durable and isolated enough for reliable restart?
3. Does the chosen partition key support downstream reads and replays?
4. Are we storing enough source-near evidence to debug malformed or duplicated events later?

## What Structured Streaming Does Not Automatically Solve

It does not remove the need to think about:

- late data
- duplicates
- state growth
- downstream correctness windows
- replay design

This is where beginners often overestimate streaming frameworks.

## What Makes Streaming Operationally Harder Than Batch

Compared with bounded batch jobs, long-running streaming systems must deal with:

- checkpoint health over time
- state growth and cleanup
- restart behavior after partial failure
- clearer decisions about what counts as final enough output

This is why a streaming choice should be justified by business need, not by fashion.

## Common Mistakes

### Mistake 1: Thinking Streaming Means Every Output Must Be Immediate

Some outputs should stay bounded and published in controlled windows.

### Mistake 2: Treating Streaming As Just Batch That Runs Forever

The APIs may look similar, but operational behavior is different because state and continuity matter.

### Mistake 3: Ignoring Checkpoint And Recovery Design

Streaming without operational recovery thinking is incomplete architecture.

### Mistake 4: Treating Every Consumer As If It Needed Raw Streaming Output

Often a streaming intermediate layer is useful, while final consumer-facing outputs still benefit from bounded publication.

## Good Strategy

- use Structured Streaming when continuous incremental processing solves a real latency problem
- keep business semantics explicit even in long-running pipelines
- design for state, checkpoints, and recovery from the start
- separate source-near incremental layers from consumer-facing contract layers when that improves trust and operability

## Key Architectural Takeaway

Structured Streaming is strongest when it is treated as a disciplined incremental-processing layer inside a broader platform, not as a universal answer to every data problem.