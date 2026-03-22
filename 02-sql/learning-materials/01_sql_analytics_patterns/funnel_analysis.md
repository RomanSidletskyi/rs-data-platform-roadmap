
cat <<'EOF' > "$MODULE/learning-materials/01_sql_analytics_patterns/retention_analysis.md" <<'EOF'
# Retention Analysis Pattern

## Goal

Measure whether users return after acquisition or first activity.

## Example: Day 1 retention

```sql
WITH first_seen AS (
    SELECT user_id,
           MIN(DATE(event_time)) AS first_day
    FROM events
    GROUP BY user_id
),
activity AS (
    SELECT DISTINCT user_id,
           DATE(event_time) AS activity_day
    FROM events
)
SELECT f.first_day,
       COUNT(DISTINCT f.user_id) AS cohort_size,
       COUNT(DISTINCT a.user_id) AS retained_users
FROM first_seen f
LEFT JOIN activity a
    ON f.user_id = a.user_id
   AND a.activity_day = f.first_day + INTERVAL '1 day'
GROUP BY f.first_day
ORDER BY f.first_day;
```

## Use Cases

- product analytics
- user engagement measurement
- cohort health
- marketing quality analysis
