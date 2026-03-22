#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="02-sql-fill-pet-projects"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "02-sql")"

log "Filling SQL pet projects..."

cat <<'EOF' > "$MODULE/pet-projects/01_sql_analytics_engine/README.md"
# 01 SQL Analytics Engine

## Project Goal

Build a mini analytics layer on top of an e-commerce dataset using production-style SQL patterns.

## Project Context

You have transactional and event data:

- users
- orders
- order_items
- products
- payments
- events

You need to build a reusable analytics layer that answers product, finance, and customer behavior questions.

## What This Project Teaches

- analytical SQL design
- metric definition discipline
- reusable query patterns
- KPI modeling
- retention and funnel analysis
- layered transformation thinking
- reporting-oriented outputs

## Scope

This project should simulate a lightweight analytics warehouse / marts layer.

You are not building a full BI platform.  
You are building the SQL foundation that such a platform would use.

---

## Deliverable 1 — Source Model Overview

### Goal

Document the input data model and define the grain of every source table.

### Input

Tables such as:

- users
- orders
- order_items
- products
- payments
- events

### Requirements

- describe each source table
- define business grain for each table
- identify key columns
- identify important timestamps
- identify nullable or risky fields

### Expected Output

A documented source model section with:

- table name
- grain
- primary business key
- important attributes
- quality or ambiguity notes

### Extra Challenge

Add a section explaining which source tables are best for:
- operational KPIs
- customer analytics
- behavioral analytics

---

## Deliverable 2 — KPI Layer

### Goal

Create a reusable SQL KPI layer for core business metrics.

### Input

Main transactional tables:

- orders
- order_items
- payments
- users

### Requirements

Implement SQL for:

- total revenue
- revenue per day
- revenue per customer
- order count
- average order value
- paid vs cancelled order split
- top countries by revenue

### Expected Output

A documented KPI section with queries or views that return stable, analytics-ready outputs.

### Extra Challenge

Create a metric-definition section that explains:
- exact business logic
- included statuses
- excluded edge cases
- grain of the output

---

## Deliverable 3 — Customer Analytics Layer

### Goal

Build customer-focused analytical outputs.

### Input

Tables:

- users
- orders
- events

### Requirements

Implement SQL for:

- customer lifetime value
- first order date
- last order date
- total orders per customer
- days since last order
- active customers by period

### Expected Output

A customer analytics section producing customer-level outputs.

### Extra Challenge

Create customer segmentation logic such as:
- high value
- active
- dormant
- new

---

## Deliverable 4 — Product Analytics Layer

### Goal

Build product-focused analytics.

### Input

Tables:

- products
- order_items
- orders

### Requirements

Implement SQL for:

- top products by revenue
- top products by quantity sold
- product category contribution
- product performance by month

### Expected Output

A product analytics section with stable outputs that could feed dashboards.

### Extra Challenge

Add category-level ranking and cumulative revenue share.

---

## Deliverable 5 — Funnel Analysis

### Goal

Measure user movement through key product funnel steps.

### Input

Table:

- events

Example event types:

- view_product
- add_to_cart
- checkout
- payment_success

### Requirements

- define funnel steps
- calculate users at each step
- calculate conversion ratios
- document assumptions about time window and ordering

### Expected Output

A funnel section showing:
- step
- users
- conversion rate

### Extra Challenge

Create a same-session funnel version and compare it to a cross-session funnel version.

---

## Deliverable 6 — Retention and Cohorts

### Goal

Measure how users return after first activity.

### Input

Table:

- events
or
- orders

### Requirements

Implement:

- day-1 retention
- day-7 retention
- monthly cohort table
- active users by cohort period

### Expected Output

A retention section with:
- cohort period
- cohort size
- retained users
- retention ratio

### Extra Challenge

Build both:
- event-based retention
- order-based retention

and compare what each version actually measures.

---

## Deliverable 7 — Data Quality and Assumptions

### Goal

Document assumptions and protect analytical logic from ambiguous raw data.

### Input

All project source tables.

### Requirements

Document:

- which statuses are considered valid
- how refunds are handled
- how duplicate orders are handled
- how missing timestamps are handled
- how test/internal users are excluded if needed

### Expected Output

A project section called:

- assumptions.md
or equivalent documentation inside README

### Extra Challenge

Add a “known limitations” section.

---

## Suggested Folder Structure

You may keep this project simple, but a good structure would be:

- source_queries.sql
- kpi_queries.sql
- customer_analytics.sql
- product_analytics.sql
- funnel_queries.sql
- retention_queries.sql
- README.md

## Final Result

After completing this project, the learner should be able to design a realistic SQL analytics layer instead of writing isolated ad hoc queries.
EOF

cat <<'EOF' > "$MODULE/pet-projects/01_sql_analytics_engine/dataset.md" <<'EOF'
# Dataset

## Recommended Tables

### users

Suggested columns:

- user_id
- email
- country
- signup_date
- user_status

### orders

Suggested columns:

- order_id
- user_id
- order_date
- status
- amount
- currency

### order_items

