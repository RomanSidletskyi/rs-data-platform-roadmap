# Snowflake SQL Interview Patterns — Complete Guide (Senior Cheat Sheet)

## 1. How to Think in SQL Interviews

In Snowflake SQL interviews, they usually test four things:

- correctness
- readability
- scalability
- edge-case awareness

A strong answer is not just valid SQL.  
A strong answer shows that you understand:
- duplicates
- nulls
- join cardinality
- window semantics
- performance implications

### Senior approach

1. define expected grain
2. identify duplicates risk
3. write readable SQL
4. explain edge cases
5. mention performance if relevant

### Strong interview line

> Before writing the query, I usually define the expected grain of the output, because most SQL mistakes come from hidden grain mismatches, duplicate joins, or aggregation at the wrong level.

---

## 2. Window Functions — Core Mental Model

Window functions let you calculate values across related rows **without collapsing them like GROUP BY**.

They are commonly used for:
- ranking
- deduplication
- latest record selection
- running totals
- percent-of-total
- session logic

### General form

    function(...) OVER (
        PARTITION BY ...
        ORDER BY ...
    )

### Key idea

- `PARTITION BY` = logical group
- `ORDER BY` = order within group
- frame = which rows are visible to the function

### Common mistake

People know syntax but do not think about:
- tie handling
- null ordering
- frame defaults

---

## 3. ROW_NUMBER vs RANK vs DENSE_RANK

These are asked all the time.

### `ROW_NUMBER()`

Assigns a unique sequence number within each partition.

    SELECT
        user_id,
        event_ts,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY event_ts DESC
        ) AS rn
    FROM events;

Use when:
- you need exactly one row
- deduplication
- latest row logic

### `RANK()`

Same values get the same rank, but gaps appear.

Example:
values = 100, 90, 90, 80  
ranks = 1, 2, 2, 4

### `DENSE_RANK()`

Same values get the same rank, but no gaps.

Example:
values = 100, 90, 90, 80  
dense_ranks = 1, 2, 2, 3

### Interview answer

> I use `ROW_NUMBER()` when I need a single deterministic row, `RANK()` when ties should share the same position and skipped ranks are acceptable, and `DENSE_RANK()` when I want ties without gaps.

---

## 4. QUALIFY — One of Snowflake’s Best Features

`QUALIFY` filters **after** window functions are computed.

This is one of the most important Snowflake SQL features for interviews.

### Example: latest order per user

    SELECT
        user_id,
        order_id,
        order_ts,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY order_ts DESC
        ) AS rn
    FROM orders
    QUALIFY rn = 1;

### Why this is good

Without `QUALIFY`, you often need a subquery or CTE.

### Equivalent older pattern

    SELECT *
    FROM (
        SELECT
            user_id,
            order_id,
            order_ts,
            ROW_NUMBER() OVER (
                PARTITION BY user_id
                ORDER BY order_ts DESC
            ) AS rn
        FROM orders
    )
    WHERE rn = 1;

### Why interviewers like QUALIFY

It shows:
- Snowflake fluency
- cleaner SQL
- good window-function understanding

### Strong interview line

> In Snowflake, I prefer `QUALIFY` for filtering on window-function output because it keeps the query flatter and easier to read than wrapping everything in another subquery.

---

## 5. Deduplication Patterns

Dedup is one of the most common SQL interview problems.

### Pattern 1 — exact dedup

Remove exact duplicate rows:

    SELECT DISTINCT *
    FROM events;

But this is often too shallow.

### Pattern 2 — business-key dedup

Example:
keep latest record per `user_id`

    SELECT
        user_id,
        email,
        updated_at
    FROM users
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY user_id
        ORDER BY updated_at DESC
    ) = 1;

### Pattern 3 — deterministic dedup with tie-breaker

If `updated_at` can tie:

    SELECT
        user_id,
        email,
        updated_at,
        ingest_ts
    FROM users
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY user_id
        ORDER BY updated_at DESC, ingest_ts DESC
    ) = 1;

