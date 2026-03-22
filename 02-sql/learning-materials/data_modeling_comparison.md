
cat <<'EOF' > "$MODULE/learning-materials/indexing_strategy_across_databases.md" <<'EOF'
# Indexing Strategy Across Databases

Indexes are not one universal feature with the same behavior everywhere. They are system-specific mechanisms that accelerate access patterns.

## Core Principle

Indexes should follow actual query patterns.

```text
queries -> indexes
```

Not the other way around.

---

## 1. SQL Databases

Examples:

- PostgreSQL
- SQL Server
- MySQL
- Azure SQL Database

### Common Index Types

- clustered
- non-clustered
- composite
- filtered / partial
- columnstore

### Example

```sql
CREATE INDEX idx_orders_customer_date
ON orders(customer_id, order_date);
```

### Good For

- equality filters
- range filters
- joins
- sorting
- selective lookups

### Bad Uses

- low-selectivity columns
- too many write-heavy indexes
- indexing every column blindly

### Columnstore

Very important for analytics:

```sql
CREATE CLUSTERED COLUMNSTORE INDEX cci_orders
ON orders;
```

Useful for:

- scans
- aggregates
- reporting
- warehouse workloads

---

## 2. MongoDB

MongoDB indexes support document access paths.

### Common Types

- single field
- compound
- multikey
- text
- hashed
- TTL
- geospatial

### Example

```javascript
db.orders.createIndex({ customer_id: 1, order_date: -1 })
```

### Nested Field Index

```javascript
db.orders.createIndex({ "customer.country": 1 })
```

### Array Field Index

```javascript
db.orders.createIndex({ "items.sku": 1 })
```

### Design Guidance

- create indexes for frequent filter paths
- align compound indexes with query order
- avoid index explosion
- understand cardinality and selectivity

### Common Mistakes

- too many indexes
- indexing unused fields
- ignoring sort order in compound indexes
- forgetting nested field indexes

---

## 3. DynamoDB

DynamoDB does not use indexes like relational databases.

### Main Access Structure

- partition key
- sort key

### Secondary Indexes

- GSI: Global Secondary Index
- LSI: Local Secondary Index

### Example

Base table:

- PK = customer_id
- SK = order_timestamp

GSI1:

- GSI1PK = product_id
- GSI1SK = order_timestamp

### Key Truth

In DynamoDB, indexes are part of schema design.

You do not add indexes casually later in the same way as SQL.

### Design Guidance

- start from access patterns
- ensure partition key distribution
- avoid hot partitions
- add GSIs only for real access needs

### Common Mistakes

- weak partition key
- trying to mimic joins
- overusing scans
- too many GSIs

---

## 4. CosmosDB

CosmosDB automatically indexes fields by default.

### Important Implication

Indexing policy directly affects:

- RU cost
- write performance
- query speed
- storage cost

### Design Guidance

- do not blindly index giant payload fields
- optimize indexing policy for workload
- know whether queries are partition-local or cross-partition

### Common Mistakes

- relying on default indexing without review
- bad partition key plus broad indexing
- expensive cross-partition filters

---

## 5. Delta Lake / Lakehouse

Traditional row-level indexes are not the core optimization mechanism.

### Main Optimization Tools

- partitioning
- file pruning
- data skipping
- statistics
- ZORDER

### Example

```sql
OPTIMIZE orders
ZORDER BY (customer_id);
```

### Design Guidance

- partition only on meaningful common filters
- avoid high-cardinality partitions
- optimize small files
- use ZORDER for selective reads

### Common Mistakes

- partitioning by user_id
- too many partitions
- never running optimize
- ignoring file size distribution

---

## Comparison Table

| System | Main Optimization Path |
|---|---|
| SQL | B-tree / columnstore indexes |
| MongoDB | document indexes |
| DynamoDB | PK/SK + GSIs/LSIs |
| CosmosDB | automatic indexing policy |
| Delta Lake | partitioning + skipping + layout |

## Final Rule

The best index is the one that directly supports a high-value query pattern at acceptable write and storage cost.
