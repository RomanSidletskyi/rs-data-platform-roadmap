
cat <<'EOF' > "$MODULE/learning-materials/01_sql_analytics_patterns/sessionization.md" <<'EOF'
# Sessionization Pattern

## Goal

Group user events into sessions based on inactivity windows.

## Example

```sql
WITH ordered AS (
    SELECT user_id,
           event_time,
           CASE
               WHEN LAG(event_time) OVER (
                        PARTITION BY user_id
                        ORDER BY event_time
                    ) IS NULL THEN 1
               WHEN event_time
                    - LAG(event_time) OVER (
                        PARTITION BY user_id
                        ORDER BY event_time
                    ) > INTERVAL '30 minutes' THEN 1
               ELSE 0
           END AS new_session
    FROM events
),
numbered AS (
    SELECT user_id,
           event_time,
           SUM(new_session) OVER (
               PARTITION BY user_id
               ORDER BY event_time
               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
           ) AS session_id
    FROM ordered
)
SELECT *
FROM numbered;
```

## Use Cases

- clickstream analytics
- web sessions
- app activity analysis
- user journey reconstruction