### Senior insight

Always define:
- duplicate key
- ordering rule
- tie-breaker

### Strong interview line

> For deduplication, I always define the business key and the deterministic tie-breaker. Otherwise the SQL may be syntactically correct but operationally unstable.

---

## 6. Latest Row Per Group

Extremely common interview problem.

### Example

Find latest event per user.

    SELECT
        user_id,
        event_id,
        event_ts
    FROM events
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY user_id
        ORDER BY event_ts DESC
    ) = 1;

### Edge case

If multiple events have same timestamp:
- query is non-deterministic unless tie-breaker exists

Better:

    SELECT
        user_id,
        event_id,
        event_ts
    FROM events
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY user_id
        ORDER BY event_ts DESC, event_id DESC
    ) = 1;

### Interview tip

Always mention tie-breaking.

---

## 7. Top N Per Group

Example: top 3 products per category by sales.

    SELECT
        category_id,
        product_id,
        sales,
        ROW_NUMBER() OVER (
            PARTITION BY category_id
            ORDER BY sales DESC
        ) AS rn
    FROM product_sales
    QUALIFY rn <= 3;

If ties matter, use `RANK()` or `DENSE_RANK()` instead.

### Interview answer

> For top-N per group, I usually use `ROW_NUMBER()` if I need exactly N rows, and `RANK()` or `DENSE_RANK()` if tie handling is part of the requirement.

---

## 8. Running Totals and Cumulative Metrics

