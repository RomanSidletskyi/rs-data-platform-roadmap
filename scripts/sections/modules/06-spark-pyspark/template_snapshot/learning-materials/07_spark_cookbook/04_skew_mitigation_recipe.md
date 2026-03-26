# Skew Mitigation Recipe

## Why This Recipe Exists

Skew is one of the most common reasons Spark jobs look "almost done" while one or two tasks keep running forever.

This recipe is for reasoning about skew as a data-shape problem first and only a compute problem second.

## Use This Recipe When

- one or a few tasks dominate stage runtime
- one business key or customer segment clearly outweighs the rest
- a join or aggregation became unstable after data distribution changed
- the Spark UI shows many tasks finishing quickly while one stage waits on a few stragglers
- runtime is acceptable on normal days but degrades sharply during sales, campaigns, or partner spikes

## Questions To Ask

1. Which keys are dominating record volume?
2. Is the skew a temporary anomaly or a stable business characteristic?
3. Can the heavy key be handled differently in the model or pipeline order?
4. Is the skew happening before or after a major shuffle?
5. Is the pipeline joining at too fine a grain before data has been reduced?
6. Would an intermediate conformed layer make the heavy operation more stable?

## Practical Investigation Sequence

1. identify the exact stage where tasks become unbalanced
2. inspect which join or aggregation key is producing the imbalance
3. decide whether the skew reflects real business distribution or bad modeling
4. check whether filtering, projection, or pre-aggregation could reduce the heavy side earlier
5. only then consider engine-level mitigation tactics

This order matters because skew is often diagnosed too late and too mechanically.

Teams jump to tuning before they ask whether the data shape itself is the main issue.

## Real Example

Scenario:

- a marketplace orders job groups by seller
- one mega-seller represents 40% of all records on sale days

Architectural consequence:

- the seller distribution is not an accident
- the pipeline must respect that reality rather than assume even work distribution

Another example:

- a customer-support events table is joined with a clickstream table on `customer_id`
- one enterprise customer generates massive internal traffic because many support users share the same account

The join may still be semantically correct.

But its execution profile becomes unstable because one key now pulls a disproportionate share of work into a few partitions.

## Real PySpark Example

```python
from pyspark.sql import functions as F

orders = spark.read.parquet("/lake/bronze/orders")

seller_counts = (
	orders
	.groupBy("seller_id")
	.agg(F.count("*").alias("row_count"))
	.orderBy(F.desc("row_count"))
)
```

This is a very practical first step.

Before tuning the engine, inspect whether a few keys dominate volume at all.

If one seller has 40% of the rows, that is not a Spark mystery. It is a business-distribution fact.

## Example Of A More Careful Join Shape

```python
seller_daily = (
	orders
	.groupBy("event_date", "seller_id")
	.agg(F.sum("net_amount").alias("daily_gmv"))
)

sellers = (
	spark.read.parquet("/lake/silver/sellers")
	.select("seller_id", "seller_tier")
	.dropDuplicates(["seller_id"])
)

result = seller_daily.join(F.broadcast(sellers), on="seller_id", how="left")
```

## Why This Code Is Better

- the heavy fact data is reduced before enrichment
- the join happens after aggregation, not before it
- the small seller reference table is explicitly treated as broadcastable reference data

This is the key lesson: many skew fixes come from changing where the join happens, not from magical config changes.

## Good Responses Versus Weak Responses

Good response:

- confirm the skewed business key
- ask whether the join grain is too raw
- reduce or reshape one side earlier if possible
- make the skew visible in platform monitoring and design reviews

Weak response:

- increase cluster size immediately
- treat the issue as temporary noise without inspecting the dominant keys
- declare the job "just slow sometimes"

## Common Places Skew Starts Earlier Than Expected

- joining raw event tables before standardizing keys
- aggregating on a business key with one or two dominant actors
- publishing one wide multi-use dataset that forces too many consumers through the same heavy regrouping logic

This is why skew is rarely only an execution detail. It often begins as a modeling and boundary choice.

## Common Anti-Patterns

- pretending skew is random noise
- only scaling hardware without understanding key distribution
- reviewing execution plans without reviewing the business distribution of the data
- focusing on Spark settings while ignoring the semantic meaning of the skewed key
- treating seasonal spikes as exceptional when they are part of the business calendar

## Design Questions For Architects

- should this computation happen at raw grain or at a reduced conformed grain?
- do we need one universal output, or should heavy consumers get a separate specialized path?
- are we optimizing for developer convenience while hiding a data-shape cost in production?

## Architectural Takeaway

Skew mitigation begins with honest understanding of data distribution and pipeline boundaries, not with magical tuning folklore.