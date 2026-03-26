# Deduplication Pattern

## Goal

Keep only one row per business key.

## Latest record per user

```sql
WITH ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY user_id
               ORDER BY updated_at DESC
           ) AS rn
    FROM users_raw
)
SELECT *
FROM ranked
WHERE rn = 1;
```

## Keep latest event per order

```sql
WITH ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY order_id
               ORDER BY event_time DESC
           ) AS rn
    FROM order_events
)
SELECT *
FROM ranked
WHERE rn = 1;
```

## Use Cases

- CDC ingestion
- bronze to silver transformations
- event stream cleanup
- removing duplicates after retries

## Notes

A deduplication strategy must define:

- business key
- tie breaker
- deterministic ordering
