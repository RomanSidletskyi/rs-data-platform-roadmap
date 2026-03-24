SELECT
    SUM(amount) AS expected_revenue
FROM orders
WHERE status IN ('paid', 'completed');

SELECT
    SUM(oi.quantity * oi.item_price) AS line_item_revenue
FROM order_items AS oi;

SELECT
    COUNT(*) AS duplicate_order_ids
FROM (
    SELECT order_id
    FROM orders
    GROUP BY order_id
    HAVING COUNT(*) > 1
) AS duplicates;

SELECT
    COUNT(*) AS missing_event_timestamps
FROM events
WHERE event_time IS NULL;
