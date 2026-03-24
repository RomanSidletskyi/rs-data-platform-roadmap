# Incremental Models And Rebuild Boundaries

## Why This Topic Matters

One of the most important architecture decisions in Spark is whether a model should be:

- rebuilt fully
- updated incrementally
- partially replayed by partition or date window

This decision affects cost, correctness, operational complexity, and recovery design.

## Full Rebuild Versus Incremental Logic

A full rebuild can be attractive because it is simpler to reason about.

But as data grows, full rebuilds may become:

- too slow
- too expensive
- too operationally fragile

Incremental models reduce daily work by processing only changed slices.

But they add state and correctness complexity.

So this is not a purely technical preference. It is a trade-off decision.

Full rebuilds are often operationally simpler.

Incremental logic is often operationally cheaper.

The hard part is that simplicity and cost efficiency do not always align.

## Rebuild Boundary As Architecture

A rebuild boundary defines how far a Spark job needs to look backward to compute a correct result.

Examples:

- one partition per event date
- last seven days for late-arriving corrections
- full historical recomputation for certain compliance outputs

This boundary affects:

- runtime predictability
- backfill ease
- ability to recover from bugs
- downstream trust in the output

It also affects whether incidents are recoverable in hours or in days.

## Real Example

Suppose a daily customer-order summary is published from Spark.

If order corrections can arrive up to three days late, a naive single-day incremental load may be wrong.

A stronger design may:

- reprocess the last three days each run
- overwrite only impacted partitions
- validate row counts and key metrics before publish

That is not just a data engineering trick.

It is architectural alignment between business latency and pipeline behavior.

Another realistic example:

- a customer-value mart is updated daily
- support corrections can arrive for the previous week
- finance reports use the same output but expect trustworthy historical values

A weak design might process only the latest day.

A stronger design might:

- reprocess a rolling seven-day window
- isolate critical downstream republish logic
- document which outputs are considered provisional until the correction window closes

## Real PySpark Example

```python
from pyspark.sql import functions as F

rolling_orders = (
	spark.read.parquet("/lake/bronze/orders")
	.filter(F.col("event_date") >= F.date_sub(F.current_date(), 7))
)

daily_customer_value = (
	rolling_orders
	.groupBy("event_date", "customer_id")
	.agg(F.sum("net_amount").alias("customer_value"))
)

(daily_customer_value
	.write
	.mode("overwrite")
	.partitionBy("event_date")
	.parquet("/lake/gold/customer_daily_value")
)
```

This code encodes an explicit rebuild boundary: reprocess the latest seven days because corrections may arrive inside that window.

## Safer Incremental Publish Example

```python
from pyspark.sql import functions as F

source_orders = (
	spark.read.parquet("/lake/bronze/orders")
	.filter(F.col("event_date").between("2026-03-18", "2026-03-24"))
	.select("event_date", "customer_id", "order_id", "net_amount", "order_status")
)

rebuilt_window = (
	source_orders
	.groupBy("event_date", "customer_id")
	.agg(
		F.countDistinct("order_id").alias("orders_cnt"),
		F.sum("net_amount").alias("customer_value")
	)
)

(rebuilt_window
	.write
	.mode("overwrite")
	.partitionBy("event_date")
	.parquet("/lake/rebuild/customer_daily_value_2026_03_24")
)

validation = (
	spark.read.parquet("/lake/rebuild/customer_daily_value_2026_03_24")
	.groupBy("event_date")
	.agg(
		F.sum("customer_value").alias("value_sum"),
		F.sum("orders_cnt").alias("orders_sum")
	)
	.orderBy("event_date")
)
```

## Why This Example Is Better Than A Tiny Incremental Demo

- it makes the rebuild window explicit instead of hiding it inside relative date logic
- it publishes into an isolated rebuild location first
- it includes a post-build validation step before any consumer cutover
- it reflects the operational reality that important incremental fixes often need controlled republish, not blind overwrite of trusted output

## Questions To Ask Before Choosing Incremental Logic

1. What kinds of late or corrected records exist in this domain?
2. How expensive is a full rebuild today, and how expensive will it be later?
3. Which downstream consumers can tolerate provisional values?
4. Can the model be replayed safely without rebuilding everything?
5. Does the chosen incremental boundary match the real business correction window?

These questions are more important than simply asking whether incremental processing is faster.

## Common Mistakes

### Mistake 1: Choosing Incremental Logic Only For Speed

Incremental processing should reduce cost without silently breaking correctness.

### Mistake 2: Ignoring Late Data Behavior

If late or corrected records are part of the business reality, rebuild boundaries must account for them.

### Mistake 3: Making Rebuild Paths An Afterthought

If replay and bug recovery are not planned up front, incidents become harder and more expensive later.

### Mistake 4: Treating One Incremental Rule As Universal

Different outputs may need different rebuild horizons depending on lateness, corrections, and trust requirements.

## Good Strategy

- design the rebuild boundary explicitly
- connect it to business lateness and correction behavior
- choose incremental logic only when the correctness model is understood
- make replay paths part of the model design, not emergency-only work
- distinguish between outputs that can be cheaply rebuilt and outputs that require carefully controlled republish behavior

## Key Architectural Takeaway

Incremental Spark models are not only faster models. They are models with explicit assumptions about time, change, and recoverability.