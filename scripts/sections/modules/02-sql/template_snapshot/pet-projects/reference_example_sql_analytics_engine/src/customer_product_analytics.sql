WITH valid_orders AS (
    SELECT
        order_id,
        user_id,
        CAST(order_date AS DATE) AS order_day,
        amount
    FROM orders
    WHERE status IN ('paid', 'completed')
),
country_customer_revenue AS (
    SELECT
        u.country,
        vo.user_id,
        SUM(vo.amount) AS total_revenue
    FROM valid_orders AS vo
    INNER JOIN users AS u
        ON u.user_id = vo.user_id
    GROUP BY u.country, vo.user_id
),
ranked_customers AS (
    SELECT
        country,
        user_id,
        total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY country
            ORDER BY total_revenue DESC
        ) AS country_rank
    FROM country_customer_revenue
),
product_revenue AS (
    SELECT
        p.category_name,
        oi.product_id,
        p.product_name,
        SUM(oi.quantity * oi.item_price) AS total_revenue,
        SUM(oi.quantity) AS total_quantity
    FROM order_items AS oi
    INNER JOIN products AS p
        ON p.product_id = oi.product_id
    GROUP BY p.category_name, oi.product_id, p.product_name
)
SELECT
    country,
    user_id,
    total_revenue,
    country_rank
FROM ranked_customers
WHERE country_rank <= 3
ORDER BY country, country_rank;

SELECT
    category_name,
    product_id,
    product_name,
    total_revenue,
    total_quantity,
    ROW_NUMBER() OVER (
        PARTITION BY category_name
        ORDER BY total_revenue DESC
    ) AS category_rank
FROM product_revenue
ORDER BY category_name, category_rank;
