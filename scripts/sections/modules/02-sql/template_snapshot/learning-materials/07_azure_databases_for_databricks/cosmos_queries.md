# CosmosDB Queries

These examples assume SQL API style queries.

## Select all

```sql
SELECT *
FROM c
```

## Equality filter

```sql
SELECT *
FROM c
WHERE c.status = "paid"
```

## Range filter

```sql
SELECT *
FROM c
WHERE c.amount > 100
```

## Projection

```sql
SELECT c.order_id, c.amount
FROM c
```

## Nested field

```sql
SELECT *
FROM c
WHERE c.customer.country = "PL"
```

## Array query

```sql
SELECT *
FROM c
JOIN item IN c.items
WHERE item.sku = "A1"
```

## Count

```sql
SELECT VALUE COUNT(1)
FROM c
WHERE c.status = "paid"
```

## Distinct

```sql
SELECT DISTINCT VALUE c.status
FROM c
```

## Order by

```sql
SELECT *
FROM c
ORDER BY c.order_date DESC
```

## Notes

Always think about:

- partition key usage
- cross-partition cost
- RU consumption
