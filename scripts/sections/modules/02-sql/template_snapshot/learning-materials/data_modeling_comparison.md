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
