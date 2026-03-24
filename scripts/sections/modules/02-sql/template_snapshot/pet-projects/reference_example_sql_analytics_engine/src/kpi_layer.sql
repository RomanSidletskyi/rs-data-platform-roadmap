WITH valid_orders AS (
    SELECT
        order_id,
        user_id,
        CAST(order_date AS DATE) AS order_day,
        amount,
        currency
    FROM orders
    WHERE status IN ('paid', 'completed')
),
daily_revenue AS (
    SELECT
        order_day,
        SUM(amount) AS daily_revenue,
        COUNT(*) AS paid_orders,
        COUNT(DISTINCT user_id) AS paying_users
    FROM valid_orders
    GROUP BY order_day
),
customer_revenue AS (
    SELECT
        user_id,
        SUM(amount) AS lifetime_revenue,
        COUNT(*) AS paid_order_count,
        MIN(order_day) AS first_paid_order_day,
        MAX(order_day) AS last_paid_order_day
    FROM valid_orders
    GROUP BY user_id
)
SELECT
    dr.order_day,
    dr.daily_revenue,
    dr.paid_orders,
    dr.paying_users,
    AVG(dr.daily_revenue) OVER (
        ORDER BY dr.order_day
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS moving_avg_7d
FROM daily_revenue AS dr
ORDER BY dr.order_day;

SELECT
    cr.user_id,
    cr.lifetime_revenue,
    cr.paid_order_count,
    cr.first_paid_order_day,
    cr.last_paid_order_day,
    DATEDIFF(cr.last_paid_order_day, cr.first_paid_order_day) AS active_span_days
FROM customer_revenue AS cr
ORDER BY cr.lifetime_revenue DESC;
