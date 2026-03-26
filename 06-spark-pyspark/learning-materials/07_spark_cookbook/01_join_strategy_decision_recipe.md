# Join Strategy Decision Recipe

## Why This Recipe Exists

Spark joins are one of the most common sources of runtime cost, skew, and design mistakes.

This recipe helps decide how to think about a join before it becomes a production problem.

The goal is not to memorize one "best" join trick. The goal is to learn how to classify the join and reason about its place in the pipeline.

## Use This Recipe When

- you are joining fact-like and dimension-like datasets
- one side may be much smaller than the other
- runtime suddenly grows after a new join step
- you are unsure whether the issue is code, data volume, or key distribution

## Start With Join Classification

Ask what kind of join this really is:

- fact-to-dimension
- fact-to-fact
- enrichment join on a small reference layer
- reconciliation join between large operational datasets

This matters because the expected cost profile is very different.

It also matters because not every hard join problem is truly a join problem.

Sometimes it is an upstream modeling or boundary problem that only becomes visible at join time.

## Decision Questions

1. How large is each side of the join?
2. Can one side reasonably behave like reference data rather than another fact-scale stream?
3. Are keys evenly distributed?
4. Can either side be filtered or projected before the join?
5. What downstream output is the join feeding?
6. Is this join happening at the right layer of the architecture?
7. Would changing the upstream model reduce the need for such an expensive join?
8. Is the output of this join truly consumer-ready, or only another intermediate shape?

## Real Example

Scenario:

- raw orders dataset has 800 million rows for the month
- product dimension has 50 thousand rows
- the goal is daily revenue by product category

Healthy thinking:

- keep only required columns from both sides
- filter the orders window first
- recognize that the product dataset is dimension-like
- verify the key distribution is sane

Weak thinking:

- join full raw orders with all dimension columns first
- aggregate later
- ignore skew or unnecessary columns

Another realistic example:

- event feed A and event feed B both contain hundreds of millions of rows
- the team joins them directly every day to create a support view

This may be technically possible, but architecturally weak if a narrower intermediate model or incremental boundary could have reduced the work substantially.

One more example:

- a customer table is joined with several fact-like datasets to build one giant "360" table
- each consumer only needs a subset of the enrichments

The join can be technically valid.

The platform strategy may still be weak because the output is overloaded and expensive.

## Real PySpark Example

```python
from pyspark.sql import functions as F

orders = (
	spark.read.parquet("/lake/bronze/orders")
	.filter(F.col("event_date") >= F.lit("2026-03-01"))
	.select("order_id", "product_id", "quantity", "unit_price", "event_date")
)

products = (
	spark.read.parquet("/lake/silver/products")
	.select("product_id", "category_name")
	.dropDuplicates(["product_id"])
)

daily_revenue = (
	orders
	.join(F.broadcast(products), on="product_id", how="left")
	.withColumn("line_revenue", F.col("quantity") * F.col("unit_price"))
	.groupBy("event_date", "category_name")
	.agg(F.sum("line_revenue").alias("revenue"))
)
```

## Why This Code Is Healthy

- `filter(...)` happens before the join, so the large side is pruned early
- `select(...)` drops columns that would otherwise make the shuffle or scan heavier
- `dropDuplicates(["product_id"])` makes the dimension contract explicit instead of assuming uniqueness
- `broadcast(products)` matches the business reality that the product table is small reference data
- aggregation happens after enrichment because the category is needed for the output grain

## Code Review Notes

If a team wrote this instead:

```python
joined = spark.read.parquet("/lake/bronze/orders").join(
	spark.read.parquet("/lake/silver/products"),
	on="product_id",
	how="left",
)
```

the code is not automatically broken, but it is weak because:

- it reads everything before defining the actual business window
- it keeps unknown extra columns on both sides
- it hides whether the right side is truly dimension-like or not
- it makes later triage harder if runtime regresses

## Longer Comparison Example

Scenario:

- `orders` is fact-like and very large
- `products` is a small reference dimension
- `campaign_events` is also large and unevenly distributed by `campaign_id`

Safer staged approach:

```python
from pyspark.sql import functions as F

orders = (
	spark.read.parquet("/lake/bronze/orders")
	.filter(F.col("event_date").between("2026-03-01", "2026-03-31"))
	.select("order_id", "product_id", "campaign_id", "event_date", "net_amount")
)

products = (
	spark.read.parquet("/lake/silver/products")
	.select("product_id", "category_name")
	.dropDuplicates(["product_id"])
)

campaign_daily = (
	spark.read.parquet("/lake/silver/campaign_events")
	.filter(F.col("event_date").between("2026-03-01", "2026-03-31"))
	.groupBy("event_date", "campaign_id")
	.agg(F.count("*").alias("campaign_events_cnt"))
)

orders_enriched = orders.join(F.broadcast(products), on="product_id", how="left")

final_output = (
	orders_enriched
	.groupBy("event_date", "campaign_id", "category_name")
	.agg(F.sum("net_amount").alias("revenue"))
	.join(campaign_daily, on=["event_date", "campaign_id"], how="left")
)
```

Why this staged design is healthier:

- the dimension join happens early because it is cheap and needed for downstream grain
- the second large dataset is reduced before it joins the revenue output
- the pipeline avoids a giant raw fact-to-fact join at full event grain

Weak alternative:

```python
everything = (
	spark.read.parquet("/lake/bronze/orders")
	.join(spark.read.parquet("/lake/silver/products"), on="product_id", how="left")
	.join(spark.read.parquet("/lake/silver/campaign_events"), on="campaign_id", how="left")
)
```

This weak version hides the most important design question: should the second large join happen at raw event grain at all?

## Common Anti-Patterns

- joining before pruning input size
- joining two large datasets without asking whether the architecture can reduce one side earlier
- treating all joins as equal even though some are fact-to-dimension and others are fact-to-fact
- optimizing the join mechanically without questioning whether the pipeline boundary is wrong
- collapsing many consumer needs into one oversized join path because it feels easier for one team

## Healthy Review Checklist

- are the join keys semantically correct?
- are duplicate keys expected on either side?
- is one side small enough to be treated as reference data?
- are non-required columns pruned before the join?
- will the join output feed more wide transformations afterward?
- is the resulting dataset at a clear grain?
- would a reusable intermediate layer reduce repeated heavy joins later?

## Architectural Takeaway

Join strategy is not only a code-level choice. It is a statement about data size, system boundaries, and where enrichment should happen in the platform.