
cat <<'EOF' > "$MODULE/simple-tasks/03_document_queries/README.md" <<'EOF'
# 03 Document Queries

## Overview

These tasks focus on document-oriented queries, mainly with MongoDB-style patterns.

Suggested collections:

- orders
- users
- events
- sessions

Example document:

```json
{
  "order_id": 101,
  "customer_id": 10,
  "status": "paid",
  "amount": 250,
  "customer": {
    "country": "PL"
  },
  "items": [
    {"sku": "A1", "qty": 2, "price": 100},
    {"sku": "B2", "qty": 1, "price": 50}
  ],
  "tags": ["priority", "electronics"]
}
```

---

## Task 1 — Read All Documents

### Goal

Return all documents from the orders collection.

### Input

Collection:

- orders

### Requirements

- read all documents
- do not apply filters

### Expected Output

Full set of order documents.

### Extra Challenge

Return only the first 10 documents.

---

## Task 2 — Equality Filter

### Goal

Return all paid orders.

### Input

Collection:

- orders

Relevant fields:

- status

### Requirements

- filter on status = paid

### Expected Output

Only documents where status is paid.

### Extra Challenge

Also return paid orders for one specific customer_id.

---

## Task 3 — Range Filter

### Goal

Return all orders with amount greater than 100.

### Input

Collection:

- orders

Relevant fields:

- amount

### Requirements

- apply numeric range filter

### Expected Output

Documents where amount > 100.

### Extra Challenge

Filter amount between 100 and 500.

---

## Task 4 — Combined Filter

### Goal

Return all paid orders with amount between 100 and 500.

### Input

Collection:

- orders

Relevant fields:

- status
- amount

### Requirements

- combine equality and range filter

### Expected Output

Documents that satisfy both conditions.

### Extra Challenge

Add customer.country = "PL" to the filter.

---

## Task 5 — Projection

### Goal

Return only selected fields from documents.

### Input

Collection:

- orders

Relevant fields:

- order_id
- customer_id
- amount
- status

### Requirements

- exclude _id
- include only required fields

### Expected Output

Documents containing only selected fields.

### Extra Challenge

Add a computed field later through aggregation.

---

## Task 6 — Sorting

### Goal

Return orders sorted by amount descending.

### Input

Collection:

- orders

Relevant fields:

- amount

### Requirements

- sort descending

### Expected Output

Documents ordered by amount from highest to lowest.

### Extra Challenge

Sort by status ascending and amount descending.

---

## Task 7 — Pagination

### Goal

Return page 3 with page size 10.

### Input

Collection:

- orders

Relevant fields:

- order_id or another sorting key

### Requirements

- sort deterministically
- skip first 20
- limit 10

### Expected Output

10 documents representing page 3.

### Extra Challenge

Explain why skip-based pagination may become expensive on large collections.

---

## Task 8 — Count Paid Orders

### Goal

Count the number of paid orders.

### Input

Collection:

- orders

Relevant fields:

- status

### Requirements

- count only paid documents

### Expected Output

Single numeric count.

### Extra Challenge

Return counts by status using aggregation.

---

## Task 9 — Distinct Statuses

### Goal

Return all distinct order statuses.

### Input

Collection:

- orders

Relevant fields:

- status

### Requirements

- return unique values only

### Expected Output

Distinct list of statuses.

### Extra Challenge

Return distinct countries from nested customer.country.

---

## Task 10 — Nested Field Query

### Goal

Return all orders where customer.country = "PL".

### Input

Collection:

- orders

Relevant fields:

- customer.country

### Requirements

- query nested field

### Expected Output

Documents whose nested customer.country equals PL.

### Extra Challenge

Add status = paid to the same query.

---

## Task 11 — Array Membership

### Goal

Return all orders tagged as priority.

### Input

Collection:

- orders

Relevant fields:

- tags

### Requirements

- match documents containing one array value

### Expected Output

Documents where tags contains "priority".

### Extra Challenge

Match documents containing both "priority" and "electronics".

---

## Task 12 — elemMatch

### Goal

Find orders where one embedded item has sku = A1 and qty >= 2.

### Input

Collection:

- orders

Relevant fields:

- items.sku
- items.qty

### Requirements

- use elemMatch
- ensure both conditions match the same array element

### Expected Output

Orders containing at least one matching item object.

### Extra Challenge

Also filter orders with amount > 100.

---

## Task 13 — Aggregation by Status

### Goal

Group orders by status and calculate count and total amount.

### Input

Collection:

- orders

Relevant fields:

- status
- amount

### Requirements

- use aggregation pipeline
- group by status
- count documents
- sum amount

### Expected Output

Columns / fields:

- status
- order_count
- total_amount

### Extra Challenge

Sort aggregated result by total_amount descending.

---

## Task 14 — Aggregation by Customer

### Goal

Group paid orders by customer_id and calculate total amount.

### Input

Collection:

- orders

Relevant fields:

- customer_id
- status
- amount

### Requirements

- filter to paid orders first
- group by customer_id
- calculate total amount

### Expected Output

Documents showing customer-level paid revenue.

### Extra Challenge

Return top 10 customers by total_amount.

