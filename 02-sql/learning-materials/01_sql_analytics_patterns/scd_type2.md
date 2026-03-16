# SCD Type 2 Pattern

## Goal

Track historical changes to dimension attributes.

## Example Dimension Columns

- customer_id
- customer_name
- country
- valid_from
- valid_to
- is_current

## Insert New Version Logic

```sql
UPDATE dim_customer
SET valid_to = CURRENT_DATE - INTERVAL '1 day',
    is_current = false
WHERE customer_id = 100
  AND is_current = true;

INSERT INTO dim_customer (
    customer_id,
    customer_name,
    country,
    valid_from,
    valid_to,
    is_current
)
VALUES (
    100,
    'Alice',
    'PL',
    CURRENT_DATE,
    DATE '9999-12-31',
    true
);
```

## Use Cases

- historical customer attributes
- changing account states
- slowly changing business dimensions
