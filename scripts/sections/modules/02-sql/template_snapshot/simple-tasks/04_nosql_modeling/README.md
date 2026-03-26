# 04 NoSQL Modeling

## Overview

These tasks focus on schema design for NoSQL systems instead of direct relational translation.

Source relational entities:

- users
- orders
- order_items
- products
- events
- sessions

---

## Task 1 — SQL to MongoDB Order Model

### Goal

Convert relational order tables into a MongoDB-friendly document model.

### Input

Relational tables:

- orders
- order_items
- products

### Requirements

- decide what to embed
- decide what to reference
- explain document boundaries
- explain risks of document growth

### Expected Output

- proposed order document schema
- example document
- explanation of design choices

### Extra Challenge

Design both:
- embedded model
- hybrid embedded + referenced model

and compare them.

---

## Task 2 — SQL to DynamoDB Order Access Pattern Model

### Goal

Design a DynamoDB schema for customer order access patterns.

### Input

Business requirements:

- get all orders for customer
- get latest orders for customer
- get orders by product through GSI

### Requirements

- define PK
- define SK
- define at least one GSI
- explain access pattern mapping
- explain hot partition risks

### Expected Output

- table design
- example items
- example query patterns
- index strategy

### Extra Challenge

Design a sharded version for high-traffic customers.

---

## Task 3 — SQL to CosmosDB Order Model

### Goal

Design a CosmosDB order model and choose a partition key.

### Input

Relational domain:

- orders
- order_items
- customers

### Requirements

- define JSON document shape
- choose partition key
- explain why the partition key is good
- explain which queries are cheap and expensive

### Expected Output

- proposed schema
- example document
- partition key decision note
- trade-off explanation

### Extra Challenge

Compare:
- partition by customer_id
- partition by order_id

and explain which is better for common operational queries.

---

## Task 4 — Session Event Modeling Across Systems

### Goal

Model session or event data in multiple NoSQL systems.

### Input

Domain:

- users
- sessions
- events

### Requirements

- propose model for MongoDB
- propose model for DynamoDB
- propose model for CosmosDB
- explain differences in access path design

### Expected Output

- three model variants
- example documents/items
- query/access pattern explanation
- trade-off comparison

### Extra Challenge

Explain which model is best for:
- operational reads
- analytics export
- high write throughput

---

## Task 5 — Product Catalog with Flexible Attributes

### Goal

Model a flexible product catalog where products have different attribute sets.

### Input

Product examples:

- laptop with CPU/RAM/storage
- shoes with size/material/color
- book with author/language/pages

### Requirements

- propose SQL model
- propose MongoDB model
- propose CosmosDB model
- explain where flexible schema is useful

### Expected Output

- schemas for each system
- example records/documents
- strengths and weaknesses of each approach

### Extra Challenge

Add a search/filter requirement and explain which fields should be indexed.
