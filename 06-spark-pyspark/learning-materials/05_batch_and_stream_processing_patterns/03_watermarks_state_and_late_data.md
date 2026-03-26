# Watermarks, State, And Late Data

## Why This Topic Matters

Streaming pipelines become truly difficult when time and incompleteness enter the picture.

Late events, stateful aggregations, and windowed outputs force teams to answer a hard question:

- when is the result good enough to publish?

That is both a technical and a business question.

## What State Means In Practice

Some streaming jobs are stateless and simpler.

Others must remember prior records to compute results such as:

- sessions
- rolling counts
- deduplication windows
- event-time aggregations

That memory is state.

State is useful, but it is also where operational cost and correctness complexity grow.

This is why many streaming systems feel easy in demos and difficult in production: state forces the platform to remember and manage partial truth over time.

## Why Late Data Matters

In real systems, events do not always arrive in perfect order.

Reasons include:

- network delays
- retries
- upstream outages
- source-system timing issues

So a streaming architecture must decide how long it is willing to wait for late records.

That decision is rarely purely technical because different consumers tolerate lateness differently.

## Watermarks As A Business-Technical Boundary

A watermark is not merely a tuning option.

It expresses a decision about how much lateness the system will tolerate before finalizing certain computations.

This matters because the right value depends on:

- business freshness expectations
- observed lateness patterns
- cost of holding more state
- consequences of missing late records in the first published result

So a watermark is really a contract between system behavior and business expectations.

## Real Example

Suppose a clickstream session model groups by user activity windows.

If the platform expects occasional event delays of several minutes, a session result published too early may fragment sessions incorrectly.

If the platform waits too long, latency becomes unacceptable.

That is an architecture trade-off, not just a coding detail.

Another realistic example:

- payment authorization events are usually fast
- settlement-confirmation events can arrive much later
- a streaming status view that closes windows too early may produce misleading "final" outputs

This shows why event-time reality should shape the pipeline more than optimistic assumptions.

## Real Structured Streaming Example

```python
from pyspark.sql import functions as F

session_counts = (
	parsed_orders
	.withWatermark("event_time", "10 minutes")
	.groupBy(
		F.window("event_time", "5 minutes"),
		F.col("country_code")
	)
	.agg(F.count("*").alias("orders_cnt"))
)
```

How to read this code:

- `withWatermark(...)` encodes how much lateness the pipeline tolerates
- `window(...)` creates bounded event-time groups inside an unbounded stream
- the aggregation keeps state until Spark decides the window is old enough to finalize

## Longer Streaming Example

```python
from pyspark.sql import functions as F

orders_stream = (
	spark.readStream
	.format("kafka")
	.option("kafka.bootstrap.servers", "broker:9092")
	.option("subscribe", "orders.events")
	.load()
)

parsed_orders = (
	orders_stream
	.selectExpr("CAST(value AS STRING) AS payload")
	.select(
		F.get_json_object("payload", "$.order_id").alias("order_id"),
		F.get_json_object("payload", "$.country_code").alias("country_code"),
		F.to_timestamp(F.get_json_object("payload", "$.event_time")).alias("event_time"),
		F.get_json_object("payload", "$.event_type").alias("event_type"),
	)
	.filter(F.col("order_id").isNotNull())
)

windowed_orders = (
	parsed_orders
	.withWatermark("event_time", "10 minutes")
	.groupBy(
		F.window("event_time", "5 minutes", "1 minute"),
		F.col("country_code"),
		F.col("event_type"),
	)
	.agg(F.count("*").alias("events_cnt"))
)

(windowed_orders.writeStream
	.format("parquet")
	.outputMode("append")
	.option("checkpointLocation", "/lake/checkpoints/orders_windowed")
	.option("path", "/lake/gold/orders_windowed")
	.start()
)
```

## What This Code Teaches

- the stream must first be parsed into a trustworthy structured shape
- the watermark is not isolated syntax; it affects when grouped windows can be finalized
- adding `event_type` to the grouping increases both business detail and state complexity
- checkpointed streaming writes are part of correctness, not just deployment plumbing

## Real Review Questions For This Example

1. Is 10 minutes of lateness actually justified by source behavior?
2. Should this output be treated as final, provisional, or near-real-time operational only?
3. If one country produces most traffic, does the state distribution remain healthy?

## Practical Questions To Ask

1. How late do events actually arrive in this domain?
2. Which outputs can tolerate preliminary values?
3. Which outputs must be as close as possible to final truth?
4. How much state cost is acceptable for better event-time correctness?

These questions are more useful than treating watermark values as magic numbers.

## Common Mistakes

### Mistake 1: Picking Watermarks Without Business Context

The pipeline may become fast but semantically wrong.

### Mistake 2: Forgetting That More State Has A Cost

Longer tolerance windows often mean more memory pressure and more operational sensitivity.

### Mistake 3: Treating Late Data As Rare Noise

In many systems, late data is part of the normal shape of reality.

### Mistake 4: Publishing Outputs As Final Without Explaining Lateness Assumptions

Consumers need to understand whether an output is immediately final, eventually corrected, or intentionally approximate.

## Good Strategy

- measure real lateness behavior before locking in assumptions
- treat watermark and state design as business correctness decisions
- document which outputs are preliminary versus final enough for consumers
- make late-data policy visible in dataset contracts and pipeline reviews

## Key Architectural Takeaway

Watermarks and state policies define the contract between latency and correctness in Spark streaming systems.