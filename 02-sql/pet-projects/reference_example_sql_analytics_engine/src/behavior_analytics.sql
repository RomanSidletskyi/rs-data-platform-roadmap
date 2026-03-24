WITH ordered_events AS (
    SELECT
        user_id,
        session_id,
        event_name,
        event_time,
        ROW_NUMBER() OVER (
            PARTITION BY user_id, event_name
            ORDER BY event_time
        ) AS first_event_rank
    FROM events
),
funnel_users AS (
    SELECT
        event_name,
        COUNT(DISTINCT user_id) AS users_reaching_step
    FROM ordered_events
    WHERE event_name IN ('view_product', 'add_to_cart', 'checkout', 'payment_success')
    GROUP BY event_name
),
first_seen AS (
    SELECT
        user_id,
        MIN(CAST(event_time AS DATE)) AS cohort_day
    FROM events
    GROUP BY user_id
),
activity AS (
    SELECT DISTINCT
        user_id,
        CAST(event_time AS DATE) AS activity_day
    FROM events
)
SELECT
    event_name,
    users_reaching_step
FROM funnel_users
ORDER BY CASE event_name
    WHEN 'view_product' THEN 1
    WHEN 'add_to_cart' THEN 2
    WHEN 'checkout' THEN 3
    WHEN 'payment_success' THEN 4
    ELSE 99
END;

SELECT
    fs.cohort_day,
    COUNT(DISTINCT fs.user_id) AS cohort_size,
    COUNT(DISTINCT a.user_id) AS retained_day_7_users,
    ROUND(
        100.0 * COUNT(DISTINCT a.user_id) / NULLIF(COUNT(DISTINCT fs.user_id), 0),
        2
    ) AS day_7_retention_pct
FROM first_seen AS fs
LEFT JOIN activity AS a
    ON a.user_id = fs.user_id
   AND a.activity_day = fs.cohort_day + INTERVAL '7 day'
GROUP BY fs.cohort_day
ORDER BY fs.cohort_day;
