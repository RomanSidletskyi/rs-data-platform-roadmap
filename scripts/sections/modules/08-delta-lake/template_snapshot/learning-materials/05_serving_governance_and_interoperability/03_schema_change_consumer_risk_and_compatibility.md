# Schema Change, Consumer Risk, And Compatibility

## Why This Topic Matters

Delta Lake can support schema evolution.

That does not mean every schema change is safe for downstream users.

## Practical Risk

A technically valid schema change can still break:

- dashboards
- downstream joins
- contracts assumed by external consumers

That is why technically valid schema evolution and operationally safe schema evolution are not the same thing.

## Example

```python
(incoming_df.write
    .format("delta")
    .mode("append")
    .option("mergeSchema", "true")
    .saveAsTable("silver.orders"))
```

The write may succeed.

The consumer impact still needs review.

For example, a new nullable column may be harmless for some consumers, while a changed type, renamed field, or altered meaning may break dashboards and downstream transformations immediately.

## Good Vs Bad Compatibility Practice

Healthy practice:

- schema changes are reviewed for consumer impact
- technical and semantic changes are separated conceptually
- gold-layer exposure is more conservative than silver-layer experimentation

Weak practice:

- mergeSchema becomes the default answer to all upstream surprises
- downstream users are expected to adapt automatically
- semantic contract changes hide inside technical schema drift

## Practical Questions

1. Is the change additive, breaking, or semantic?
2. Which consumers depend on the old shape?
3. Should this change stop in silver rather than flow into gold?
4. Will views, joins, or BI models behave differently after the change?
5. Is silent success of the write actually increasing downstream risk?

## Key Architectural Takeaway

Schema evolution is a technical capability. Compatibility is a product and governance decision.