Suggested columns:

- order_item_id
- order_id
- product_id
- quantity
- item_price

### products

Suggested columns:

- product_id
- category_id
- product_name
- category_name

### payments

Suggested columns:

- payment_id
- order_id
- payment_date
- payment_status
- paid_amount

### events

Suggested columns:

- event_id
- user_id
- session_id
- event_name
- event_time
- page_url
- device_type

## Data Quality Notes

When preparing the project, think about:

- duplicate orders
- invalid statuses
- refunded orders
- missing timestamps
- test users
- inconsistent category naming

## Recommendation

Use realistic enough data to support:

- order analytics
- customer analytics
- funnel analysis
- retention analysis
- cohort analysis
EOF

cat <<'EOF' > "$MODULE/pet-projects/01_sql_analytics_engine/requirements.md" <<'EOF'
# Requirements

## Functional Requirements

- write correct and readable SQL
- support KPI outputs
- support customer analytics
- support product analytics
- support funnel analysis
- support retention analysis
- document assumptions

## Non-Functional Requirements

- readable query structure
- stable grain definitions
- deterministic deduplication logic
- reusable naming conventions
- outputs that are easy to validate

## Engineering Standards

Recommended practices:

- use CTEs for readability
- define filters explicitly
- separate intermediate logic from final outputs
- comment non-obvious business rules
- make output column names stable and meaningful

## Validation Expectations

Each analytical output should be easy to verify with:

- sample row checks
- aggregate reconciliation
- business definition review
EOF

cat <<'EOF' > "$MODULE/pet-projects/01_sql_analytics_engine/architecture.md" <<'EOF'
# Architecture

## Logical Flow

Source transactional tables / event tables
-> cleanup and validation
-> reusable analytical transformations
-> KPI outputs
-> reporting-ready final outputs

## Recommended Layers

### Layer 1 — Raw Source Understanding

Understand source grains and business definitions.

### Layer 2 — Cleaned / Standardized Logic

Normalize business filters such as:

- paid order definition
- valid customer definition
- valid event set

### Layer 3 — Reusable Analytical Models

Examples:

- customer revenue model
- daily revenue model
- product sales model
- funnel base model

### Layer 4 — Final Outputs

Examples:

- KPI tables
- retention outputs
- product ranking outputs
- customer segmentation outputs

## Why This Matters

Even a SQL-only analytics project should teach layered design instead of one giant unmaintainable query.
EOF

cat <<'EOF' > "$MODULE/pet-projects/02_mongodb_event_store/README.md" <<'EOF'
# 02 MongoDB Event Store

## Project Goal

Design and query an event storage system using MongoDB.

## Project Context

You need to store high-volume user activity or application events in MongoDB and support operational and near-analytical query patterns.

Example domains:

- clickstream
- audit events
- application activity logs
- user interaction history

## What This Project Teaches

- event document modeling
- query design for event stores
- MongoDB indexing for operational reads
- aggregation for event analysis
- retention and lifecycle thinking

## Example Event

```json
{
  "event_id": 1,
  "user_id": 10,
  "session_id": "s_100",
  "event": "click",
  "timestamp": "2025-01-01T12:00:00Z",
  "page": "/products/1",
  "device": "mobile"
}
```

---

## Deliverable 1 — Event Document Model

### Goal

Design the MongoDB document shape for events.

### Input

Business domain:

- user activity
- sessions
- page views
- clicks
- conversions

### Requirements

- define core event fields
- decide whether each event is one document
- explain document boundaries
- explain whether session-level embedding is used or not

### Expected Output

- proposed event schema
- example event document
- modeling explanation

### Extra Challenge

Design two variants:
- event-per-document
- session document with embedded events

and compare them.

---

## Deliverable 2 — Query Patterns

### Goal

Support core operational query patterns.

### Input

Collection:

- events

### Requirements

Support patterns such as:

- latest events for user
- all events in one session
- all click events in time range
- events for one page
- events for one event type
- latest events globally

### Expected Output

A documented query pattern section with example MongoDB queries or Python examples.

### Extra Challenge

Add pagination and discuss its limitations for large-scale event browsing.

---

## Deliverable 3 — Aggregation Patterns

### Goal

Use MongoDB aggregation to analyze events.

### Input

Collection:

- events

### Requirements

Implement examples such as:

- event count by type
- top pages
- events by day
- events by device
- active users by day

### Expected Output

A documented aggregation section with reusable pipelines.

### Extra Challenge

Add a session-level aggregation such as:
- average events per session
- session count per day

---

## Deliverable 4 — Index Design

### Goal

Design indexes that support real event access patterns.

### Input

Core fields:

- user_id
- session_id
- timestamp
- event
- page

### Requirements

- propose indexes for common reads
- explain compound index ordering
- explain write overhead trade-offs

### Expected Output

A documented index strategy section.

### Extra Challenge

Add TTL indexing strategy for old events.

---

## Deliverable 5 — Retention and Lifecycle Strategy

### Goal

Define how old event data should be retained and managed.

### Input