### Example: cumulative revenue per user

    SELECT
        user_id,
        order_ts,
        amount,
        SUM(amount) OVER (
            PARTITION BY user_id
            ORDER BY order_ts
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_amount
    FROM orders;

### Important

Be explicit about frame when needed.

Some candidates forget that frame defaults can matter.

### Strong line

> For cumulative metrics, I prefer to specify the frame explicitly so the behavior is clear and not left to defaults.

---

## 9. LAG / LEAD

Used for:
- previous row comparisons
- detecting change
- sessionization
- time gaps

### Example: previous order timestamp

    SELECT
        user_id,
        order_ts,
        LAG(order_ts) OVER (
            PARTITION BY user_id
            ORDER BY order_ts
        ) AS prev_order_ts
    FROM orders;

### Example: time since previous event

    SELECT
        user_id,
        event_ts,
        DATEDIFF(
            'minute',
            LAG(event_ts) OVER (
                PARTITION BY user_id
                ORDER BY event_ts
            ),
            event_ts
        ) AS minutes_since_prev
    FROM events;

### Common interview use case

Detect gaps larger than 30 minutes to define sessions.

---

## 10. Sessionization Pattern

Example:
Start a new session if time gap > 30 min.

    WITH events_with_gap AS (
        SELECT
            user_id,
            event_ts,
            CASE
                WHEN LAG(event_ts) OVER (
                    PARTITION BY user_id
                    ORDER BY event_ts
                ) IS NULL THEN 1
                WHEN DATEDIFF(
                    'minute',
                    LAG(event_ts) OVER (
                        PARTITION BY user_id
                        ORDER BY event_ts
                    ),
                    event_ts
                ) > 30 THEN 1
                ELSE 0
            END AS is_new_session
        FROM events
    )
    SELECT
        user_id,
        event_ts,
        SUM(is_new_session) OVER (
            PARTITION BY user_id
            ORDER BY event_ts
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS session_number
    FROM events_with_gap;

### Senior insight

This is a classic pattern:
- identify session boundary
- cumulative sum of boundary flag

---

## 11. Percent of Total / Share of Group

### Example: product revenue share within category

    SELECT
        category_id,
        product_id,
        revenue,
        revenue / SUM(revenue) OVER (
            PARTITION BY category_id
        ) AS revenue_share
    FROM product_revenue;

### Why this matters

Shows understanding of:
- windows without collapsing rows
- avoiding self-joins

---

## 12. JOIN Patterns — Core Mental Model

Interviewers test whether you understand:
- join cardinality
- grain mismatch
- null behavior
- accidental duplication

Before any join, define:
- left table grain
- right table grain
- expected output grain

### Strong interview line

> Before joining, I define the grain on both sides and the intended grain of the output, because most join bugs come from hidden one-to-many or many-to-many expansions.

---

## 13. INNER vs LEFT JOIN — What Really Matters

### INNER JOIN

Returns only matching rows.

    SELECT
        o.order_id,
        c.customer_name
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id;

### LEFT JOIN

Keeps all rows from the left side.

    SELECT
        o.order_id,
        c.customer_name
    FROM orders o
    LEFT JOIN customers c
        ON o.customer_id = c.customer_id;

### Common interview trap

Filtering the right-side table in `WHERE` can accidentally turn `LEFT JOIN` into `INNER JOIN`.

Wrong:

    SELECT
        o.order_id,
        c.customer_name
    FROM orders o
    LEFT JOIN customers c
        ON o.customer_id = c.customer_id
    WHERE c.status = 'ACTIVE';

Because rows where `c` is null get removed.

Better:

    SELECT
        o.order_id,
        c.customer_name
    FROM orders o
    LEFT JOIN customers c
        ON o.customer_id = c.customer_id
       AND c.status = 'ACTIVE';

### Senior insight

Filtering conditions on the right side of a `LEFT JOIN` often belong in the `ON` clause, not `WHERE`, if you want to preserve unmatched left rows.

---

## 14. Semi-Join and Anti-Join Patterns

These are frequently tested even if not named explicitly.

### Semi-join: rows with a match

    SELECT *
    FROM customers c
    WHERE EXISTS (
        SELECT 1
        FROM orders o
        WHERE o.customer_id = c.customer_id
    );

### Anti-join: rows without a match

    SELECT *
    FROM customers c
    WHERE NOT EXISTS (
        SELECT 1
        FROM orders o
        WHERE o.customer_id = c.customer_id
    );

### Why `NOT EXISTS` is strong

Safer than `NOT IN` when nulls may exist.

### Common trap with `NOT IN`

If subquery returns null, behavior can become unintuitive.

### Strong interview line

> For anti-joins, I generally prefer `NOT EXISTS` over `NOT IN` because it behaves more safely in the presence of nulls.

---

## 15. Many-to-Many Join Explosion

One of the most common causes of wrong results.

Example:
orders joined to events by `user_id`

If both tables have multiple rows per user, join explodes:

    SELECT *
    FROM orders o
    JOIN events e
        ON o.user_id = e.user_id;

This may produce:
- duplicate business rows
- inflated counts
- wrong sums

### Fix patterns

- dedupe first
- aggregate first
- join at correct grain

Example:
latest event per user first, then join

    WITH latest_event AS (
        SELECT
            user_id,
            event_ts
        FROM events
        QUALIFY ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY event_ts DESC
        ) = 1
    )
    SELECT
        o.order_id,
        o.user_id,
        l.event_ts
    FROM orders o
    LEFT JOIN latest_event l
        ON o.user_id = l.user_id;

### Strong interview line

> If I see potential many-to-many join risk, I either aggregate or deduplicate to the intended join grain before joining.

---

## 16. Aggregation Traps

These are classic interview traps.

### Trap 1 — joining before aggregating

Wrong:

    SELECT
        c.customer_id,
        SUM(o.amount) AS total_amount
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items i
        ON o.order_id = i.order_id
    GROUP BY c.customer_id;

If `orders` is joined to `order_items`, each order may be repeated.

Fix:
aggregate order-level metrics before joining to item-level data or use the correct grain.

### Trap 2 — counting after duplicate join

    COUNT(*) 

may count exploded rows, not business entities.

Use:
- `COUNT(DISTINCT ...)` when appropriate
- or better, correct the grain before counting

### Trap 3 — averaging averages

Wrong:

    AVG(avg_order_value)

from pre-aggregated groups unless weighting is correct.

### Senior insight

Most aggregation mistakes are grain mistakes.

---

## 17. COUNT(*) vs COUNT(col) vs COUNT(DISTINCT)

### `COUNT(*)`
Counts rows.

### `COUNT(col)`
Counts non-null values in that column.

### `COUNT(DISTINCT col)`
Counts unique non-null values.

### Interview trap

If joins create duplicates:
- `COUNT(*)` may explode
- `COUNT(DISTINCT)` may hide but not solve the underlying issue

### Strong line

> I use `COUNT(DISTINCT)` only when the business metric is truly distinct-count based, not as a band-aid for incorrect join grain.

---

## 18. Conditional Aggregation

Very common in interviews.

### Example

    SELECT
        user_id,
        SUM(CASE WHEN status = 'paid' THEN amount ELSE 0 END) AS paid_amount,
        SUM(CASE WHEN status = 'refunded' THEN amount ELSE 0 END) AS refunded_amount
    FROM payments
    GROUP BY user_id;

### Why important

- simpler than multiple joins
- efficient
- expressive

---

## 19. QUALIFY + Aggregation Combo

Sometimes you need both aggregation and window logic.

Example:
latest order per customer after aggregating order lines

    WITH order_totals AS (
        SELECT
            order_id,
            customer_id,
            SUM(amount) AS order_total,
            MAX(order_ts) AS order_ts
        FROM order_lines
        GROUP BY order_id, customer_id
    )
    SELECT
        customer_id,
        order_id,
        order_total,
        order_ts
    FROM order_totals
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY order_ts DESC
    ) = 1;

