#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="02-sql-fill-learning-materials"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "02-sql")"

log "Creating learning materials README..."

cat <<'EOF' > "$MODULE/learning-materials/README.md"
# 02-sql Learning Materials

This module is designed for a strong SQL engineer who already knows relational systems well and wants to expand into:

- analytics query patterns
- lakehouse SQL
- SQL vs NoSQL architecture
- document database modeling
- MongoDB
- DynamoDB
- Azure databases for Databricks
- cross-database design thinking

This module intentionally avoids repeating SQL basics and instead focuses on architecture, modeling, query practice, and production-oriented patterns.

## Main Goals

By the end of this module, the learner should be able to:

- use advanced SQL patterns for analytics
- understand how SQL changes in lakehouse systems
- compare relational and NoSQL systems
- model documents for MongoDB and CosmosDB
- design access-pattern-driven schemas for DynamoDB
- understand Azure SQL, CosmosDB, and Synapse in Databricks-oriented architecture
- compare query patterns across systems
- choose the right storage model for the right workload

## Learning Philosophy

This module focuses on:

- real engineering patterns
- architectural trade-offs
- production-oriented data modeling
- practical query references
- platform integration
EOF

cat <<'EOF' > "$MODULE/learning-materials/query_pattern_cheatsheet.md"
# Query Pattern Cheat Sheet

This file compares common query patterns across SQL, MongoDB, DynamoDB, and CosmosDB.

---

## 1. Read all rows / documents

### SQL
```sql
SELECT *
FROM orders;
```

### MongoDB
```python
list(db.orders.find({}))
```

### DynamoDB
```python
table.scan()
```

### CosmosDB
```sql
SELECT *
FROM c
```

---

## 2. Equality filter

### SQL
```sql
SELECT *
FROM orders
WHERE status = 'paid';
```

### MongoDB
```python
list(db.orders.find({"status": "paid"}))
```

### DynamoDB
```python
from boto3.dynamodb.conditions import Key

table.query(
    KeyConditionExpression=Key("pk").eq("CUSTOMER#100")
)
```

### CosmosDB
```sql
SELECT *
FROM c
WHERE c.status = "paid"
```

---

## 3. Range filter

### SQL
```sql
SELECT *
FROM orders
WHERE amount > 100;
```

### MongoDB
```python
list(db.orders.find({"amount": {"$gt": 100}}))
```

### DynamoDB

Range filters are natural on the sort key.

```python
table.query(
    KeyConditionExpression=
        Key("pk").eq("CUSTOMER#100") &
        Key("sk").begins_with("ORDER#2025")
)
```

### CosmosDB
```sql
SELECT *
FROM c
WHERE c.amount > 100
```

---

## 4. Projection

### SQL
```sql
SELECT order_id, amount
FROM orders;
```

### MongoDB
```python
list(db.orders.find({}, {"_id": 0, "order_id": 1, "amount": 1}))
```

### DynamoDB
```python
table.scan(ProjectionExpression="order_id, amount")
```

### CosmosDB
```sql
SELECT c.order_id, c.amount
FROM c
```

---

## 5. Sorting

### SQL
```sql
SELECT *
FROM orders
ORDER BY amount DESC;
```

### MongoDB
```python
list(db.orders.find({}).sort("amount", -1))
```

### DynamoDB

Sorting is driven by the sort key inside a partition.

```python
table.query(
    KeyConditionExpression=Key("pk").eq("CUSTOMER#100"),
    ScanIndexForward=False
)
```

### CosmosDB
```sql
SELECT *
FROM c
ORDER BY c.amount DESC
```

---

## 6. Limit

### SQL
```sql
SELECT *
FROM orders
LIMIT 10;
```

### MongoDB
```python
list(db.orders.find({}).limit(10))
```

### DynamoDB
```python
table.scan(Limit=10)
```

### CosmosDB
```sql
SELECT TOP 10 *
FROM c
```

---

## 7. Distinct

### SQL
```sql
SELECT DISTINCT status
FROM orders;
```

### MongoDB
```python
db.orders.distinct("status")
```

### DynamoDB

There is no direct DISTINCT operator. Usually solved by:
- model design
- derived tables/items
- downstream analytics

### CosmosDB
```sql
SELECT DISTINCT VALUE c.status
FROM c
```

---

## 8. Count

### SQL
```sql
SELECT COUNT(*)
FROM orders;
```

### MongoDB
```python
db.orders.count_documents({})
```

### DynamoDB
```python
table.scan(Select="COUNT")
```

### CosmosDB
```sql
SELECT VALUE COUNT(1)
FROM c
```

---

## 9. Aggregation / Group By

### SQL
```sql
SELECT customer_id, SUM(amount) AS total_amount
FROM orders
GROUP BY customer_id;
```

### MongoDB
```python
list(db.orders.aggregate([
    {
        "$group": {
            "_id": "$customer_id",
            "total_amount": {"$sum": "$amount"}
        }
    }
]))
```

### DynamoDB

Not a natural aggregation engine. Usually solved with:
- precomputed aggregates
- stream processing
- materialized items
- Spark / Databricks / Athena analytics

### CosmosDB
```sql
SELECT c.customer_id, SUM(c.amount) AS total_amount
FROM c
GROUP BY c.customer_id
```

---

## 10. Join

### SQL
```sql
SELECT o.order_id, c.customer_name
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id;
```

### MongoDB
```python
list(db.orders.aggregate([
    {
        "$lookup": {
            "from": "customers",
            "localField": "customer_id",
            "foreignField": "customer_id",
            "as": "customer"
        }
    }
]))
```

### DynamoDB

No joins. Data model must support required access patterns directly.

### CosmosDB

Joins are not relational cross-container joins in the SQL sense. Query design is document-oriented.

---

## 11. Pagination

### SQL
```sql
SELECT *
FROM orders
ORDER BY order_id
LIMIT 10 OFFSET 20;
```

### MongoDB
```python
list(db.orders.find({}).sort("order_id", 1).skip(20).limit(10))
```

### DynamoDB

Pagination uses `LastEvaluatedKey`.

### CosmosDB

Pagination uses continuation tokens.

---

## 12. Key Design Rules

