# Multi-Hop Patterns: Bronze, Silver, Gold

## Why This Topic Matters

As Spark pipelines grow, teams need structure between raw ingestion and final consumer-ready outputs.

A multi-hop pattern is one of the most practical ways to create that structure.

The names may vary by organization, but the core idea is stable:

- raw layer
- cleaned and conformed layer
- curated consumer layer

## What The Layers Usually Mean

At a simplified level:

- bronze keeps source-near data with minimal interpretation
- silver applies cleaning, normalization, and core business alignment
- gold publishes consumer-oriented outputs and KPIs

This is not a law of nature, but it is a useful mental model for keeping responsibilities separate.

The real value of the pattern is not the color names.

The real value is that each layer answers a different question.

- bronze asks: what arrived?
- silver asks: what is valid and conformed?
- gold asks: what is ready for consumers?

## Why Spark Fits This Well

Spark is frequently used across these hops because it can:

- parse raw semi-structured data
- apply scalable transformations
- build conformed intermediate datasets
- publish wide curated outputs for analytics

## Real Example

Imagine a Kafka-to-lakehouse flow for order events.

Possible multi-hop path:

- bronze stores parsed but source-near order events
- silver standardizes statuses, filters invalid records, and aligns keys
- gold publishes daily revenue, refund, and order lifecycle marts

This structure helps because not every concern belongs in the same model.

Another realistic flow:

- bronze stores support-event facts with minimal interpretation
- silver standardizes ticket states, timestamps, and agent mappings
- gold publishes daily support KPIs and backlog summaries

The pattern remains useful even though the domain changed, because the responsibilities stayed distinct.

## Real PySpark Example

```python
from pyspark.sql import functions as F

bronze_orders = spark.read.parquet("/lake/bronze/orders")

silver_orders = (
	bronze_orders
	.withColumn("order_status", F.upper(F.trim(F.col("order_status"))))
	.filter(F.col("order_id").isNotNull())
	.select("event_date", "order_id", "customer_id", "order_status", "net_amount")
)

gold_daily_orders = (
	silver_orders
	.groupBy("event_date")
	.agg(F.sum("net_amount").alias("daily_revenue"))
)
```

This code demonstrates the responsibility split:

- bronze is source-near input
- silver standardizes and validates
- gold publishes a consumer-facing metric layer

## More Production-Shaped Example

```python
from pyspark.sql import functions as F

bronze_orders = spark.read.parquet("/lake/bronze/orders")

silver_orders = (
	bronze_orders
	.withColumn("order_status", F.upper(F.trim(F.col("order_status"))))
	.withColumn("event_date", F.to_date("event_time"))
	.withColumn("is_valid", F.col("order_id").isNotNull() & F.col("net_amount").isNotNull())
	.filter(F.col("is_valid"))
	.select(
		"event_date",
		"order_id",
		"customer_id",
		"order_status",
		"net_amount",
		"ingested_at",
	)
)

(silver_orders
	.write
	.mode("overwrite")
	.partitionBy("event_date")
	.parquet("/lake/silver/orders")
)

gold_daily_orders = (
	spark.read.parquet("/lake/silver/orders")
	.groupBy("event_date", "order_status")
	.agg(
		F.countDistinct("order_id").alias("orders_cnt"),
		F.sum("net_amount").alias("net_revenue")
	)
)

(gold_daily_orders
	.write
	.mode("overwrite")
	.partitionBy("event_date")
	.parquet("/lake/gold/daily_orders")
)
```

## Why This Is A Better Learning Example

- silver is treated as a durable reusable layer, not only as an in-memory step
- validation is visible and local to the silver responsibility
- gold reads from silver, which makes replay and debugging boundaries much clearer than gold-from-bronze shortcuts

## Practical Review Questions

1. Which fields belong only in bronze for audit, and which should survive into silver?
2. Is the silver contract stable enough that multiple gold outputs can reuse it?
3. If gold metrics are disputed, do we have enough evidence in silver to isolate the problem quickly?

## Architectural Benefits

Multi-hop design improves:

- recoverability
- debugging clarity
- model ownership boundaries
- reuse across downstream teams

It also makes backfills and audits easier because the platform has intermediate evidence of transformation steps.

This is particularly valuable when:

- schema changes need investigation
- consumer-facing metrics are disputed
- a bug requires replay from a specific intermediate layer

## Common Mistakes

### Mistake 1: Putting Too Much Meaning Into Raw Layers

If bronze is already highly interpreted, recovery and auditability weaken.

### Mistake 2: Building Gold Directly From Raw Inputs For Everything

This may work for a few cases but often creates duplication and inconsistent business logic.

### Mistake 3: Creating Too Many Hops Without Clear Responsibility

Extra layers are useful only when each has a distinct role.

### Mistake 4: Treating Bronze As If It Were Already Consumer-Ready

That collapses audit, cleanup, and publication concerns into one unstable layer.

## Good Layering Questions

1. What data should remain source-near for replay and audit?
2. Where should core business conformance live so it can be reused?
3. Which outputs deserve gold-level contract discipline?
4. Can a broken gold layer be rebuilt from silver without reparsing everything from scratch?

## Good Strategy

- define the responsibility of each hop clearly
- use intermediate layers to stabilize reusable business logic
- keep raw, conformed, and consumer-facing concerns separated where practical

## Key Architectural Takeaway

Multi-hop Spark design is valuable because it turns one large opaque pipeline into several explicit platform layers with clearer responsibilities.