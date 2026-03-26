# Partitioning Recipe

## Goal

Choose table partitioning based on query shape and rewrite boundaries rather than habit.

## Why This Recipe Exists

Partitioning is often treated like a default checkbox: pick a date column and move on.

That is too shallow.

The goal of this recipe is to help the learner decide when partitioning improves the table and when it quietly makes writes, maintenance, and repair harder.

## Recipe

1. Identify the most common high-value filter pattern.
2. Avoid partition columns with explosive cardinality.
3. Prefer partitioning that supports bounded rewrites and pruning.
4. Revisit the decision when table growth changes access shape.

## When This Recipe Applies

Use this recipe when:

- the table is growing fast
- queries repeatedly filter by time window or another stable boundary
- repairs or backfills should be scoped to part of the table
- the team is unsure whether to partition at all

## Example

```python
(sales_df.write
    .format("delta")
    .partitionBy("order_date")
    .mode("overwrite")
    .saveAsTable("gold.daily_store_sales"))
```

Healthy interpretation:

- `order_date` is a common filter
- repairs can be bounded by date
- partition count stays operationally reasonable

Weak interpretation would be partitioning by a high-cardinality key like `order_id`, which usually creates too many tiny partitions and painful maintenance.

## Real Scenario

Scenario:

- analysts often read the last 30 days of sales
- repairs are usually done for one day or a few days at a time
- the table is growing quickly

Healthy reasoning:

- `order_date` is a good partition boundary
- bounded rewrites can align to the same key
- pruning and repair logic help each other

Another scenario:

- users filter by `customer_id` and `store_id` frequently
- neither is a good partition key because cardinality is too high

In that case, partitioning alone is not the whole answer and layout tuning may be more appropriate.

## Good Fit

- queries commonly filter by the chosen column
- writes and repairs can be bounded along the same dimension
- cardinality is controlled enough for stable partition layout

## Bad Fit

- partitioning mirrors any available column without workload evidence
- the chosen column has huge cardinality
- consumers rarely filter by the partition key
- table maintenance becomes harder than query pruning benefit justifies

## Decision Questions

1. What filters dominate real queries?
2. Will this key help both pruning and bounded rewrites?
3. How many partitions will exist after months of growth?
4. Is Z-order or file-layout tuning a better fit than partitioning?
5. Would no partitioning be simpler and safer here?

Two more useful questions:

6. Will this key help repair and backfill boundaries too?
7. Are we choosing the partition key for consumer reads, write convenience, or both?

## Good Response Versus Weak Response

Good response:

- choose partitioning from actual query and rewrite patterns
- keep cardinality under control
- revisit the choice as the table grows

Weak response:

- partition by the first plausible-looking column
- ignore maintenance and hot-partition consequences
- keep a bad layout because changing it feels costly

## Rule

Partitioning should improve pruning and repair scope, not merely mirror any column that exists.
