# Running Totals Pattern

## Goal

Accumulate values over time.

## Example

```sql
SELECT order_date,
       amount,
       SUM(amount) OVER (
           ORDER BY order_date
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_revenue
FROM daily_revenue;
```

## Partitioned Running Total

```sql
SELECT customer_id,
       order_date,
       amount,
       SUM(amount) OVER (
           PARTITION BY customer_id
           ORDER BY order_date
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_customer_revenue
FROM orders;
```

## Use Cases

- cumulative revenue
- cumulative signups
- cumulative errors
- progressive KPIs