### Senior insight

First fix the grain, then rank.

---

## 20. SCD Type 1 Pattern

Type 1 = overwrite with latest value.

Example:
keep latest customer record per customer_id

    SELECT
        customer_id,
        customer_name,
        status,
        updated_at
    FROM customer_updates
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY updated_at DESC
    ) = 1;

### Usage

- current-state dimension
- no history preserved

---

## 21. SCD Type 2 Pattern — Conceptual SQL

Type 2 = preserve history with effective dates.

Basic idea:
- identify change boundaries
- assign valid_from / valid_to
- mark current row

Example pattern:

    WITH ordered_changes AS (
        SELECT
            customer_id,
            status,
            updated_at AS valid_from,
            LEAD(updated_at) OVER (
                PARTITION BY customer_id
                ORDER BY updated_at
            ) AS next_change_ts
        FROM customer_updates
    )
    SELECT
        customer_id,
        status,
        valid_from,
        next_change_ts AS valid_to,
        CASE WHEN next_change_ts IS NULL THEN TRUE ELSE FALSE END AS is_current
    FROM ordered_changes;

### Important

Real SCD2 often also requires:
- change detection across attributes
- surrogate keys
- dedup of same-value updates
- handling late-arriving data

### Strong interview line

> For SCD Type 2, the core pattern is identifying change points and using `LEAD()` to derive the validity window, but in production I would also handle no-op updates, late-arriving records, and deterministic tie-breaking.

---

## 22. Change Detection Pattern

A common interview problem:
detect when a value changed from previous row.

    SELECT
        customer_id,
        status,
        updated_at,
        CASE
            WHEN LAG(status) OVER (
                PARTITION BY customer_id
                ORDER BY updated_at
            ) IS NULL THEN 1
            WHEN LAG(status) OVER (
                PARTITION BY customer_id
                ORDER BY updated_at
            ) <> status THEN 1
            ELSE 0
        END AS is_status_change
    FROM customer_updates;

This is often a building block for SCD2.

---

## 23. First / Last Value Pitfalls

`FIRST_VALUE` and `LAST_VALUE` are tricky because frame defaults matter.

Example:

    SELECT
        user_id,
        order_ts,
        FIRST_VALUE(order_ts) OVER (
            PARTITION BY user_id
            ORDER BY order_ts
        ) AS first_order_ts
    FROM orders;

`LAST_VALUE` is more dangerous because default frame can make it look like “current row” instead of true last row in partition.

