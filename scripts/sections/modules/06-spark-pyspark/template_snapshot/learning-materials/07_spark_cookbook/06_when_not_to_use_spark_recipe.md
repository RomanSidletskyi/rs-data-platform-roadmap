# When Not To Use Spark Recipe

## Why This Recipe Exists

Strong architects do not only know how to use Spark. They know when Spark is unnecessary.

This recipe is for avoiding distributed-compute ceremony where a simpler tool would solve the problem faster and more cleanly.

## Use This Recipe When

- a team wants Spark because the problem "sounds big"
- a pipeline is mostly tiny daily files and light transformations
- warehouse SQL or local Python may already be enough
- a platform already has two other transformation layers and Spark would become a third without a clear new capability
- the strongest argument for Spark is organizational prestige rather than workload shape

## Decision Questions

1. Does the workload truly require distributed execution?
2. Is the data size or complexity actually beyond local tools or warehouse-native transforms?
3. Are you introducing Spark because of need, or because of habit and status?
4. Will Spark reduce system complexity or add another compute layer without clear value?
5. Who will operate and own the Spark layer after the first implementation?
6. Does Spark improve recovery and replay design, or does it only add one more moving part?

## Quick Decision Matrix

Spark is often more justified when:

- input data is large enough that single-node tools become unreliable or slow
- transformation cost is dominated by distributed joins, aggregations, or parsing
- replay and multi-layer lakehouse processing are part of the platform design

Spark is often less justified when:

- data already lives in a warehouse suited for the transformation
- the workload is small and highly relational
- the platform would gain no meaningful capability beyond what existing tools already provide

This matrix matters because it forces the conversation back to workload shape instead of tool enthusiasm.

## Real Example

Scenario:

- an internal report transforms a few hundred megabytes daily
- the data already lives in a warehouse
- the logic is mostly SQL-friendly

Spark may still work.

But it may be the wrong tool because it adds a separate compute boundary without solving a real architectural problem.

Another example:

- a team wants to create a tiny daily CSV export from one curated warehouse table
- the transform is mostly projection, renaming, and one aggregate

Spark can do this.

But the healthier question is why a distributed engine should be introduced for a problem that is already well-contained elsewhere.

Another realistic pattern:

- a team already has warehouse-native modeling and dbt for curated analytics
- Spark is proposed only because another platform team uses it successfully for a different workload class
- there is no new scale, latency, or replay requirement

That is usually imitation, not architecture.

## Real Comparison Example

PySpark version:

```python
from pyspark.sql import functions as F

daily_export = (
		spark.read.parquet("/warehouse_exports/daily_customer_orders")
		.filter(F.col("event_date") == F.lit("2026-03-24"))
		.groupBy("country_code")
		.agg(F.sum("net_amount").alias("revenue"))
)
```

Warehouse SQL version:

```sql
SELECT
	country_code,
	SUM(net_amount) AS revenue
FROM curated.daily_customer_orders
WHERE event_date = DATE '2026-03-24'
GROUP BY country_code;
```

## Why This Example Matters

Both snippets can produce the same business answer.

If the data is already curated in the warehouse and the workload is small, the SQL version is often healthier because:

- there is no extra Spark runtime boundary
- no separate cluster or job orchestration is needed
- the business logic stays near the serving layer that already owns the data

## A Better Spark Justification Example

Spark becomes easier to justify when the code looks more like this:

```python
clickstream = spark.read.json("/lake/bronze/clickstream/2026-03-24/*")
product_views = spark.read.parquet("/lake/silver/product_views")

session_metrics = (
		clickstream
		.filter(F.col("event_type").isin("view", "add_to_cart", "purchase"))
		.groupBy("session_id", "product_id")
		.agg(F.count("*").alias("events_cnt"))
		.join(product_views, on="product_id", how="left")
)
```

Here the workload is more plausibly distributed, file-oriented, and lake-native.

## Good Response Versus Weak Response

Good response:

- estimate workload size honestly
- compare Spark against warehouse SQL, dbt, or a small Python job
- include ownership and operational overhead in the decision

Weak response:

- use Spark because the team is "standardizing"
- ignore the extra cluster, runtime, and monitoring burden
- assume future scale automatically justifies current complexity

## Questions To Challenge A Weak Spark Proposal

1. What becomes impossible or operationally risky without Spark?
2. Which current layer actually fails to meet the requirement?
3. Is the proposed value about scale, latency, recoverability, or only organizational preference?
4. Will Spark simplify the platform, or only spread business logic across one more boundary?

If those questions do not produce concrete answers, the case for Spark is weak.

## Common Hidden Costs Of Unnecessary Spark

- duplicate business logic across Spark and warehouse layers
- another deployment and runtime boundary to support
- extra incident surface area
- less clarity for downstream consumers about where truth is produced

There is also a learning and maintenance cost:

- every new engineer must now understand one more compute model and one more place where business logic lives

## Architectural Takeaway

Spark is strongest when it earns its distributed complexity. If a simpler layer can solve the workload cleanly, that is often the better architecture.