### SQL
- normalize when needed
- index real query paths
- use columnstore for analytics

### MongoDB
- model for read patterns
- embed related data where practical
- avoid excessive lookup-heavy designs

### DynamoDB
- schema follows access patterns
- partition key quality is critical
- GSIs must be intentional

### CosmosDB
- partition key drives scale and cost
- cross-partition queries are expensive
- document shape matters
EOF

cat <<'EOF' > "$MODULE/learning-materials/data_modeling_comparison.md" <<'EOF'
# Data Modeling Comparison

This file shows how the same business domain can be modeled in different storage systems.

## Example Domain

E-commerce:

- users
- orders
- order_items
- payments
- products
- clickstream events

---

## 1. SQL Model

### Tables

- users
- orders
- order_items
- products
- payments

### Characteristics

- normalized model
- joins are natural
- strong transactional consistency
- good for OLTP and structured analytics

### Example

```sql
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    email VARCHAR(255),
    country VARCHAR(50)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    order_date TIMESTAMP,
    status VARCHAR(50),
    amount DECIMAL(12,2)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    item_price DECIMAL(12,2)
);
```

### Best For

- transactional applications
- structured business data
- reporting with joins
- strong ACID guarantees

---

## 2. MongoDB Model

### Design Idea

Store related data together when it improves read patterns.

### Example Document

```json
{
  "order_id": 101,
  "user_id": 10,
  "order_date": "2025-01-10T12:00:00Z",
  "status": "paid",
  "amount": 450,
  "items": [
    {
      "product_id": 1001,
      "product_name": "Laptop",
      "quantity": 1,
      "item_price": 400
    },
    {
      "product_id": 1002,
      "product_name": "Mouse",
      "quantity": 1,
      "item_price": 50
    }
  ],
  "payment": {
    "method": "card",
    "status": "captured"
  }
}
```

### Characteristics

- denormalized
- optimized for document reads
- nested structures are natural
- embedding reduces joins

### Best For

- flexible JSON-like data
- product catalogs
- event payloads
- fast application reads

### Risks

- document growth
- duplicated data
- overuse of lookup
- weak schema governance

---

## 3. DynamoDB Model

### Design Idea

Schema is built from access patterns, not from entities.

### Example Access Patterns

- get all orders for one customer
- get latest orders for a customer
- get all orders for one product
- get daily order summary

### Example Item Structure

```json
{
  "pk": "CUSTOMER#10",
  "sk": "ORDER#2025-01-10T12:00:00Z#101",
  "entity_type": "ORDER",
  "order_id": 101,
  "status": "paid",
  "amount": 450
}
```

### GSI Example

```json
{
  "gsi1pk": "PRODUCT#1001",
  "gsi1sk": "ORDER#2025-01-10T12:00:00Z#101"
}
```

### Characteristics

- access-pattern driven
- no joins
- partition key design is critical
- single-table design is common

### Best For

- high-scale key-based access
- event or activity timelines
- low-latency operational systems

### Risks

- hard to redesign later
- poor PK choice causes hot partitions
- ad hoc analytics are weak
- scans are expensive and often the wrong tool

---

## 4. CosmosDB Model

### Design Idea

Document database with partition-aware distribution.

### Example Document

```json
{
  "id": "101",
  "customer_id": "10",
  "type": "order",
  "order_date": "2025-01-10T12:00:00Z",
  "status": "paid",
  "amount": 450,
  "items": [
    {
      "product_id": "1001",
      "quantity": 1,
      "item_price": 400
    }
  ]
}
```

### Partition Key

```text
/customer_id
```

### Characteristics

- JSON documents
- partition key drives routing and cost
- global distribution available
- supports multiple APIs

### Best For

- globally distributed apps
- operational document workloads
- microservice backends
- semi-structured data

### Risks

- bad partition key = expensive queries
- cross-partition queries increase RU costs
- indexing policy matters

---

## 5. Lakehouse / Delta Model

### Design Idea

Store analytics-ready data in files and tables optimized for large-scale processing.

### Bronze / Silver / Gold

- bronze: raw ingestion
- silver: cleaned and standardized
- gold: business-level analytics tables

### Example Delta Table

```sql
CREATE TABLE silver_orders (
    order_id BIGINT,
    user_id BIGINT,
    order_date TIMESTAMP,
    status STRING,
    amount DECIMAL(12,2)
)
USING DELTA
PARTITIONED BY (status);
```

### Characteristics

- large-scale analytics
- batch and streaming support
- schema evolution
- time travel
- merge/upsert patterns

### Best For

- analytics
- data engineering pipelines
- ML feature preparation
- lakehouse architectures

### Risks

- poor partition strategy
- too many small files
- weak optimization hygiene
- trying to use it like OLTP

---

## Comparison Summary

| System | Modeling Style | Strength | Weakness |
|---|---|---|---|
| SQL | normalized relational | joins, transactions | rigid scaling patterns in some workloads |
| MongoDB | document-oriented | flexible nested reads | duplicated data, growth risk |
| DynamoDB | access-pattern driven | scale and low latency | difficult modeling |
| CosmosDB | partitioned document | global distribution | partition/cost pitfalls |
| Delta Lake | analytics tables/files | scale and analytics | not OLTP |

## Main Rule

Choose the model based on:

- access patterns
- consistency needs
- scale requirements
- analytics needs
- cost profile
- operational complexity
EOF

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
EOF

cat <<'EOF' > "$MODULE/learning-materials/01_sql_analytics_patterns/README.md" <<'EOF'
# 01 SQL Analytics Patterns

This section contains practical SQL patterns used in analytics and data engineering.

## Why This Matters

Strong SQL syntax knowledge is not enough for data platform work. Real projects require reusable patterns for:

- deduplication
- top-N analysis
- retention
- funnels
- running totals
- cohort analysis
- slowly changing dimensions
- anomaly investigation

## What You Need to Learn

- how to structure analytics queries
- how to use window functions effectively
- how to build reusable patterns
- how to translate business questions into query templates

## Files

- top_n.md
- deduplication.md
- sessionization.md
- funnel_analysis.md
- retention_analysis.md
- running_totals.md
- cohort_analysis.md
- scd_type2.md
- practice_queries.md
EOF

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
EOF