Safer:

    SELECT
        user_id,
        order_ts,
        LAST_VALUE(order_ts) OVER (
            PARTITION BY user_id
            ORDER BY order_ts
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS last_order_ts
    FROM orders;

### Senior insight

> With `LAST_VALUE`, I prefer to specify the frame explicitly because default window frames often surprise people.

---

## 24. NULL Handling in SQL Interviews

Common pitfalls:
- `NULL = NULL` is not true
- `NOT IN` with nulls
- join keys containing nulls
- aggregate behavior with nulls

### Examples

`COUNT(col)` ignores nulls  
`COUNT(*)` does not

`SUM(col)` ignores nulls, but all-null groups may produce null

### Strong line

> I always check how nulls affect joins, filters, and anti-joins, because null semantics often break seemingly correct SQL.

---

## 25. Common Tricky Interview Cases

### Case 1 — latest record per user
Use:
- `ROW_NUMBER()`
- `QUALIFY`
- tie-breaker

### Case 2 — top 3 per category
Use:
- `ROW_NUMBER()` or `RANK()`
- explain ties

### Case 3 — users without orders
Use:
- `NOT EXISTS`

### Case 4 — revenue per customer with item-level table
Define grain first, then aggregate

### Case 5 — detect user status changes
Use:
- `LAG()`

### Case 6 — build sessions
Use:
- `LAG()`
- boundary flag
- cumulative sum

### Case 7 — SCD2
Use:
- change detection
- `LEAD()`
- valid_from / valid_to

---

## 26. Strong Snowflake-Specific SQL Patterns

### Use QUALIFY for ranking filters

    SELECT ...
    QUALIFY ROW_NUMBER() OVER (...) = 1;

### Prefer readable CTEs for grain isolation

    WITH order_totals AS (...),
         latest_order AS (...)
    SELECT ...

### Use deterministic ordering in window functions

    ORDER BY updated_at DESC, ingest_ts DESC

### Mention output grain before writing SQL

This sounds senior.

---

## 27. Common Weak Answers vs Strong Answers

### Weak

> I’ll use DISTINCT.

### Strong

> I would first define whether duplicates are technical or business duplicates. If I need one record per business key, I would use `ROW_NUMBER()` with a deterministic ordering rule rather than relying on `DISTINCT`.

### Weak

> I’ll use COUNT(DISTINCT).

### Strong

> I would first confirm whether duplicates come from the business data or from join expansion. If the latter, I would fix the join grain instead of hiding the problem with `COUNT(DISTINCT)`.

### Weak

> I’ll do a LEFT JOIN and filter after.

### Strong

> If I need to preserve unmatched left rows, I’m careful not to place right-side filters in the `WHERE` clause, because that can accidentally turn the left join into an inner join.

---

## 28. Strong Interview Phrases

Use phrases like:

- “First I would define the grain of the result.”
- “I want a deterministic tie-breaker here.”
- “This join has potential many-to-many explosion.”
- “I would aggregate or deduplicate before joining.”
- “I would use `QUALIFY` here because this is Snowflake.”
- “I want to avoid using `COUNT(DISTINCT)` as a band-aid.”
- “This is really a grain problem, not an aggregation problem.”
- “I would be careful with null semantics here.”

---

## 29. One-Page Recap

- `ROW_NUMBER()` = exact one row per group
- `RANK()` / `DENSE_RANK()` = ties handling
- `QUALIFY` = filter on window functions cleanly
- dedup = business key + tie-breaker
- top N = rank within partition
- `LAG()` / `LEAD()` = change and sequence logic
- sessionization = gap detection + cumulative sum
- joins = always define grain first
- anti-join = prefer `NOT EXISTS`
- aggregation errors usually come from grain mismatch
- SCD2 = change detection + validity windows
- `COUNT(DISTINCT)` should not hide bad join logic

---

## 30. Final One-Line Summary

Strong SQL interview performance comes from one habit: define the grain first, then use window functions, joins, and aggregations in a way that preserves that grain intentionally.