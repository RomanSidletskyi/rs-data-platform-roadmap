# Snowflake Semi-Structured Performance — Micro-Partitions, Pruning, Flatten Optimization

## 1. How Semi-Structured Data Affects Micro-Partitions

### Key idea

Snowflake stores data in micro-partitions (~16MB compressed) and automatically collects metadata:

- min/max values
- distinct values
- statistics per column

### What changes with VARIANT

For VARIANT:

- Snowflake extracts metadata only for **top-level attributes**
- nested fields are less optimized for pruning
- high-cardinality nested fields → poor locality

### Example

    payload:user_id
    payload:event_ts

If `event_ts` is inside VARIANT:

❌ worse pruning than:

    event_ts TIMESTAMP column

### Why

- structured column → strong metadata
- VARIANT → weaker metadata, especially for deep nesting

### Senior insight

> Storing frequently filtered fields inside VARIANT can reduce pruning efficiency because Snowflake cannot always build strong metadata for nested paths.

---

## 2. Pruning Behavior with Semi-Structured Data

### Good pruning

Works well when:

- field is frequently accessed
- low overlap across partitions
- extracted or well-localized

### Bad pruning

Happens when:

- field is deeply nested
- high-cardinality (e.g. user_id)
- randomly distributed across micro-partitions
- stored only in VARIANT

### Example problem

    WHERE payload:user_id = 123

→ scans many partitions because:

- user_id spread across many partitions
- no clustering
- weak metadata

### Better approach

    user_id NUMBER column

OR:

    CLUSTER BY (payload:user_id)

OR:

    Search Optimization

---

## 3. Semi-Structured vs Structured Trade-off

### VARIANT advantages

- flexible schema
- handles schema drift
- fast ingestion

### VARIANT disadvantages

- weaker pruning
- more CPU for parsing
- harder joins
- worse performance for repeated queries

### Senior rule

> Use VARIANT for ingestion flexibility, but extract frequently used fields into structured columns for performance.

---

## 4. How FLATTEN Impacts Performance

### Core problem

FLATTEN = row explosion

### Example

1 row with:

    items = 100 elements

→ becomes 100 rows

Nested:

    items (100) × discounts (10)

→ 1000 rows

### Consequences

- large intermediate results
- more memory usage
- higher compute cost
- possible spill

### Senior insight

> FLATTEN cost is driven by output size, not input size.

---

## 5. Common Performance Issues with FLATTEN

### 1. Repeated flatten in every query

❌ bad:

    SELECT ...
    FROM raw_events,
    LATERAL FLATTEN(...)

in every BI query

✔️ better:

    materialized / staging table

---

### 2. Flatten before filtering

❌ bad:

    FLATTEN(all data) → filter later

✔️ better:

    filter first → flatten reduced dataset

---

### 3. Multiple flatten without control

❌ leads to:

- exponential growth
- skew
- spill

---

### 4. Joining after explosion

❌ big join on exploded dataset

✔️ better:

- filter early
- reduce before join

---

## 6. How to Optimize FLATTEN Queries

### Rule 1 — Filter before flatten

    SELECT ...
    FROM raw_events
    WHERE event_date = '2026-01-01'
    , LATERAL FLATTEN(...)

NOT:

    FLATTEN first → filter later

---

### Rule 2 — Extract frequently used arrays once

Create staging:

    stg_event_items

instead of flattening repeatedly

---

### Rule 3 — Limit flatten scope

Use:

    PATH

instead of flattening full payload

---

### Rule 4 — Avoid unnecessary nested flatten

Only flatten what is needed

---

### Rule 5 — Use OUTER carefully

OUTER increases row count → more cost

---

### Rule 6 — Consider denormalization

If array is small and frequently used:

→ flatten once → store as table

---

## 7. Join + Flatten — Hidden Complexity

### Problem

Flatten before join:

    raw → explode → join

→ huge dataset

### Better pattern

- filter
- reduce
- then flatten
- then join

### Senior insight

> The order of operations matters more than the operations themselves.

---

## 8. Query Profile — What to Look For

When debugging flatten queries:

### 1. Scan size

- too many partitions scanned → pruning issue

### 2. Row explosion

- input rows vs output rows

### 3. Join nodes

- large build side
- skew

### 4. Spill

- memory exceeded → disk usage

### 5. Time distribution

- where time is spent

---

## 9. Real Case #1 — Flatten Explosion

### Problem

- 2TB table
- flatten items
- query slow

### Root cause

- items array large
- flatten before filtering
- huge intermediate dataset

### Fix

- filter by date first
- then flatten
- optionally pre-materialize

---

## 10. Real Case #2 — Bad Pruning with VARIANT

### Problem

    WHERE payload:event_date = '2026-01-01'

→ scans 70%

### Root cause

- event_date inside VARIANT
- poor metadata

### Fix

- extract column
- cluster by date
- or partition ingestion

---

## 11. Real Case #3 — Skew after Flatten

### Problem

- join on user_id
- after flatten
- spill happens

### Root cause

- some users have many items
- uneven distribution

### Fix

- pre-aggregate
- filter hot keys
- salting if needed

---

## 12. Real Case #4 — BI Query Too Slow

### Problem

- dashboard runs flatten every time

### Root cause

- no staging layer

### Fix

- create flattened table
- reuse

---

## 13. Senior-Level Summary

- VARIANT → flexibility, but weaker pruning
- FLATTEN → row explosion → main cost driver
- performance = scan + explosion + join
- always filter before flatten
- materialize repeated flatten logic
- query profile is key to debugging

---

## 14. Strong Interview Answer

> Semi-structured data in Snowflake can impact performance because nested fields in VARIANT often have weaker pruning compared to structured columns. When using FLATTEN, the main cost driver is row explosion, especially with nested arrays. I usually optimize by filtering early, minimizing flatten scope, and materializing frequently used flattened structures. In query profile, I focus on scan size, row expansion, and join behavior to identify bottlenecks.