# Joins, Aggregations, And Window Patterns

## Why This Topic Matters

Most valuable Spark jobs eventually do one or more of these:

- join datasets
- aggregate metrics
- compute window-based logic

These are also the places where distributed cost becomes visible very quickly.

## Joins

Joins connect datasets, but they also create execution risk.

Common join questions:

- how big are both sides?
- is one side small enough for a broadcast-style approach?
- are keys skewed?
- are unnecessary columns pruned before the join?

Architecturally, joins are often where raw and reference data become business-ready outputs.

That makes them both important and expensive.

This is why joins should be reviewed not only for syntax correctness, but also for grain, placement, and downstream consequences.

## Aggregations

Aggregations are how many raw datasets become useful analytical outputs.

Examples:

- revenue by day
- daily active users
- order count by country
- error count by service

But aggregations often require grouping across partitions, which may trigger shuffles.

This is why aggregation design is partly a business question and partly a distributed-systems question.

For example, "revenue by day and country" is a business need, but the cost of producing it depends on when the aggregation happens and how much raw data it carries into the wide stage.

## Window Patterns

Window logic helps when you need context across rows without collapsing the dataset fully.

Examples:

- ranking rows within a group
- computing rolling metrics
- identifying latest record per entity
- calculating session-like or sequential behavior

This is one of the places where Spark becomes much more expressive than simple row-wise scripts.

It is also one of the places where cost is underestimated, because ordering and partitioning work is easy to hide behind compact syntax.

## Example

Imagine an order pipeline:

- orders dataset contains transactions
- customer dataset contains segment labels
- Spark joins orders to customers
- Spark aggregates revenue by segment and day
- Spark uses a window to identify latest order per customer

This is a realistic data-platform pattern, not just an API exercise.

Another realistic example:

- a customer-events dataset needs the latest known status per customer
- a window is used to identify the newest row for each entity
- that output later feeds a customer-level mart

The code may look elegant.

The design still needs review for ordering cost, partitioning assumptions, and output grain.

## Real PySpark Example

```python
from pyspark.sql import Window, functions as F

orders = spark.read.parquet("/lake/silver/orders")
customers = spark.read.parquet("/lake/silver/customers")

latest_order_window = Window.partitionBy("customer_id").orderBy(F.col("event_time").desc())

customer_latest_order = (
	orders
	.join(customers.select("customer_id", "segment"), on="customer_id", how="left")
	.withColumn("row_num", F.row_number().over(latest_order_window))
	.filter(F.col("row_num") == 1)
	.groupBy("segment")
	.agg(F.sum("net_amount").alias("latest_order_revenue"))
)
```

## How To Read This Code

- the join enriches orders with a customer attribute needed for the final metric
- the window is partitioned by `customer_id`, which matches the entity whose latest row is needed
- `row_number()` is used to keep only the most recent row per customer
- the aggregation happens only after the entity-level reduction

This sequencing matters.

If the aggregation happened earlier, the pipeline would answer a different business question.

## Longer End-To-End Example

```python
from pyspark.sql import Window, functions as F

orders = (
	spark.read.parquet("/lake/bronze/orders")
	.filter(F.col("event_date").between("2026-03-01", "2026-03-31"))
	.select(
		"order_id",
		"customer_id",
		"product_id",
		"event_date",
		"event_time",
		"net_amount",
	)
)

customers = (
	spark.read.parquet("/lake/silver/customers")
	.select("customer_id", "segment")
	.dropDuplicates(["customer_id"])
)

product_dim = (
	spark.read.parquet("/lake/silver/products")
	.select("product_id", "category_name")
	.dropDuplicates(["product_id"])
)

enriched_orders = (
	orders
	.join(F.broadcast(customers), on="customer_id", how="left")
	.join(F.broadcast(product_dim), on="product_id", how="left")
)

daily_segment_category = (
	enriched_orders
	.groupBy("event_date", "segment", "category_name")
	.agg(
		F.countDistinct("order_id").alias("orders_cnt"),
		F.sum("net_amount").alias("net_revenue")
	)
)

latest_order_window = Window.partitionBy("customer_id").orderBy(F.col("event_time").desc())

latest_order_per_customer = (
	enriched_orders
	.withColumn("row_num", F.row_number().over(latest_order_window))
	.filter(F.col("row_num") == 1)
	.select("customer_id", "segment", "category_name", "event_time", "net_amount")
)
```

## Why This Example Is Closer To Real Work

- the fact table is filtered and projected before expensive joins
- both dimensions are deduplicated before enrichment so model assumptions are explicit
- small dimensions are broadcast because the code is modeling reference-data enrichment, not a fact-to-fact join
- one path produces a daily mart, while another path produces a latest-entity view from the same enriched base

## How To Review This Code Like An Architect

Ask these questions in order:

1. Is `orders` clearly the fact-like dataset and are the other two truly dimension-like?
2. Are we enriching before aggregation for a real business reason, or just because it was easy to code?
3. Does `latest_order_per_customer` belong in the same pipeline output, or should it become a separate consumer-facing model?
4. If customer or product dimensions stop being small, does the join strategy still hold?

## Good Response Versus Weak Response

Good response:

- reduce rows and columns before large joins
- confirm semantic grain before aggregating
- use windows intentionally rather than by habit
- ask whether the resulting dataset is truly consumer-ready

Weak response:

- join raw datasets at full width because it is simpler to code
- aggregate only at the very end even when earlier reduction was possible
- use windows without considering ordering and partition cost

## Common Mistakes

### Mistake 1: Joining Before Reducing Inputs

Carrying unnecessary columns or rows into a join increases cost for little value.

### Mistake 2: Ignoring Skewed Keys

Some groups can dominate runtime and make one stage much slower than the rest.

### Mistake 3: Using Windows Without Thinking About Cost

Window functions are powerful, but they still operate in a distributed execution model with partitioning and ordering costs.

### Mistake 4: Mixing Several Grains In One Output

If event-level, customer-level, and daily aggregate logic collapse into one dataset carelessly, the output becomes harder to trust and maintain.

## Practical Review Questions

1. What is the grain before the join or aggregation?
2. Can one side be reduced or standardized first?
3. Will this step trigger another wide transformation immediately afterward?
4. Does the window depend on costly ordering over a large dataset?
5. Is the final output still semantically clear after these operations?

## Good Strategy

- prune and filter before major joins when possible
- think about data size and skew before choosing the join pattern
- use aggregations and windows as semantic tools, but respect their execution cost

## Key Architectural Takeaway

Joins, aggregations, and windows are where Spark often creates business value, but they are also where distributed data movement and execution complexity become real architectural concerns.