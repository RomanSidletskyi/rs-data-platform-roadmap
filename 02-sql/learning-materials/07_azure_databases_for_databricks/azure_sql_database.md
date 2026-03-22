
cat <<'EOF' > "$MODULE/learning-materials/07_azure_databases_for_databricks/azure_sql_indexes.md" <<'EOF'
# Azure SQL Indexes

## Clustered Index

```sql
CREATE CLUSTERED INDEX idx_orders_date
ON orders(order_date);
```

## Nonclustered Index

```sql
CREATE INDEX idx_orders_customer
ON orders(customer_id);
```

## Composite Index

```sql
CREATE INDEX idx_orders_customer_date
ON orders(customer_id, order_date);
```

## Filtered Index

```sql
CREATE INDEX idx_active_orders
ON orders(status)
WHERE status = 'active';
```

## Columnstore Index

```sql
CREATE CLUSTERED COLUMNSTORE INDEX cci_orders
ON orders;
```

## Strong Points

- strong optimizer support
- mature indexing model
- columnstore for analytics-style reads
- good balance between OLTP and reporting in moderate workloads