cat <<'EOF' > "$MODULE/learning-materials/01_sql_analytics_patterns/deduplication.md" <<'EOF'
# Deduplication Pattern

## Goal

Keep only one row per business key.

## Latest record per user

```sql
WITH ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY user_id
               ORDER BY updated_at DESC
           ) AS rn
    FROM users_raw
)
SELECT *
FROM ranked
WHERE rn = 1;
```

## Keep latest event per order

```sql
WITH ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY order_id
               ORDER BY event_time DESC
           ) AS rn
    FROM order_events
)
SELECT *
FROM ranked
WHERE rn = 1;
```

## Use Cases

- CDC ingestion
- bronze to silver transformations
- event stream cleanup
- removing duplicates after retries

## Notes

A deduplication strategy must define:

- business key
- tie breaker
- deterministic ordering
EOF

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
EOF

cat <<'EOF' > "$MODULE/learning-materials/01_sql_analytics_patterns/funnel_analysis.md" <<'EOF'
# Funnel Analysis Pattern

## Goal

Measure how users move through sequential steps.

Example funnel:

- view_product
- add_to_cart
- checkout
- payment_success

## Simple Funnel Counts

```sql
SELECT event_name,
       COUNT(DISTINCT user_id) AS users
FROM events
WHERE event_name IN ('view_product', 'add_to_cart', 'checkout', 'payment_success')
GROUP BY event_name;
```

## Ordered Step Funnel

```sql
WITH base AS (
    SELECT user_id,
           MIN(CASE WHEN event_name = 'view_product' THEN event_time END) AS view_time,
           MIN(CASE WHEN event_name = 'add_to_cart' THEN event_time END) AS cart_time,
           MIN(CASE WHEN event_name = 'checkout' THEN event_time END) AS checkout_time,
           MIN(CASE WHEN event_name = 'payment_success' THEN event_time END) AS payment_time
    FROM events
    GROUP BY user_id
)
SELECT COUNT(*) AS total_users,
       COUNT(view_time) AS viewed,
       COUNT(cart_time) AS carted,
       COUNT(checkout_time) AS checked_out,
       COUNT(payment_time) AS paid
FROM base;
```

## Notes

A strong funnel design must define:

- event order
- same-session rule or not
- time window
- unique user logic
EOF

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
EOF

cat <<'EOF' > "$MODULE/learning-materials/01_sql_analytics_patterns/running_totals.md" <<'EOF'
# Running Totals Pattern

## Goal

Accumulate values over time.

## Example

```sql
SELECT order_date,
       amount,
       SUM(amount) OVER (
           ORDER BY order_date
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_revenue
FROM daily_revenue;
```

## Partitioned Running Total

```sql
SELECT customer_id,
       order_date,
       amount,
       SUM(amount) OVER (
           PARTITION BY customer_id
           ORDER BY order_date
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_customer_revenue
FROM orders;
```

## Use Cases

- cumulative revenue
- cumulative signups
- cumulative errors
- progressive KPIs
EOF

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
EOF

cat <<'EOF' > "$MODULE/learning-materials/01_sql_analytics_patterns/scd_type2.md" <<'EOF'
# SCD Type 2 Pattern

## Goal

Track historical changes to dimension attributes.

## Example Dimension Columns

- customer_id
- customer_name
- country
- valid_from
- valid_to
- is_current

## Insert New Version Logic

```sql
UPDATE dim_customer
SET valid_to = CURRENT_DATE - INTERVAL '1 day',
    is_current = false
WHERE customer_id = 100
  AND is_current = true;

INSERT INTO dim_customer (
    customer_id,
    customer_name,
    country,
    valid_from,
    valid_to,
    is_current
)
VALUES (
    100,
    'Alice',
    'PL',
    CURRENT_DATE,
    DATE '9999-12-31',
    true
);
```

## Use Cases

- historical customer attributes
- changing account states
- slowly changing business dimensions
EOF

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
EOF

cat <<'EOF' > "$MODULE/learning-materials/02_sql_for_lakehouse/README.md" <<'EOF'
# 02 SQL for Lakehouse

This section focuses on SQL patterns specific to modern data platforms built on Delta Lake and Databricks-style architectures.

## Why This Matters

SQL in a lakehouse is not the same as SQL in OLTP systems.

Here SQL is used for:

- large-scale analytics
- file-backed transactional tables
- merge/upsert workflows
- schema evolution
- incremental pipelines
- historical snapshots

## Files

- delta_tables.md
- merge_operations.md
- partitioning.md
- time_travel.md
- schema_evolution.md
- optimization_patterns.md
- practice_queries.md
EOF

cat <<'EOF' > "$MODULE/learning-materials/02_sql_for_lakehouse/delta_tables.md" <<'EOF'
# Delta Tables

## What They Are

Delta tables provide:

- ACID transactions on data lake storage
- schema enforcement
- time travel
- merge support
- scalable reads and writes

## Example

```sql
CREATE TABLE silver_orders (
    order_id BIGINT,
    customer_id BIGINT,
    order_date TIMESTAMP,
    status STRING,
    amount DECIMAL(12,2)
)
USING DELTA;
```

## Why Important

Delta tables are a core abstraction for lakehouse architectures.
EOF

cat <<'EOF' > "$MODULE/learning-materials/02_sql_for_lakehouse/merge_operations.md" <<'EOF'
# Merge Operations

## Goal

Perform upserts and synchronized loads.

## Example

```sql
MERGE INTO silver_orders t
USING staged_orders s
ON t.order_id = s.order_id
WHEN MATCHED THEN UPDATE SET
    t.customer_id = s.customer_id,
    t.order_date = s.order_date,
    t.status = s.status,
    t.amount = s.amount
WHEN NOT MATCHED THEN INSERT (
    order_id, customer_id, order_date, status, amount
) VALUES (
    s.order_id, s.customer_id, s.order_date, s.status, s.amount
);
```

## Use Cases

- CDC ingestion
- incremental loads
- deduplicated upserts
- dimension maintenance
EOF

cat <<'EOF' > "$MODULE/learning-materials/02_sql_for_lakehouse/partitioning.md" <<'EOF'
# Partitioning

## Purpose

