# Optimization Patterns

## Main Patterns

- optimize file sizes
- use partition pruning
- use ZORDER
- avoid excessive small files
- cluster for common filters
- filter early in transformations

## Example

```sql
OPTIMIZE silver_orders
ZORDER BY (customer_id);
```

## Important

Optimization in lakehouse systems is often more about:

- file layout
- metadata
- scan reduction

than about classic row-store indexing.
