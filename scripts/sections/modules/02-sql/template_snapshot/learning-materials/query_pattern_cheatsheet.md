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
