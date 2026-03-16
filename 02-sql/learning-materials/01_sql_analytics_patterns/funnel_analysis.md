# Funnel Analysis Pattern

## Goal

Measure how users move through sequential steps.

Example funnel:

- view_product
- add_to_cart
- checkout
- payment_success

## Simple Funnel Counts

```sql
SELECT event_name,
       COUNT(DISTINCT user_id) AS users
FROM events
WHERE event_name IN ('view_product', 'add_to_cart', 'checkout', 'payment_success')
GROUP BY event_name;
```

## Ordered Step Funnel

```sql
WITH base AS (
    SELECT user_id,
           MIN(CASE WHEN event_name = 'view_product' THEN event_time END) AS view_time,
           MIN(CASE WHEN event_name = 'add_to_cart' THEN event_time END) AS cart_time,
           MIN(CASE WHEN event_name = 'checkout' THEN event_time END) AS checkout_time,
           MIN(CASE WHEN event_name = 'payment_success' THEN event_time END) AS payment_time
    FROM events
    GROUP BY user_id
)
SELECT COUNT(*) AS total_users,
       COUNT(view_time) AS viewed,
       COUNT(cart_time) AS carted,
       COUNT(checkout_time) AS checked_out,
       COUNT(payment_time) AS paid
FROM base;
```

## Notes

A strong funnel design must define:

- event order
- same-session rule or not
- time window
- unique user logic
