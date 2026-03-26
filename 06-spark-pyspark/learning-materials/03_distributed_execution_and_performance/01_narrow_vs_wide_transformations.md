# Narrow Vs Wide Transformations

## Why This Topic Matters

One of the fastest ways to improve Spark intuition is to distinguish narrow and wide transformations.

This distinction tells you whether data can usually stay within existing partitions or whether Spark must redistribute it across the cluster.

That difference often determines runtime and cost.

In practice, this is one of the first execution-model lenses that helps a learner move from writing Spark code to designing Spark pipelines.

## Narrow Transformations

Narrow transformations usually let each output partition depend on a small set of input partitions, often one.

Examples:

- `select`
- `filter`
- simple `withColumn`

These operations are usually cheaper because they do not require broad data movement.

That does not mean they are free, but they are often easier for Spark to execute efficiently because they preserve locality better.

## Wide Transformations

Wide transformations often require data redistribution.

Examples:

- `groupBy`
- large joins
- `distinct`
- repartition-heavy reshaping

These operations are usually where shuffle cost appears.

This is why wide transformations often become the critical stages during tuning and incident review.

## A Useful Mental Shortcut

Ask a simple question:

- can the operation mostly work with the data already in its current partitions?

If yes, it behaves more like a narrow transformation.

If no, and records must be regrouped across the cluster, it behaves more like a wide transformation.

This shortcut is not perfect for every detail, but it is extremely useful for architectural reasoning.

## Real Example

Consider a pipeline that:

- reads raw order files
- filters one month of data
- selects relevant columns
- groups by `customer_id`
- writes customer revenue output

The filter and select steps are typically much closer to narrow behavior.

The final aggregation is much closer to wide behavior because customer records may need to move across partitions before they can be grouped correctly.

The business logic looks continuous.

The execution cost is not continuous.

## Real PySpark Example

```python
from pyspark.sql import functions as F

orders = spark.read.parquet("/lake/bronze/orders")

prepared = (
	orders
	.filter(F.col("event_date") >= F.lit("2026-03-01"))
	.select("customer_id", "net_amount", "event_date")
)

customer_revenue = (
	prepared
	.groupBy("customer_id")
	.agg(F.sum("net_amount").alias("revenue"))
)
```

How to read this code:

- `filter` and `select` are much closer to narrow work
- `groupBy("customer_id")` is the expensive boundary because records may need redistribution before grouping
- the code looks linear, but the cost profile changes sharply at the aggregation step

## Why This Matters Architecturally

If a pipeline is dominated by wide transformations, the architecture may need stronger attention to:

- partitioning
- upstream filtering
- output layout
- runtime expectations
- cost of repeated backfills

This is why execution model knowledge directly affects system design.

For example, if a curated table is rebuilt every day from wide transformations over a huge raw layer, you should expect:

- significant shuffle cost
- stronger cluster sizing requirements
- more sensitivity to skew
- longer replay and backfill windows

## Common Mistakes

### Mistake 1: Treating All Transformations As Equivalent

Some learners focus only on the DataFrame API surface and miss the fact that two equally readable lines of code can have very different execution implications.

### Mistake 2: Adding Several Wide Steps Without Reducing Data Early

If filtering, projection, or semantic cleanup could have reduced data before the wide operations, delaying them often increases cost unnecessarily.

### Mistake 3: Thinking Wide Is Bad And Narrow Is Good

Wide transformations are not mistakes. They are often necessary to create real business value.

The real goal is to understand when they happen and design around their cost honestly.

## Good Strategy

- identify wide operations early in the design review
- reduce unnecessary rows and columns before expensive regrouping steps when possible
- treat wide transformations as explicit cost points in the architecture
- connect business logic choices to data movement implications

## Key Architectural Takeaway

The narrow versus wide distinction is really a local-work versus data-movement distinction, and data movement is often where Spark jobs become expensive.