Partitioning reduces the amount of data scanned when queries filter on partition columns.

## Example

```sql
CREATE TABLE gold_daily_orders
USING DELTA
PARTITIONED BY (order_date)
AS
SELECT *
FROM silver_orders;
```

## Good Partition Columns

- low to medium cardinality
- common filter usage
- stable values

## Bad Partition Columns

- user_id
- order_id
- highly unique keys

## Main Warning

Over-partitioning creates too many small files and hurts performance.
EOF

cat <<'EOF' > "$MODULE/learning-materials/02_sql_for_lakehouse/time_travel.md" <<'EOF'
# Time Travel

## Goal

Read previous versions of Delta tables.

## Example: By version

```sql
SELECT *
FROM silver_orders VERSION AS OF 10;
```

## Example: By timestamp

```sql
SELECT *
FROM silver_orders TIMESTAMP AS OF '2025-01-01T12:00:00Z';
```

## Use Cases

- debugging bad loads
- reproducible analytics
- historical comparisons
- rollback support
EOF

cat <<'EOF' > "$MODULE/learning-materials/02_sql_for_lakehouse/schema_evolution.md" <<'EOF'
# Schema Evolution

## Problem

Data changes over time:

- new columns appear
- types evolve
- source payloads drift

## Lakehouse Need

A scalable platform must handle schema change intentionally.

## Common Practices

- enforce schema in curated layers
- allow controlled evolution in ingestion layers
- add audit logic around schema changes
- document table contracts

## Main Trade-Off

Too strict:
- breaks ingestion often

Too loose:
- creates schema chaos
EOF

cat <<'EOF' > "$MODULE/learning-materials/02_sql_for_lakehouse/optimization_patterns.md" <<'EOF'
# Optimization Patterns

## Main Patterns

- optimize file sizes
- use partition pruning
- use ZORDER
- avoid excessive small files
- cluster for common filters
- filter early in transformations

## Example

```sql
OPTIMIZE silver_orders
ZORDER BY (customer_id);
```

## Important

Optimization in lakehouse systems is often more about:

- file layout
- metadata
- scan reduction

than about classic row-store indexing.
EOF

cat <<'EOF' > "$MODULE/learning-materials/02_sql_for_lakehouse/practice_queries.md" <<'EOF'
# Practice Queries

1. Create a Delta table for orders.
2. Load bronze data into silver data.
3. Perform a MERGE from updates table.
4. Query historical table state using time travel.
5. Compare performance before and after partitioning.
6. Use ZORDER on a common filter column.
EOF

cat <<'EOF' > "$MODULE/learning-materials/03_sql_vs_nosql_architecture/README.md" <<'EOF'
# 03 SQL vs NoSQL Architecture

This section compares relational and NoSQL systems from an engineering and architecture perspective.

## Goal

Understand:

- where SQL is strong
- where NoSQL is strong
- what changes in data modeling
- what changes in querying
- what changes in consistency and scaling

## Files

- architecture.md
- consistency_and_scaling.md
- modeling_differences.md
- query_differences.md
- tradeoffs.md
- practice_comparisons.md
EOF

cat <<'EOF' > "$MODULE/learning-materials/03_sql_vs_nosql_architecture/architecture.md" <<'EOF'
# Architecture

## Relational Architecture

Typical structure:

Application
-> SQL engine
-> tables
-> indexes
-> transactional storage

### Strong Sides

- transactions
- joins
- integrity constraints
- strong consistency

## NoSQL Architecture

Typical structure:

Application
-> API / query layer
-> distributed partitions
-> document or key-value storage

### Strong Sides

- horizontal scaling
- flexible schema
- workload-specific design
- very high throughput in some systems

## Key Difference

SQL centers around relational structure.

NoSQL often centers around:

- documents
- keys
- partitions
- access patterns
EOF

cat <<'EOF' > "$MODULE/learning-materials/03_sql_vs_nosql_architecture/consistency_and_scaling.md" <<'EOF'
# Consistency and Scaling

## SQL Systems

Common focus:

- ACID transactions
- strong consistency
- normalized updates
- vertical scale first, horizontal scale depending on engine

## NoSQL Systems

Common focus:

- distribution
- scalability
- eventual consistency in many systems
- partition-based availability

## Engineering Trade-Off

You usually trade between:

- strict correctness guarantees
- write/read latency
- global distribution
- operational simplicity
EOF

cat <<'EOF' > "$MODULE/learning-materials/03_sql_vs_nosql_architecture/modeling_differences.md" <<'EOF'
# Modeling Differences

## SQL Modeling

Start with:

- entities
- relationships
- normalization
- constraints

## NoSQL Modeling

Start with:

- access patterns
- document boundaries
- partition strategy
- denormalization needs

## SQL Question

What are the entities and relationships?

## NoSQL Question

How will this data be queried and scaled?
EOF

cat <<'EOF' > "$MODULE/learning-materials/03_sql_vs_nosql_architecture/query_differences.md" <<'EOF'
# Query Differences

## SQL

Rich declarative language:

- joins
- window functions
- group by
- subqueries
- CTEs

## MongoDB

Document-oriented:

- find filters
- projections
- aggregation pipeline
- nested fields
- array operations

## DynamoDB

Key-based:

- query by PK/SK
- GSIs
- scans are discouraged
- no joins

## CosmosDB

Document SQL-like:

- JSON field access
- partition-aware behavior
- limited compared to full relational SQL
EOF

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
EOF

cat <<'EOF' > "$MODULE/learning-materials/03_sql_vs_nosql_architecture/practice_comparisons.md" <<'EOF'
# Practice Comparisons

## Example 1: Customer Orders

### SQL
Use normalized tables and joins.

### MongoDB
Embed order items inside order documents.

### DynamoDB
Store orders under customer partition.

### CosmosDB
Use customer_id as partition key and model orders as JSON documents.

## Example 2: Product Catalog

### SQL
Good for structured product relationships.

### MongoDB
Good for flexible product attributes.

### DynamoDB
Good if access patterns are simple and key-based.

### CosmosDB
Good for distributed microservice catalog APIs.

## Exercise

For each use case, decide:

- dominant read pattern
- write pattern
- scaling requirement
- consistency need
- best storage fit
EOF

