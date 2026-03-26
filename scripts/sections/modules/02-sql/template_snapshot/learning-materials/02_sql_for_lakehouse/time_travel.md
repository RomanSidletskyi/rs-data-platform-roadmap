# Time Travel

## Goal

Read previous versions of Delta tables.

## Example: By version

```sql
SELECT *
FROM silver_orders VERSION AS OF 10;
```

## Example: By timestamp

```sql
SELECT *
FROM silver_orders TIMESTAMP AS OF '2025-01-01T12:00:00Z';
```

## Use Cases

- debugging bad loads
- reproducible analytics
- historical comparisons
- rollback support
