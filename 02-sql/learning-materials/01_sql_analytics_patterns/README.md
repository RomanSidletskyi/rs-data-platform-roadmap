
cat <<'EOF' > "$MODULE/learning-materials/01_sql_analytics_patterns/top_n.md" <<'EOF'
# Top N Pattern

## Goal

Find highest-ranking entities by some metric.

## Example: Top 10 products by revenue

```sql
SELECT product_id,
       SUM(amount) AS revenue
FROM order_items
GROUP BY product_id
ORDER BY revenue DESC
LIMIT 10;
```

## Example: Top 3 products per category

```sql
WITH ranked AS (
    SELECT category_id,
           product_id,
           SUM(amount) AS revenue,
           ROW_NUMBER() OVER (
               PARTITION BY category_id
               ORDER BY SUM(amount) DESC
           ) AS rn
    FROM order_items
    GROUP BY category_id, product_id
)
SELECT *
FROM ranked
WHERE rn <= 3;
```

## Use Cases

- leaderboard analytics
- most valuable customers
- best-selling products
- top campaigns

## Common Mistakes

- using LIMIT globally when partitioned ranking is needed
- forgetting ties behavior
- not choosing ROW_NUMBER vs RANK vs DENSE_RANK intentionally
