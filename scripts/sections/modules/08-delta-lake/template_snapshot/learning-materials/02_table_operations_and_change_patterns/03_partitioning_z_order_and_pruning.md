# Partitioning, Z-Order, And Pruning

## Why This Topic Matters

Delta Lake tables can still be slow if data skipping and pruning opportunities are weak.

## Partitioning

Partitioning helps when queries repeatedly filter on a stable high-value column such as date.

Weak partitioning creates:

- too many small partitions
- hot partitions
- write and maintenance pain

Healthy partitioning is therefore not just about read pruning.

It is also about keeping writes, repairs, and maintenance operationally reasonable.

## Z-Order

Z-order style layout optimization helps cluster data for common filter patterns when plain partitioning is not enough.

This is often useful when queries filter on several important columns, but those columns are not good partition keys by themselves.

## Practical Example

```sql
OPTIMIZE gold.daily_store_sales ZORDER BY (country, store_id);
```

This makes more sense when analysts repeatedly filter by `country` and `store_id`, but the table is partitioned by a broader key such as `order_date`.

## Good Vs Bad Layout Decisions

Healthy decisions:

- partition by a stable high-value pruning boundary
- use Z-order or similar layout tuning for secondary access patterns
- revisit layout as query behavior evolves

Weak decisions:

- partition on high-cardinality columns out of habit
- expect one layout rule to solve every access pattern
- keep poor partitioning long after workload shape changed

## Practical Questions

1. What filters dominate real reads?
2. Which column is a good partition boundary versus a good clustering hint?
3. Are we creating too many partitions for the write pattern?
4. Would layout tuning help more than repartitioning?
5. How will repairs behave with the current layout?

## Key Architectural Takeaway

Partitioning and layout are query-shape decisions, not default settings to apply blindly.
