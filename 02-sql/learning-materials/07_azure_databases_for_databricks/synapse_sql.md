
cat <<'EOF' > "$MODULE/learning-materials/07_azure_databases_for_databricks/synapse_queries.md" <<'EOF'
# Synapse Queries

## Query Parquet from Data Lake

```sql
SELECT *
FROM OPENROWSET(
    BULK 'https://storageaccount.dfs.core.windows.net/data/orders/*.parquet',
    FORMAT='PARQUET'
) AS rows;
```

## Aggregation

```sql
SELECT customer_id,
       SUM(amount) AS total_amount
FROM OPENROWSET(
    BULK 'https://storageaccount.dfs.core.windows.net/data/orders/*.parquet',
    FORMAT='PARQUET'
) AS rows
GROUP BY customer_id;
```

## Delta Query Example

```sql
SELECT *
FROM OPENROWSET(
    BULK 'https://storageaccount.dfs.core.windows.net/lake/delta/orders',
    FORMAT='DELTA'
) AS rows;
```

## Notes

Synapse SQL is useful when the workload is warehouse-like and SQL-first.
