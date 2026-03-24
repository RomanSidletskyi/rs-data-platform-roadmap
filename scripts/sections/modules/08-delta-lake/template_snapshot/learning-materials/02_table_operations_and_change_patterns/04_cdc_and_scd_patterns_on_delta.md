# CDC And SCD Patterns On Delta

## Why This Topic Matters

Delta Lake is often chosen because real tables change over time.

That makes CDC and SCD patterns central, not optional.

## CDC Pattern

A simple CDC upsert pattern:

```python
from delta.tables import DeltaTable

customers = DeltaTable.forName(spark, "silver.customers")

(customers.alias("target")
    .merge(cdc_df.alias("source"), "target.customer_id = source.customer_id")
    .whenMatchedUpdateAll()
    .whenNotMatchedInsertAll()
    .execute())
```

That is only the shortest technical form.

Real CDC design still needs answers to questions such as:

- are delete events present?
- which record wins if several changes arrive for one key?
- is the feed latest-state, event-style, or mixed?

## SCD Thinking

The main design question is not only whether the table changes.

It is whether consumers need the latest state only, or historical state transitions as well.

That distinction is what separates SCD1-like latest-state behavior from SCD2-like history-preserving behavior.

## Good Vs Bad CDC Design

Healthy design:

- source change semantics are understood
- merge keys and update precedence are explicit
- latest-state and historical-state requirements are separated clearly

Weak design:

- CDC is treated as "some updates happened" with no clear business rules
- deletes and duplicates are ignored
- the table mixes latest-state and historical-state expectations for different consumers

## Practical Questions

1. Does the consumer need current truth or history of truth?
2. Are deletes represented in the source?
3. What determines the winning change when multiple updates arrive?
4. Is one Delta table enough, or should current and historical views be separated?
5. Can the CDC load be replayed safely?

## Key Architectural Takeaway

Delta Lake supports change patterns well, but the table design still depends on business history requirements, not on syntax alone.