cat <<'EOF' > "$MODULE/learning-materials/04_document_database_modeling/README.md" <<'EOF'
# 04 Document Database Modeling

This section focuses on document-oriented schema design.

## Why This Matters

SQL engineers often know normalization deeply, but document stores require a different design mindset.

In document databases, the critical questions are:

- what gets read together
- what changes together
- what should be embedded
- what should be referenced
- what should be partitioned together

## Files

- embedding_vs_referencing.md
- access_patterns.md
- denormalization.md
- schema_design.md
- anti_patterns.md
- modeling_exercises.md
EOF

cat <<'EOF' > "$MODULE/learning-materials/04_document_database_modeling/embedding_vs_referencing.md" <<'EOF'
# Embedding vs Referencing

## Embedding

Use embedding when:

- child data is read together with parent
- child data is bounded in size
- updates happen together
- document growth is predictable

### Example

Order with order items embedded.

## Referencing

Use referencing when:

- child data is large or unbounded
- child data is reused by many parents
- update frequency differs
- independent lifecycle matters

### Example

Product catalog referenced from order items.

## Rule of Thumb

Embed for locality.
Reference for independence.
EOF

cat <<'EOF' > "$MODULE/learning-materials/04_document_database_modeling/access_patterns.md" <<'EOF'
# Access Patterns

Document schema design should start with access patterns.

## Examples

- get order by order_id
- get all recent orders for customer
- get product details
- get latest session events for user

## Main Rule

Model around what the application reads and writes most often.

Not around a normalized ER diagram.
EOF

cat <<'EOF' > "$MODULE/learning-materials/04_document_database_modeling/denormalization.md" <<'EOF'
# Denormalization

Denormalization is not a mistake in document systems. It is often intentional.

## Benefits

- fewer joins
- faster reads
- simpler document retrieval

## Risks

- duplicated data
- update fan-out
- inconsistency if not managed well

## Good Practice

Duplicate only what is needed for high-value reads.
EOF

cat <<'EOF' > "$MODULE/learning-materials/04_document_database_modeling/schema_design.md" <<'EOF'
# Schema Design

## Main Questions

- what is the document boundary
- what grows unbounded
- which fields are queried often
- which fields need indexes
- which fields define partition placement

## Example

For an order document:

- embed order items
- maybe embed payment summary
- reference very large audit history
EOF

cat <<'EOF' > "$MODULE/learning-materials/04_document_database_modeling/anti_patterns.md" <<'EOF'
# Anti-Patterns

## Common Mistakes

- using document DB as if it were a normalized relational DB
- overusing joins / lookups
- creating giant unbounded arrays
- ignoring index design
- ignoring partition strategy
- storing multiple unrelated access patterns in one poor document shape
EOF

cat <<'EOF' > "$MODULE/learning-materials/04_document_database_modeling/modeling_exercises.md" <<'EOF'
# Modeling Exercises

1. Model users + orders in MongoDB.
2. Model sessions + events in MongoDB.
3. Model product catalog with flexible attributes.
4. Decide when to embed payment data vs reference it.
5. Compare the same domain in SQL vs document model.
EOF

cat <<'EOF' > "$MODULE/learning-materials/05_mongodb/README.md" <<'EOF'
# 05 MongoDB

This section covers MongoDB from a data engineering and architecture perspective.

## Main Topics

- architecture
- Python setup
- query patterns
- aggregation
- indexing
- data modeling
- MongoDB vs SQL

MongoDB should be learned here as:

- a document database
- a queryable operational store
- a system that depends heavily on good schema and index design
EOF

cat <<'EOF' > "$MODULE/learning-materials/05_mongodb/python_setup.md" <<'EOF'
# Python Setup

## Local Setup

```python
from pymongo import MongoClient
from pprint import pprint

client = MongoClient("mongodb://localhost:27017/")
db = client["learning_db"]
orders = db["orders"]

def show(cursor):
    for doc in cursor:
        pprint(doc)
```

## Atlas Setup

```python
from pymongo import MongoClient

client = MongoClient("mongodb+srv://<username>:<password>@cluster.mongodb.net/")
db = client["learning_db"]
orders = db["orders"]
```

## Why Python First

Using MongoDB through Python is closer to real application and data engineering workflows than using shell-only examples.
EOF

cat <<'EOF' > "$MODULE/learning-materials/05_mongodb/queries.md" <<'EOF'
# MongoDB Queries

This file presents MongoDB query patterns through Python.

## Read all documents

```python
show(orders.find({}))
```

## Equality filter

```python
show(orders.find({"status": "paid"}))
```

## Range filter

```python
show(orders.find({"amount": {"$gt": 100}}))
```

## Combined filter

```python
show(orders.find({
    "status": "paid",
    "amount": {"$gte": 100}
}))
```

## OR filter

```python
show(orders.find({
    "$or": [
        {"status": "paid"},
        {"status": "shipped"}
    ]
}))
```

## Projection

```python
show(orders.find(
    {"status": "paid"},
    {"_id": 0, "order_id": 1, "amount": 1}
))
```

## Sort ascending

```python
show(orders.find({}).sort("amount", 1))
```

## Sort descending

```python
show(orders.find({}).sort("amount", -1))
```

## Limit

```python
show(orders.find({}).limit(5))
```

## Pagination

```python
show(orders.find({}).sort("order_id", 1).skip(10).limit(5))
```

## Count

```python
print(orders.count_documents({"status": "paid"}))
```

## Distinct

```python
print(orders.distinct("status"))
```

## IN

```python
show(orders.find({"status": {"$in": ["paid", "shipped"]}}))
```

## NOT IN

```python
show(orders.find({"status": {"$nin": ["failed", "cancelled"]}}))
```

## Field exists

```python
show(orders.find({"discount_code": {"$exists": True}}))
```

## Field missing

```python
show(orders.find({"discount_code": {"$exists": False}}))
```

## Regex / LIKE analogue

```python
show(orders.find({"customer_email": {"$regex": "gmail", "$options": "i"}}))
```

## Nested field

```python
show(orders.find({"customer.country": "UA"}))
```

## Array membership

```python
show(orders.find({"tags": "priority"}))
```

## Array all