Event workload assumptions.

### Requirements

- define retention rule
- explain whether TTL is appropriate
- explain archival/export path if needed

### Expected Output

A lifecycle strategy section.

### Extra Challenge

Describe how events would be exported into a lakehouse or analytics system.

---

## Suggested Folder Structure

- README.md
- architecture.md
- document_model.md
- query_patterns.md

You may also add:

- aggregation_examples.py
- index_notes.md
- lifecycle.md

## Final Result

After completing this project, the learner should understand how MongoDB can support an event-oriented operational workload and where its limits appear for large-scale analytics.
EOF

cat <<'EOF' > "$MODULE/pet-projects/02_mongodb_event_store/architecture.md" <<'EOF'
# Architecture

## Logical Flow

Application
-> MongoDB event collection
-> indexes
-> operational queries
-> aggregation pipelines
-> optional export to analytics platform

## Main Architectural Concerns

- write volume
- event granularity
- query latency
- index overhead
- retention strategy
- export strategy for analytics

## Common Architecture Decision

MongoDB is usually good for:

- operational event access
- recent activity queries
- session reconstruction
- application-side event browsing

For deeper large-scale analytics, events are often exported to:

- data lake
- Delta tables
- Spark / Databricks pipelines
EOF

cat <<'EOF' > "$MODULE/pet-projects/02_mongodb_event_store/document_model.md" <<'EOF'
# Document Model

## Option 1 — Event Per Document

### Description

Each event is stored as one document.

### Benefits

- simple write path
- flexible filtering
- easy indexing on event fields
- natural fit for event streams

### Risks

- many small documents
- session reconstruction requires grouping or multiple reads

---

## Option 2 — Session Document

### Description

Store a session with embedded events.

### Benefits

- read-many events together
- session-level reconstruction is easy

### Risks

- unbounded growth
- harder partial updates
- harder indexing on all event-level fields
- less flexible for large sessions

## Recommendation

For most operational event logging workloads, event-per-document is the safer and simpler starting point.
EOF

cat <<'EOF' > "$MODULE/pet-projects/02_mongodb_event_store/query_patterns.md" <<'EOF'
# Query Patterns

## Required Query Patterns

### Pattern 1 — Latest Events for User

Return most recent events for one user.

### Pattern 2 — Events for One Session

Return all events belonging to one session.

### Pattern 3 — Events by Type

Return all events of one type in a time range.

### Pattern 4 — Events for a Page

Return all events associated with a specific page.

### Pattern 5 — Global Latest Events

Return globally latest events for operational inspection.

## Example

```python
list(events.find({"user_id": 10}).sort("timestamp", -1).limit(100))
```

## Important Rule

Indexes must support the actual read patterns, not hypothetical ones.

## Recommended Index Candidates

- { user_id: 1, timestamp: -1 }
- { session_id: 1, timestamp: 1 }
- { event: 1, timestamp: -1 }
- { page: 1, timestamp: -1 }
EOF

cat <<'EOF' > "$MODULE/pet-projects/03_relational_to_document_migration/README.md" <<'EOF'
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
EOF

cat <<'EOF' > "$MODULE/pet-projects/03_relational_to_document_migration/source_model.md" <<'EOF'
# Source Model

## Relational Tables

- users
- orders
- order_items
- products
- payments

## Characteristics

- normalized
- join-heavy access
- strong relational integrity
- easy structured reporting
- clear table-level ownership of attributes

## Typical Access Patterns

- order with items
- customer order history
- product sales summary
- payment status per order

## Strengths

- easy consistency reasoning
- natural joins
- clear constraints
- excellent fit for transactional business systems
EOF

cat <<'EOF' > "$MODULE/pet-projects/03_relational_to_document_migration/target_model.md" <<'EOF'
# Target Model

## Example Order Document

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
    }
  ],
  "payment": {
    "method": "card",
    "status": "captured"
  }
}
```

## Main Design Choices

- embed order items
- embed small payment summary
- duplicate selected product/customer attributes where read value is high
- reference huge reusable entities only when independence matters

## Main Benefits

- fewer joins
- natural order-level reads
- application-friendly response shape

## Main Risks

- duplicated data
- update fan-out
- document growth if model is not bounded
EOF

cat <<'EOF' > "$MODULE/pet-projects/03_relational_to_document_migration/migration_strategy.md" <<'EOF'
# Migration Strategy

## Step 1 — Identify Main Read Patterns

List the most important application or analytical reads.

## Step 2 — Choose Document Boundaries

Decide what belongs naturally together in one document.

## Step 3 — Replace Expensive Join Paths

Move frequently co-read data into embedded structures when practical.

## Step 4 — Decide Intentional Duplication

Duplicate only fields that create strong read benefits.

## Step 5 — Define Indexes for Real Queries

Design indexes around target access paths.

## Step 6 — Validate Growth and Update Behavior

Ensure documents do not grow unbounded and update fan-out remains acceptable.

## Final Rule

Do not translate tables into collections one-to-one without rethinking the access model.
EOF

log "Pet projects completed."