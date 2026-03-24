# Constraints, Expectations, And Data Quality

## Why This Topic Matters

Reliable tables are not only about ACID writes.

They are also about whether the data still satisfies the intended contract.

## Constraint Example

```sql
ALTER TABLE silver.orders
ADD CONSTRAINT valid_order_amount CHECK (net_amount >= 0);
```

Another practical example is rejecting rows that violate a key assumption before they reach a consumer-facing layer:

```python
invalid_orders = silver_df.filter("order_id IS NULL OR net_amount < 0")

if invalid_orders.limit(1).count() > 0:
	raise ValueError("silver.orders contains invalid keys or negative revenue")
```

The exact mechanism can vary, but the principle is the same: fail or quarantine intentionally instead of letting bad state become normal.

## Why This Matters

Constraints and quality checks help move teams away from silent corruption toward explicit failure.

That is usually healthier for shared data products.

## Good Vs Bad Quality Posture

Healthy posture:

- key quality rules are explicit
- invalid rows fail loudly or are quarantined deliberately
- consumer-facing tables carry stronger guarantees than source-near layers

Weak posture:

- invalid data is tolerated because the write technically succeeds
- quality checks exist only in dashboards after the table is already published
- each downstream consumer rediscovers the same data problem separately

## Practical Review Questions

1. What assumptions must always hold true for this table?
2. Which violations should block the write versus be quarantined?
3. Is this quality rule appropriate for bronze, silver, or gold?
4. Who owns the decision when invalid data appears?
5. Will consumers notice the issue before the platform does?

## Key Architectural Takeaway

Delta Lake reliability improves when table validity is enforced intentionally instead of assumed.