```python
show(orders.find({"tags": {"$all": ["electronics", "priority"]}}))
```

## elemMatch

```python
show(orders.find({
    "items": {
        "$elemMatch": {
            "sku": "A1",
            "qty": {"$gte": 2}
        }
    }
}))
```

## Insert one

```python
orders.insert_one({
    "order_id": 101,
    "status": "paid",
    "amount": 250
})
```

## Insert many

```python
orders.insert_many([
    {"order_id": 102, "status": "new", "amount": 120},
    {"order_id": 103, "status": "paid", "amount": 300}
])
```

## Update one

```python
orders.update_one(
    {"order_id": 101},
    {"$set": {"status": "shipped"}}
)
```

## Update many

```python
orders.update_many(
    {"status": "new"},
    {"$set": {"status": "processing"}}
)
```

## Increment field

```python
orders.update_one(
    {"order_id": 101},
    {"$inc": {"retry_count": 1}}
)
```

## Rename field

```python
orders.update_many(
    {},
    {"$rename": {"amount": "total_amount"}}
)
```

## Unset field

```python
orders.update_many(
    {},
    {"$unset": {"temporary_field": ""}}
)
```

## Upsert

```python
orders.update_one(
    {"order_id": 999},
    {"$set": {"status": "new", "amount": 100}},
    upsert=True
)
```

## Delete one

```python
orders.delete_one({"order_id": 101})
```

## Delete many

```python
orders.delete_many({"status": "cancelled"})
```

## Common Mistakes

- using MongoDB like normalized SQL
- overusing lookup
- missing indexes on real filter fields
- storing unbounded arrays
- ignoring document growth
EOF

cat <<'EOF' > "$MODULE/learning-materials/05_mongodb/aggregation.md" <<'EOF'
# MongoDB Aggregation

Aggregation pipeline is the main analytical mechanism in MongoDB.

## Group by status

```python
pipeline = [
    {
        "$group": {
            "_id": "$status",
            "total_amount": {"$sum": "$amount"},
            "count": {"$sum": 1}
        }
    }
]

show(orders.aggregate(pipeline))
```

## Match then group

```python
pipeline = [
    {"$match": {"status": "paid"}},
    {
        "$group": {
            "_id": "$customer_id",
            "total_amount": {"$sum": "$amount"}
        }
    }
]

show(orders.aggregate(pipeline))
```

## Project

```python
pipeline = [
    {
        "$project": {
            "_id": 0,
            "order_id": 1,
            "amount": 1,
            "amount_with_tax": {"$multiply": ["$amount", 1.2]}
        }
    }
]

show(orders.aggregate(pipeline))
```

## Sort and limit

```python
pipeline = [
    {"$sort": {"amount": -1}},
    {"$limit": 5}
]

show(orders.aggregate(pipeline))
```

## Lookup

```python
pipeline = [
    {
        "$lookup": {
            "from": "customers",
            "localField": "customer_id",
            "foreignField": "customer_id",
            "as": "customer_info"
        }
    }
]

show(orders.aggregate(pipeline))
```

## Notes

MongoDB can do lookup, but the preferred model still avoids join-heavy designs when possible.
EOF

cat <<'EOF' > "$MODULE/learning-materials/05_mongodb/indexing.md" <<'EOF'
# MongoDB Indexing

## Simple index

```javascript
db.orders.createIndex({ customer_id: 1 })
```

## Compound index

```javascript
db.orders.createIndex({ customer_id: 1, order_date: -1 })
```

## Nested field index

```javascript
db.orders.createIndex({ "customer.country": 1 })
```

## Array field index

```javascript
db.orders.createIndex({ "items.sku": 1 })
```

## Text index

```javascript
db.products.createIndex({ description: "text" })
```

## Design Rules

- index frequent filters
- align compound index order with query patterns
- keep write overhead in mind
- validate with explain plans
EOF

cat <<'EOF' > "$MODULE/learning-materials/05_mongodb/data_modeling.md" <<'EOF'
# MongoDB Data Modeling

## Main Rules

- embed when data is read together
- reference when data is large, shared, or independent
- design documents around application access patterns
- avoid modeling everything like normalized SQL

## Good Fit

- product catalogs
- event payloads
- order documents
- session documents

## Common Risks

- giant documents
- too much duplication
- lookup-heavy data access
EOF

cat <<'EOF' > "$MODULE/learning-materials/05_mongodb/mongodb_vs_sql.md" <<'EOF'
# MongoDB vs SQL

| Feature | SQL | MongoDB |
|---|---|---|
| Model | tables | documents |
| Schema | fixed | flexible |
| Joins | natural | possible but not primary |
| Transactions | strong relational model | supported but not the main design focus |
| Best strength | relational workloads | document workloads |

## Main Mindset Shift

In SQL, start from relationships.

In MongoDB, start from document boundaries and read patterns.
EOF

cat <<'EOF' > "$MODULE/learning-materials/06_dynamodb/README.md" <<'EOF'
# 06 DynamoDB

This section covers DynamoDB from an access-pattern and architecture perspective.

## Main Topics

- architecture
- query patterns
- data modeling
- hot partition problem
- secondary indexes
- scaling behavior

DynamoDB should be learned here as a distributed key-value system where schema follows access patterns.
EOF

cat <<'EOF' > "$MODULE/learning-materials/06_dynamodb/architecture.md" <<'EOF'
# DynamoDB Architecture

## High-Level Flow

Client
-> API
-> partition key hashing
-> storage partitions

## Main Concepts

- partition key
- sort key
- throughput
- GSIs
- LSIs
- adaptive capacity

## Important Truth

DynamoDB is not designed for relational query flexibility.

It is designed for predictable, scalable key-based access.
EOF

cat <<'EOF' > "$MODULE/learning-materials/06_dynamodb/partition_keys.md" <<'EOF'
# Partition Keys

Partition keys determine data placement.

## Good Partition Key

A good partition key should:

- distribute traffic evenly
- support important access patterns
- avoid concentration on one value

## Bad Partition Key Examples

- country when most traffic is one country
- status when one status dominates
- very low-cardinality fields

## Good Examples

- customer_id if traffic is well distributed
- tenant_id when tenants are balanced
- sharded synthetic keys when needed
EOF

