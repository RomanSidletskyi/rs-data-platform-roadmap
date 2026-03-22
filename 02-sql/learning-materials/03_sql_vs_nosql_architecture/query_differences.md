
cat <<'EOF' > "$MODULE/learning-materials/03_sql_vs_nosql_architecture/tradeoffs.md" <<'EOF'
# Trade-Offs

## SQL is Usually Better For

- transactions
- structured business systems
- relational analytics
- strong integrity requirements

## NoSQL is Usually Better For

- flexible schemas
- key-based massive scale
- globally distributed document workloads
- ultra-low-latency operational access

## Common Mistake

Trying to force one storage model into every workload.
