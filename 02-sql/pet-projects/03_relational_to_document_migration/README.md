# 03 Relational to Document Migration

## Project Goal

Convert a relational schema into a document-oriented model and explain the trade-offs.

## Project Context

You have a normalized e-commerce schema and want to redesign it for a document database, primarily MongoDB-style usage.

Source entities:

- users
- orders
- order_items
- products
- payments

## What This Project Teaches

- document boundary thinking
- embedding vs referencing
- denormalization strategy
- query-path redesign
- trade-off analysis between SQL and document systems

---

## Deliverable 1 — Source Relational Model

### Goal

Document the original relational schema and explain its strengths.

### Input

Tables:

- users
- orders
- order_items
- products
- payments

### Requirements

- define table grains
- describe relationships
- identify main joins
- explain typical SQL query patterns

### Expected Output

A clear source model section describing the relational design.

### Extra Challenge

Add sample SQL queries that show natural relational access.

---

## Deliverable 2 — Target Document Model

### Goal

Design a target document-oriented schema.

### Input

Source relational schema.

### Requirements

- define main document boundaries
- decide what to embed
- decide what to reference
- explain duplicated fields if any
- explain expected read benefits

### Expected Output

- target document schema
- example order document
- explanation of design decisions

### Extra Challenge

Design both:
- fully embedded order model
- hybrid referenced model

and compare them.

---

## Deliverable 3 — Query Comparison

### Goal

Compare how the same business questions are solved in SQL and in document model.

### Input

Common business questions such as:

- get order with items
- get customer orders
- get top customers
- get product sales summary

### Requirements

- describe SQL solution
- describe MongoDB solution
- explain why one model is simpler or harder for each query

### Expected Output

A side-by-side query comparison section.

### Extra Challenge

Add performance and complexity notes for each approach.

---

## Deliverable 4 — Trade-Off Analysis

### Goal

Explain what changed after migration.

### Input

Source and target models.

### Requirements

Explain:

- what became easier
- what became harder
- what duplication was introduced
- what joins disappeared
- what update complexity changed
- what indexing strategy changed

### Expected Output

A structured trade-off analysis.

### Extra Challenge

Add a recommendation section:
- when to stay relational
- when to move to document model

---

## Suggested Folder Structure

- README.md
- source_model.md
- target_model.md
- migration_strategy.md

Optional additions:

- sql_examples.md
- mongo_examples.md
- tradeoffs.md

## Final Result

After completing this project, the learner should understand how to redesign data from normalized relational form into a document-oriented form without blindly copying table structure.