cat <<'EOF' > "$MODULE/learning-materials/06_dynamodb/secondary_indexes.md" <<'EOF'
# Secondary Indexes

## GSI

Global Secondary Index lets you query on alternative key shapes.

## LSI

Local Secondary Index changes sort-key style access inside same partition key.

## Rule

Add indexes only for real access patterns, not speculative ones.

## Example

Base table:
- PK = customer_id
- SK = order_timestamp

GSI1:
- GSI1PK = product_id
- GSI1SK = order_timestamp
EOF

cat <<'EOF' > "$MODULE/learning-materials/06_dynamodb/query_patterns.md" <<'EOF'
# DynamoDB Query Patterns

DynamoDB queries are key-oriented.

## Get item by primary key

```python
table.get_item(
    Key={
        "pk": "CUSTOMER#10",
        "sk": "PROFILE#10"
    }
)
```

## Query all orders for customer

```python
table.query(
    KeyConditionExpression=
        Key("pk").eq("CUSTOMER#10") &
        Key("sk").begins_with("ORDER#")
)
```

## Query latest orders for customer

```python
table.query(
    KeyConditionExpression=
        Key("pk").eq("CUSTOMER#10") &
        Key("sk").begins_with("ORDER#"),
    ScanIndexForward=False,
    Limit=10
)
```

## Query through GSI

```python
table.query(
    IndexName="GSI1",
    KeyConditionExpression=
        Key("gsi1pk").eq("PRODUCT#1001")
)
```

## Main Rule

If a query cannot be expressed through PK/SK or a designed index, the schema is probably wrong for that workload.
EOF

cat <<'EOF' > "$MODULE/learning-materials/06_dynamodb/data_modeling.md" <<'EOF'
# DynamoDB Data Modeling

## Main Mindset

Do not start with entities.

Start with access patterns.

## Typical Process

1. list read/write patterns
2. design primary key
3. design sort key
4. identify alternate access needs
5. add GSIs only where necessary

## Common Patterns

- customer timeline
- order history
- latest status per entity
- tenant-isolated data
- event streams by actor

## Common Mistakes

- trying to reproduce normalized SQL schema
- overusing scans
- weak partition keys
- not thinking about hot partitions
EOF

cat <<'EOF' > "$MODULE/learning-materials/06_dynamodb/scaling_and_throttling.md" <<'EOF'
# Scaling and Throttling

## Core Issues

DynamoDB performance depends on partition distribution and throughput behavior.

## Typical Problems

- hot partitions
- throttling spikes
- uneven traffic
- write bursts on one key

## Design Responses

- improve partition key distribution
- use sharding strategies
- cache hot reads
- precompute aggregates
- use adaptive scaling features appropriately
EOF

cat <<'EOF' > "$MODULE/learning-materials/06_dynamodb/hot_partition_problem.md" <<'EOF'
# Hot Partition Problem

A hot partition happens when too much traffic targets one partition key.

## Example

Bad key:

```text
pk = country
```

If most traffic is:

```text
USA
```

then one partition becomes overloaded.

## Symptoms

- throttling
- latency spikes
- failed writes
- inconsistent operational performance

## Solutions

- choose better partition keys
- shard hot keys
- spread writes intentionally
- redesign access pattern
EOF

cat <<'EOF' > "$MODULE/learning-materials/06_dynamodb/dynamodb_vs_mongodb.md" <<'EOF'
# DynamoDB vs MongoDB

| Feature | DynamoDB | MongoDB |
|---|---|---|
| Main model | key-value / access-pattern | document-oriented |
| Query style | PK/SK and indexes | flexible document queries |
| Joins | no | limited through lookup |
| Main strength | scale and latency | flexible document reads |
| Main risk | hard schema design | document/index misuse |

## Main Difference

DynamoDB is stricter and more access-pattern-driven.

MongoDB is more flexible in querying but still requires good modeling.
EOF

cat <<'EOF' > "$MODULE/learning-materials/06_dynamodb/practice_patterns.md" <<'EOF'
# Practice Patterns

1. Design a table for customer orders.
2. Design a GSI for product-based order lookup.
3. Model latest events per user.
4. Avoid hot partition for high-traffic tenants.
5. Design a time-series access pattern.

For each case define:

- PK
- SK
- alternate indexes
- expected query
- scaling risk
EOF

cat <<'EOF' > "$MODULE/learning-materials/07_azure_databases_for_databricks/README.md" <<'EOF'
# 07 Azure Databases for Databricks

This section focuses on Azure databases and how they fit into data platform architecture, especially around Databricks.

## Main Topics

- Azure SQL Database
- Azure CosmosDB
- Synapse SQL
- Databricks integration
- selection guidance
- partitioning and indexing trade-offs
EOF

cat <<'EOF' > "$MODULE/learning-materials/07_azure_databases_for_databricks/azure_sql_database.md" <<'EOF'
# Azure SQL Database

Azure SQL Database is a managed SQL Server-based relational database service.

## What Stays Familiar

- T-SQL
- joins
- window functions
- procedures
- transactions
- indexing

## What Changes

- fully managed infrastructure
- platform-specific scaling tiers
- Azure-native security and networking
- cloud operational model

## Best Use Cases

- OLTP applications
- transactional backends
- source systems for data ingestion
- structured operational workloads

## Databricks Role

Databricks often reads Azure SQL as a source through JDBC or connector-based ingestion.
EOF

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
EOF

cat <<'EOF' > "$MODULE/learning-materials/07_azure_databases_for_databricks/azure_sql_stored_procedures.md" <<'EOF'
# Azure SQL Stored Procedures

Azure SQL Database supports T-SQL stored procedures.

## Simple Procedure

```sql
CREATE PROCEDURE GetCustomerOrders
    @customer_id INT
AS
BEGIN
    SELECT *
    FROM orders
    WHERE customer_id = @customer_id;
END;
```

## Execute

```sql
EXEC GetCustomerOrders @customer_id = 100;
```

## Update Procedure

```sql
CREATE PROCEDURE UpdateOrderStatus
    @order_id INT,
    @status VARCHAR(50)
AS
BEGIN
    UPDATE orders
    SET status = @status
    WHERE order_id = @order_id;
END;
```

