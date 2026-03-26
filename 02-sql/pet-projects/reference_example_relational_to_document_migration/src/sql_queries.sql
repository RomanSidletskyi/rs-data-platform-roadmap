SELECT
    o.order_id,
    o.order_date,
    o.status,
    o.amount,
    oi.product_id,
    p.product_name,
    oi.quantity,
    oi.item_price,
    pay.payment_status
FROM orders AS o
INNER JOIN order_items AS oi
    ON oi.order_id = o.order_id
INNER JOIN products AS p
    ON p.product_id = oi.product_id
LEFT JOIN payments AS pay
    ON pay.order_id = o.order_id
WHERE o.order_id = 101;

SELECT
    u.user_id,
    o.order_id,
    o.order_date,
    o.amount,
    o.status
FROM users AS u
INNER JOIN orders AS o
    ON o.user_id = u.user_id
WHERE u.user_id = 10
ORDER BY o.order_date DESC;

SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity * oi.item_price) AS total_sales
FROM products AS p
INNER JOIN order_items AS oi
    ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_sales DESC;
