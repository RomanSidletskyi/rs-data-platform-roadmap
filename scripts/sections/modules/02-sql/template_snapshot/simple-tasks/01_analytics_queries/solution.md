# 01 Analytics Queries Solution

This file provides reference solutions and reasoning for the analytics tasks.

## Task 1 — Revenue Per Customer

```sql
SELECT
  user_id,
  SUM(amount) AS total_revenue,
  COUNT(*) AS order_count,
  AVG(amount) AS average_order_value,
  MIN(order_date) AS first_order_date,
  MAX(order_date) AS last_order_date
FROM orders
WHERE status IN ('paid', 'completed')
GROUP BY user_id
ORDER BY total_revenue DESC;
```

Key point: define valid revenue-bearing statuses first and keep that filter consistent across every metric.

## Task 2 — Top 10 Products by Revenue

```sql
SELECT
  oi.product_id,
  p.product_name,
  SUM(oi.quantity * oi.item_price) AS total_revenue,
  SUM(oi.quantity) AS total_quantity_sold,
  COUNT(DISTINCT oi.order_id) AS number_of_orders_containing_product
FROM order_items AS oi
LEFT JOIN products AS p
  ON p.product_id = oi.product_id
GROUP BY oi.product_id, p.product_name
ORDER BY total_revenue DESC
LIMIT 10;
```

Key point: revenue belongs at line-item grain, not product grain, so compute it before the aggregation.

## Task 3 — Daily Revenue Trend

```sql
WITH daily_revenue AS (
  SELECT
    CAST(order_date AS DATE) AS revenue_date,
    SUM(amount) AS daily_revenue
  FROM orders
  WHERE status IN ('paid', 'completed')
  GROUP BY CAST(order_date AS DATE)
)
SELECT
  revenue_date,
  daily_revenue,
  AVG(daily_revenue) OVER (
    ORDER BY revenue_date
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  ) AS moving_avg_7d
FROM daily_revenue
ORDER BY revenue_date;
```

Key point: build the daily grain first, then apply the rolling calculation to avoid inflating the moving average.

## Task 4 — Customer Lifetime Value

```sql
SELECT
  user_id,
  SUM(amount) AS lifetime_value,
  COUNT(DISTINCT order_id) AS total_orders,
  AVG(amount) AS average_order_value,
  DATEDIFF(
    MAX(order_date),
    MIN(order_date)
  ) AS active_days_between_first_and_last_order
FROM orders
WHERE status IN ('paid', 'completed')
GROUP BY user_id
ORDER BY lifetime_value DESC;
```

Key point: CLV here is historical realized value, not a predictive model.

## Task 5 — Top Customers Per Country

```sql
WITH country_customer_revenue AS (
  SELECT
    u.country,
    o.user_id,
    SUM(o.amount) AS total_revenue
  FROM users AS u
  INNER JOIN orders AS o
    ON o.user_id = u.user_id
  WHERE o.status IN ('paid', 'completed')
  GROUP BY u.country, o.user_id
), ranked AS (
  SELECT
    country,
    user_id,
    total_revenue,
    ROW_NUMBER() OVER (
      PARTITION BY country
      ORDER BY total_revenue DESC
    ) AS row_number_rank,
    RANK() OVER (
      PARTITION BY country
      ORDER BY total_revenue DESC
    ) AS rank_in_country
  FROM country_customer_revenue
)
SELECT
  country,
  user_id,
  total_revenue,
  rank_in_country
FROM ranked
WHERE row_number_rank <= 3
ORDER BY country, row_number_rank;
```

Key point: use `ROW_NUMBER()` for an exact top 3 cutoff and expose `RANK()` if you also want to discuss ties.

## Task 6 — Average Order Value by Month

```sql
SELECT
  DATE_TRUNC('month', order_date) AS order_month,
  AVG(amount) AS average_order_value,
  COUNT(*) AS monthly_order_count,
  SUM(amount) AS monthly_revenue
FROM orders
WHERE status IN ('paid', 'completed')
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY order_month;
```

## Task 7 — Paid vs Cancelled Order Breakdown

```sql
WITH status_totals AS (
  SELECT
    status,
    COUNT(*) AS order_count,
    SUM(amount) AS total_amount
  FROM orders
  GROUP BY status
)
SELECT
  status,
  order_count,
  total_amount,
  ROUND(100.0 * order_count / SUM(order_count) OVER (), 2) AS order_share_pct
FROM status_totals
ORDER BY order_count DESC;
```

## Task 8 — Product Category Contribution

```sql
WITH category_revenue AS (
  SELECT
    p.category_id,
    p.category_name,
    SUM(oi.quantity * oi.item_price) AS category_revenue
  FROM order_items AS oi
  INNER JOIN products AS p
    ON p.product_id = oi.product_id
  GROUP BY p.category_id, p.category_name
)
SELECT
  category_id,
  category_name,
  category_revenue,
  ROUND(100.0 * category_revenue / SUM(category_revenue) OVER (), 2) AS revenue_share_pct,
  ROW_NUMBER() OVER (ORDER BY category_revenue DESC) AS category_rank,
  ROUND(
    100.0 * SUM(category_revenue) OVER (
      ORDER BY category_revenue DESC
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) / SUM(category_revenue) OVER (),
    2
  ) AS cumulative_revenue_share_pct
FROM category_revenue
ORDER BY category_revenue DESC;
```

## Notes

- Prefer CTEs when they clarify grain changes.
- Keep status filtering identical across all revenue metrics.
- If your SQL engine uses different date or diff functions, adapt syntax but preserve the same logic.
