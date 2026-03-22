
cat <<'EOF' > "$MODULE/learning-materials/01_sql_analytics_patterns/practice_queries.md" <<'EOF'
# Practice Queries

1. Find top 5 customers by revenue.
2. Find the latest order per user.
3. Build a 4-step funnel.
4. Compute 7-day retention.
5. Calculate cumulative daily revenue.
6. Produce a monthly cohort table.
7. Deduplicate event stream records.
8. Build an SCD Type 2 dimension for product pricing.

## Guidance

For each query:

- define grain
- define business keys
- define time logic
- define tie-break rules
- define expected output shape