## Why Important

Stored procedures are useful for:

- business logic
- data validation
- transaction control
- stable data access contracts
EOF

cat <<'EOF' > "$MODULE/learning-materials/07_azure_databases_for_databricks/azure_cosmosdb.md" <<'EOF'
# Azure CosmosDB

Azure CosmosDB is a globally distributed NoSQL database platform.

## Key Concepts

- partition key
- request units (RU)
- global replication
- JSON document model
- multiple APIs

## Supported APIs

- SQL API
- Mongo API
- Cassandra API
- Gremlin API

## Best Use Cases

- globally distributed apps
- microservices
- IoT / event-oriented operational systems
- semi-structured data

## Main Warning

Bad partition-key design leads to expensive and slow cross-partition queries.
EOF

cat <<'EOF' > "$MODULE/learning-materials/07_azure_databases_for_databricks/cosmos_queries.md" <<'EOF'
# CosmosDB Queries

These examples assume SQL API style queries.

## Select all

```sql
SELECT *
FROM c
```

## Equality filter

```sql
SELECT *
FROM c
WHERE c.status = "paid"
```

## Range filter

```sql
SELECT *
FROM c
WHERE c.amount > 100
```

## Projection

```sql
SELECT c.order_id, c.amount
FROM c
```

## Nested field

```sql
SELECT *
FROM c
WHERE c.customer.country = "PL"
```

## Array query

```sql
SELECT *
FROM c
JOIN item IN c.items
WHERE item.sku = "A1"
```

## Count

```sql
SELECT VALUE COUNT(1)
FROM c
WHERE c.status = "paid"
```

## Distinct

```sql
SELECT DISTINCT VALUE c.status
FROM c
```

## Order by

```sql
SELECT *
FROM c
ORDER BY c.order_date DESC
```

## Notes

Always think about:

- partition key usage
- cross-partition cost
- RU consumption
EOF

cat <<'EOF' > "$MODULE/learning-materials/07_azure_databases_for_databricks/cosmos_partitioning.md" <<'EOF'
# CosmosDB Partitioning

Partitioning is one of the most important design decisions in CosmosDB.

## Good Partition Key Should

- distribute data well
- distribute traffic well
- align with common query paths
- avoid hot logical partitions

## Example

Good candidate:

```text
/customer_id
```

if common access pattern is customer-local.

## Bad Example

```text
/status
```

if one status dominates.

## Main Cost Rule

Queries that do not align with partitioning are often more expensive and slower.
EOF

cat <<'EOF' > "$MODULE/learning-materials/07_azure_databases_for_databricks/synapse_sql.md" <<'EOF'
# Synapse SQL

Synapse SQL is a warehouse-style SQL engine in Azure.

## Main Modes

- dedicated SQL pool
- serverless SQL pool

## Strong Sides

- structured analytics
- warehouse-style SQL
- Power BI integration
- querying external data in some modes

## Important Difference from OLTP SQL

Synapse is about analytics and warehouse-style processing, not application OLTP.
EOF

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
EOF

cat <<'EOF' > "$MODULE/learning-materials/07_azure_databases_for_databricks/databricks_integration.md" <<'EOF'
# Databricks Integration

## Azure SQL -> Databricks

```python
df = spark.read \
    .format("jdbc") \
    .option("url", jdbc_url) \
    .option("dbtable", "orders") \
    .option("user", user) \
    .option("password", password) \
    .load()
```

## CosmosDB -> Databricks

```python
df = spark.read.format("cosmos.oltp").options(**cfg).load()
```

## Synapse / Lake Query Style

Databricks can also read lake data directly through Delta and Spark-native patterns.

## Main Architectural Question

Choose the source based on workload:

- Azure SQL for transactional source systems
- CosmosDB for operational NoSQL apps
- Synapse for warehouse SQL patterns
- Databricks for core lakehouse analytics and engineering
EOF

cat <<'EOF' > "$MODULE/learning-materials/07_azure_databases_for_databricks/database_selection_guide.md" <<'EOF'
# Database Selection Guide

## Use Azure SQL When

- workload is transactional
- relational integrity matters
- application backend needs familiar SQL engine
- source system is OLTP

## Use CosmosDB When

- globally distributed app is needed
- JSON documents fit naturally
- partition-aware NoSQL model is appropriate
- microservice operational workload dominates

## Use Synapse SQL When

- warehouse-style SQL is primary
- BI / reporting is dominant
- data lake query integration is needed in warehouse style

## Use Databricks + Delta When

- analytics platform is core
- batch + streaming are needed
- data engineering pipelines dominate
- lakehouse architecture is the target
EOF

cat <<'EOF' > "$MODULE/learning-materials/07_azure_databases_for_databricks/practical_usage_patterns.md" <<'EOF'
# Practical Usage Patterns

## Pattern 1: Azure SQL as Source for Databricks

- operational app writes to Azure SQL
- Databricks ingests via JDBC
- Delta tables become analytics layer

## Pattern 2: CosmosDB for Operational API + Databricks for Analytics

- application writes JSON documents to CosmosDB
- analytics pipeline exports or ingests operational data
- curated Delta tables power BI and ML

## Pattern 3: Synapse for SQL Warehouse Workloads

- structured reporting in Synapse
- Databricks handles broader engineering / lakehouse workloads

## Rule

Do not force one Azure database to serve every workload.
EOF

cat <<'EOF' > "$MODULE/learning-materials/07_azure_databases_for_databricks/synapse_vs_databricks_sql.md" <<'EOF'
# Synapse vs Databricks SQL

| Feature | Synapse SQL | Databricks SQL |
|---|---|---|
| Main style | warehouse SQL | lakehouse SQL |
| Core storage fit | warehouse / external query | Delta Lake |
| Best for | BI and warehouse patterns | analytics, engineering, lakehouse |
| Engine character | MPP warehouse style | Spark-based SQL over lakehouse |

## Use Synapse SQL When

- SQL warehouse model is dominant
- BI/reporting is the main driver
- platform is organized around warehouse semantics

## Use Databricks SQL When

- Delta Lake is central
- data engineering and analytics are combined
- ML and broader platform workflows matter
EOF

log "Learning materials completed."
