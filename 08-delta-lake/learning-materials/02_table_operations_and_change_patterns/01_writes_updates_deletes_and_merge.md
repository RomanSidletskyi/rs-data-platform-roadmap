# Writes, Updates, Deletes, And Merge

## Why This Topic Matters

Delta Lake becomes practically valuable when a team needs to do more than append immutable files.

That is where merge, update, and delete behavior matter.

## Append And Overwrite

Simple writes still exist:

```python
incoming_df.write.format("delta").mode("append").saveAsTable("bronze.orders_raw")
```

But Delta Lake also supports row-level style changes through table semantics.

Another important pattern is bounded overwrite for a known slice:

```python
(daily_df.write
    .format("delta")
    .mode("overwrite")
    .option("replaceWhere", "order_date = '2026-03-24'")
    .saveAsTable("silver.orders"))
```

This is often safer than broad overwrite because it rewrites only the intended window.

## Merge Example

```python
from delta.tables import DeltaTable

orders_table = DeltaTable.forName(spark, "silver.orders")

(orders_table.alias("target")
    .merge(updates_df.alias("source"), "target.order_id = source.order_id")
    .whenMatchedUpdateAll()
    .whenNotMatchedInsertAll()
    .execute())
```

Real teams usually need one step more than the shortest merge example: they need to decide how deletes, duplicates, and late corrections behave.

For example:

```python
(orders_table.alias("target")
    .merge(updates_df.alias("source"), "target.order_id = source.order_id")
    .whenMatchedUpdate(
        condition="source.updated_at >= target.updated_at",
        set={
            "status": "source.status",
            "updated_at": "source.updated_at",
            "net_amount": "source.net_amount",
        },
    )
    .whenNotMatchedInsertAll()
    .execute())
```

That version is more realistic because it makes late-arriving precedence explicit instead of silently trusting arrival order.

## Why Merge Matters

Merge is useful for:

- CDC ingestion
- upserts
- late-arriving corrections
- dimension maintenance

It is especially useful when the business thinks in terms of changing entity state rather than immutable append-only facts.

## Good Vs Bad Use

Healthy use:

- the business key is defined clearly
- update precedence rules are explicit
- replay of the same source slice is safe
- downstream consumers understand whether the table represents latest state or history

Weak use:

- merge is chosen just because the source changes somehow
- duplicate source records are not handled
- there is no rule for conflicting updates
- the pipeline cannot be rerun safely for the same interval

## Common Risk

Weak teams use merge everywhere without deciding:

- what the business key is
- how duplicates are handled
- whether replay is idempotent

Other common mistakes:

- using merge where append-only plus downstream aggregation would be simpler
- merging directly from raw unstable input without a cleaned silver boundary
- assuming merge makes bad source semantics safe automatically

## Practical Review Questions

1. What row or entity does this table represent?
2. What is the exact match key?
3. Which record wins if the same key appears twice?
4. Is a delete represented explicitly, implicitly, or not at all?
5. Can the same source slice be applied twice without corrupting the result?

## Key Architectural Takeaway

Delta Lake mutations are powerful, but they are safe only when table keys and change semantics are clearly defined.
