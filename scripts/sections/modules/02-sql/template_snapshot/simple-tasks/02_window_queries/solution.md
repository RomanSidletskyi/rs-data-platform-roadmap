# 02 Window Queries Solution

This file provides reference window-function solutions and highlights the intended grain for each task.

## Task 1 — Rank Orders Per User

```sql
SELECT
  user_id,
  order_id,
  order_date,
  ROW_NUMBER() OVER (
    PARTITION BY user_id
    ORDER BY order_date
  ) AS order_number,
  ROW_NUMBER() OVER (
    PARTITION BY user_id
    ORDER BY order_date DESC
  ) AS reverse_order_number
FROM orders;
```

## Task 2 — Running Customer Revenue

```sql
SELECT
  user_id,
  order_date,
  amount,
  SUM(amount) OVER (
    PARTITION BY user_id
    ORDER BY order_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS running_customer_revenue,
  COUNT(*) OVER (
    PARTITION BY user_id
    ORDER BY order_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS running_order_count
FROM orders
WHERE status IN ('paid', 'completed');
```

## Task 3 — Global Running Revenue

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
  SUM(daily_revenue) OVER (
    ORDER BY revenue_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS running_revenue,
  AVG(daily_revenue) OVER (
    ORDER BY revenue_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS cumulative_avg_daily_revenue
FROM daily_revenue
ORDER BY revenue_date;
```

## Task 4 — 7-Day Moving Average

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
  ) AS moving_avg_7d,
  AVG(daily_revenue) OVER (
    ORDER BY revenue_date
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
  ) AS moving_avg_3d,
  AVG(daily_revenue) OVER (
    ORDER BY revenue_date
    ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
  ) AS moving_avg_30d
FROM daily_revenue
ORDER BY revenue_date;
```

## Task 5 — Previous and Next Order

```sql
SELECT
  user_id,
  order_id,
  order_date,
  LAG(order_date) OVER (
    PARTITION BY user_id
    ORDER BY order_date
  ) AS previous_order_date,
  LEAD(order_date) OVER (
    PARTITION BY user_id
    ORDER BY order_date
  ) AS next_order_date,
  DATEDIFF(
    order_date,
    LAG(order_date) OVER (
      PARTITION BY user_id
      ORDER BY order_date
    )
  ) AS days_since_previous_order
FROM orders;
```

## Task 6 — Latest Record Per Entity

```sql
WITH ranked AS (
  SELECT
    entity_id,
    updated_at,
    payload_version,
    ROW_NUMBER() OVER (
      PARTITION BY entity_id
      ORDER BY updated_at DESC, payload_version DESC
    ) AS row_number_rank
  FROM customer_updates
)
SELECT
  entity_id,
  updated_at,
  payload_version
FROM ranked
WHERE row_number_rank = 1;
```

Key point: when timestamps can tie, add a deterministic second ordering column such as `payload_version` or `event_id`.

## Task 7 — Sessionization Flag

```sql
WITH events_with_lag AS (
  SELECT
    user_id,
    event_time,
    event_name,
    LAG(event_time) OVER (
      PARTITION BY user_id
      ORDER BY event_time
    ) AS previous_event_time
  FROM events
)
SELECT
  user_id,
  event_time,
  previous_event_time,
  CASE
    WHEN previous_event_time IS NULL THEN 1
    WHEN TIMESTAMPDIFF(minute, previous_event_time, event_time) > 30 THEN 1
    ELSE 0
  END AS new_session_flag,
  SUM(
    CASE
      WHEN previous_event_time IS NULL THEN 1
      WHEN TIMESTAMPDIFF(minute, previous_event_time, event_time) > 30 THEN 1
      ELSE 0
    END
  ) OVER (
    PARTITION BY user_id
    ORDER BY event_time
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS session_id
FROM events_with_lag;
```

## Task 8 — Top N Inside Partition

```sql
WITH product_revenue AS (
  SELECT
    p.category_id,
    oi.product_id,
    SUM(oi.quantity * oi.item_price) AS total_revenue
  FROM order_items AS oi
  INNER JOIN products AS p
    ON p.product_id = oi.product_id
  GROUP BY p.category_id, oi.product_id
), ranked AS (
  SELECT
    category_id,
    product_id,
    total_revenue,
    ROW_NUMBER() OVER (
      PARTITION BY category_id
      ORDER BY total_revenue DESC
    ) AS row_number_rank,
    RANK() OVER (
      PARTITION BY category_id
      ORDER BY total_revenue DESC
    ) AS rank_in_category,
    DENSE_RANK() OVER (
      PARTITION BY category_id
      ORDER BY total_revenue DESC
    ) AS dense_rank_in_category
  FROM product_revenue
)
SELECT
  category_id,
  product_id,
  total_revenue,
  rank_in_category
FROM ranked
WHERE row_number_rank <= 5
ORDER BY category_id, row_number_rank;
```

## Notes

- Window functions do not replace grain control; they assume you already selected the right grain.
- Prefer explicit window frames for cumulative and moving metrics.
- In interviews and real projects, explain why you used `ROW_NUMBER`, `RANK`, or `DENSE_RANK`.
