# 02 Window Queries

## Overview

These tasks focus on window-function-based patterns frequently used in analytics engineering and data platform work.

Suggested dataset tables:

- orders
- events
- customers
- daily_metrics

---

## Task 1 — Rank Orders Per User

### Goal

Assign a sequential order number to each user's orders.

### Input

Table:

- orders

Relevant columns:

- user_id
- order_id
- order_date

### Requirements

- partition by user_id
- order by order_date
- assign row number

### Expected Output

Columns:

- user_id
- order_id
- order_date
- order_number

### Extra Challenge

Also calculate:

- reverse order number (latest = 1)

---

## Task 2 — Running Customer Revenue

### Goal

Calculate cumulative revenue per customer over time.

### Input

Table:

- orders

Relevant columns:

- user_id
- order_date
- amount
- status

### Requirements

- include only paid/completed orders
- partition by user_id
- order by order_date
- calculate running sum

### Expected Output

Columns:

- user_id
- order_date
- amount
- running_customer_revenue

### Extra Challenge

Return running order count together with running revenue.

---

## Task 3 — Global Running Revenue

### Goal

Calculate cumulative revenue across the whole business timeline.

### Input

Table:

- orders

Relevant columns:

- order_date
- amount
- status

### Requirements

- aggregate by day first or document why you do not
- order by date
- calculate cumulative revenue

### Expected Output

Columns:

- revenue_date
- daily_revenue
- running_revenue

### Extra Challenge

Add cumulative average daily revenue.

---

## Task 4 — 7-Day Moving Average

### Goal

Smooth daily revenue using a 7-day moving average.

### Input

Table:

- daily_revenue or derived daily revenue dataset

Relevant columns:

- revenue_date
- daily_revenue

### Requirements

- order by date
- calculate 7-day moving average
- use a proper window frame

### Expected Output

Columns:

- revenue_date
- daily_revenue
- moving_avg_7d

### Extra Challenge

Also calculate 3-day and 30-day moving averages.

---

## Task 5 — Previous and Next Order

### Goal

Show previous and next order timestamps for each customer order.

### Input

Table:

- orders

Relevant columns:

- user_id
- order_id
- order_date

### Requirements

- use LAG
- use LEAD
- partition by user_id
- order by order_date

### Expected Output

Columns:

- user_id
- order_id
- order_date
- previous_order_date
- next_order_date

### Extra Challenge

Also calculate days_since_previous_order.

---

## Task 6 — Latest Record Per Entity

### Goal

Return only the latest record per entity from an update stream.

### Input

Table:

- customer_updates or orders_raw

Relevant columns:

- entity_id
- updated_at
- payload_version or event_id

### Requirements

- partition by entity_id
- order by updated_at descending
- keep only latest row

### Expected Output

Columns:

- entity_id
- updated_at
- latest_payload_columns

### Extra Challenge

Make the ordering deterministic when timestamps are equal.

---

## Task 7 — Sessionization Flag

### Goal

Mark whether an event starts a new session.

### Input

Table:

- events

Relevant columns:

- user_id
- event_time
- event_name

### Requirements

- partition by user_id
- order by event_time
- compare current event_time with previous event_time
- define a session timeout, for example 30 minutes

### Expected Output

Columns:

- user_id
- event_time
- previous_event_time
- new_session_flag

### Extra Challenge

Create a session_id using cumulative sum over new_session_flag.

---

## Task 8 — Top N Inside Partition

### Goal

Return top 5 products per category by revenue.

### Input

Tables:

- order_items
- products

Relevant columns:

- product_id
- category_id
- quantity
- item_price

### Requirements

- aggregate revenue per product
- partition by category
- rank by revenue descending
- keep only top 5

### Expected Output

Columns:

- category_id
- product_id
- total_revenue
- rank_in_category

### Extra Challenge

Compare ROW_NUMBER vs RANK vs DENSE_RANK on the same dataset.

