
cat <<'EOF' > "$MODULE/learning-materials/01_sql_analytics_patterns/cohort_analysis.md" <<'EOF'
# Cohort Analysis Pattern

## Goal

Group users by first activity period and track behavior over time.

## Example

```sql
WITH first_month AS (
    SELECT user_id,
           DATE_TRUNC('month', MIN(event_time)) AS cohort_month
    FROM events
    GROUP BY user_id
),
monthly_activity AS (
    SELECT user_id,
           DATE_TRUNC('month', event_time) AS activity_month
    FROM events
    GROUP BY user_id, DATE_TRUNC('month', event_time)
)
SELECT f.cohort_month,
       m.activity_month,
       COUNT(DISTINCT m.user_id) AS active_users
FROM first_month f
JOIN monthly_activity m
  ON f.user_id = m.user_id
GROUP BY f.cohort_month, m.activity_month
ORDER BY f.cohort_month, m.activity_month;
```

## Use Cases

- retention trends
- product adoption curves
- long-term customer behavior
