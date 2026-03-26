# Cost, Reliability, And Rewrite Boundaries

## Why This Topic Matters

Delta tables make rewrites safer than raw file mutation, but rewrites are still expensive when scoped badly.

## Practical Idea

Strong teams ask:

- can this change be bounded to one partition or date range?
- do we need a merge or a full overwrite?
- can a repair path avoid rewriting healthy data?

Those questions are crucial because reliability and cost often move together.

The broader the rewrite scope, the more compute, risk, and recovery pain the team usually accepts.

## Example

```python
(daily_df.write
    .format("delta")
    .mode("overwrite")
    .option("replaceWhere", "order_date = '2026-03-24'")
    .saveAsTable("silver.orders"))
```

Compare that with the weaker pattern:

```python
(full_df.write
    .format("delta")
    .mode("overwrite")
    .saveAsTable("silver.orders"))
```

The second form may be convenient early.

At scale it often becomes expensive, slow, and risky because healthy data gets rewritten together with the part that actually changed.

## Good Vs Bad Rewrite Strategy

Healthy strategy:

- rewrite only the affected slice when possible
- choose merge, replaceWhere, or restore based on real scope
- align repair cost with actual business need

Weak strategy:

- broad overwrite becomes the default fix
- reliability problems are hidden inside oversized rewrites
- compute spend rises because boundaries were never defined clearly

## Practical Questions

1. What is the smallest safe rewrite boundary?
2. Would merge or bounded overwrite be better than full overwrite?
3. Is this table designed for narrow repair or broad rebuild only?
4. Which consumers are affected if the whole table is restated?
5. Are current rewrite habits creating platform debt?

## Key Architectural Takeaway

Bounded rewrites are usually cheaper and safer than broad rewrites disguised as convenience.
