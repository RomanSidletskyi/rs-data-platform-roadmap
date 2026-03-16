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
