# Snowflake Semi-Structured Data — Complete Guide (Senior Cheat Sheet)

## 1. Core Data Types

Snowflake semi-structured data is built around:

- `VARIANT`
- `OBJECT`
- `ARRAY`

### Key points

- `VARIANT` can store values of other data types, including `OBJECT` and `ARRAY`
- `OBJECT` stores key-value pairs
- `ARRAY` stores ordered elements
- `VARIANT` values can hold up to 128 MB of uncompressed data, though the practical limit is often lower because of overhead

### Interview answer

> In Snowflake, semi-structured data is usually stored in `VARIANT`, which can contain scalars, objects, and arrays. `OBJECT` and `ARRAY` are the structural building blocks, while `VARIANT` acts as the flexible container for hierarchical payloads.

---

## 2. Creating and Loading Semi-Structured Data

### Create raw table

    CREATE OR REPLACE TABLE raw_events (
        event_id STRING,
        payload VARIANT
    );

### Parse JSON text into VARIANT

    INSERT INTO raw_events
    SELECT
        'evt_1',
        PARSE_JSON('{
          "user_id": 123,
          "device": {"os": "ios", "version": "17"},
          "items": [
            {"sku": "A1", "qty": 2},
            {"sku": "B2", "qty": 1}
          ]
        }');

### Important distinction

- `PARSE_JSON` parses JSON text into structured semi-structured data
- `TO_VARIANT` wraps a value as `VARIANT`, but does not parse JSON text the same way

Example:

    SELECT PARSE_JSON('{"a":1}');
    SELECT TO_VARIANT('{"a":1}');

Use `PARSE_JSON` for JSON strings, not `TO_VARIANT`.

---

## 3. Accessing Nested Fields

Snowflake supports path navigation on semi-structured data.

### Common patterns

#### Colon notation

    SELECT payload:user_id
    FROM raw_events;

#### Dot notation

    SELECT payload:device.os
    FROM raw_events;

#### Array element access

    SELECT payload:items[0]
    FROM raw_events;

#### Nested object inside array

    SELECT payload:items[0].sku
    FROM raw_events;

### Best practice: cast explicitly

    SELECT
        payload:user_id::NUMBER     AS user_id,
        payload:device.os::STRING   AS device_os,
        payload:items[0].sku::STRING AS first_sku
    FROM raw_events;

### Why explicit cast matters

Without casting:
- values remain semi-structured
- strings may appear with quotes
- downstream SQL becomes less predictable

### Interview answer

> I usually extract fields with path notation and cast them immediately into typed columns, because that makes transformations, joins, and downstream analytics cleaner and more predictable.

---

## 4. Useful Core Functions

### `PARSE_JSON`

    SELECT PARSE_JSON('{"a":1,"b":[10,20]}');

Use for:
- loading JSON strings into `VARIANT`

### `TO_VARIANT`

    SELECT TO_VARIANT('hello');

Use for:
- wrapping a scalar or SQL value as `VARIANT`

### `OBJECT_CONSTRUCT`

    SELECT OBJECT_CONSTRUCT(
        'user_id', 123,
        'country', 'PL'
    );

Use for:
- building JSON-like objects in SQL

### `ARRAY_CONSTRUCT`

    SELECT ARRAY_CONSTRUCT('a', 'b', 'c');

Use for:
- building arrays

### `ARRAY_FLATTEN`

    SELECT ARRAY_FLATTEN(
        ARRAY_CONSTRUCT(
            ARRAY_CONSTRUCT(1,2),
            ARRAY_CONSTRUCT(3,4)
        )
    );

Use for:
- flattening one level of nested arrays inside a value

### Additional useful helper functions

- `TYPEOF(...)`
- casts like `::STRING`, `::NUMBER`, `::BOOLEAN`, `::TIMESTAMP_NTZ`

---

## 5. FLATTEN — Most Important Concept

`FLATTEN` is a table function that explodes `VARIANT`, `OBJECT`, or `ARRAY` values into rows.

This is the key tool for working with nested arrays and objects.

### Basic example

    SELECT
        r.event_id,
        f.index,
        f.value
    FROM raw_events r,
    LATERAL FLATTEN(input => r.payload:items) f;

### What happens

If `items` is:

    [
      {"sku":"A1","qty":2},
      {"sku":"B2","qty":1}
    ]

then `FLATTEN` returns:

- one row for `{"sku":"A1","qty":2}`
- one row for `{"sku":"B2","qty":1}`

### Parse flattened values

    SELECT
        r.event_id,
        f.index AS item_pos,
        f.value:sku::STRING AS sku,
        f.value:qty::NUMBER AS qty
    FROM raw_events r,
    LATERAL FLATTEN(input => r.payload:items) f;

### Output columns from FLATTEN

Common output columns include:
- `SEQ`
- `KEY`
- `PATH`
- `INDEX`
- `VALUE`
- `THIS`

### Interview answer

> `FLATTEN` is the standard way to explode nested arrays or objects into rows in Snowflake. I usually combine it with `LATERAL` so the flatten operation stays correlated to the original row.

---

## 6. Why LATERAL Matters

`FLATTEN` is typically used as a lateral table function.

Example:

    FROM raw_events r,
    LATERAL FLATTEN(input => r.payload:items) f

This means:
- for each row in `raw_events`
- flatten that row’s own `payload:items`

So `LATERAL` keeps the flatten operation tied to the current row from the left side.

### Practical meaning

Without this correlation, you would not correctly explode each row’s own nested array.

### Interview answer

> I use `LATERAL FLATTEN` because the flatten operation needs access to the current source row. It is effectively a correlated expansion of nested data per row.

---

## 7. Important FLATTEN Options

### `INPUT`

The value to flatten.

    LATERAL FLATTEN(input => r.payload:items)

### `PATH`

Instead of flattening the whole value, flatten a specific nested path.

    SELECT *
    FROM raw_events r,
    LATERAL FLATTEN(input => r.payload, path => 'items') f;

### `OUTER => TRUE`

Preserve rows even if the array/path is empty or missing.

    SELECT
        r.event_id,
        f.value
    FROM raw_events r,
    LATERAL FLATTEN(input => r.payload:items, outer => TRUE) f;

Use this when:
- some rows have no items
- you do not want those rows to disappear

### `RECURSIVE => TRUE`

Traverse nested structures recursively.

    SELECT
        f.path,
        f.key,
        f.index,
        f.value
    FROM raw_events r,
    LATERAL FLATTEN(input => r.payload, recursive => TRUE) f;

Use for:
- exploring unknown JSON
- debugging nested payloads
- discovering nested paths

### `MODE`

Controls whether flatten targets:
- `OBJECT`
- `ARRAY`
- `BOTH`

---

## 8. Flattening Nested Arrays

Real payloads often contain arrays inside arrays.

Example payload:

    {
      "order_id": 10,
      "items": [
        {
          "sku": "A1",
          "discounts": [
            {"code":"X","amt":5},
            {"code":"Y","amt":2}
          ]
        },
        {
          "sku": "B2",
          "discounts": [
            {"code":"Z","amt":1}
          ]
        }
      ]
    }

To flatten nested arrays, chain multiple `LATERAL FLATTEN` calls:

    SELECT
        r.event_id,
        item.value:sku::STRING AS sku,
        disc.value:code::STRING AS discount_code,
        disc.value:amt::NUMBER AS discount_amt
    FROM raw_events r,
    LATERAL FLATTEN(input => r.payload:items) item,
    LATERAL FLATTEN(input => item.value:discounts) disc;

### Logic

1. first flatten `items`
2. then flatten `discounts` inside each item

### Important warning

Multiple flatten operations can multiply row counts quickly.

---

## 9. Flattening Objects

`FLATTEN` also works on objects.

Example payload:

    {
      "metrics": {
        "clicks": 10,
        "views": 100,
        "ctr": 0.1
      }
    }

Query:

    SELECT
        r.event_id,
        f.key,
        f.value
    FROM raw_events r,
    LATERAL FLATTEN(input => r.payload:metrics) f;

Result:
- `clicks → 10`
- `views → 100`
- `ctr → 0.1`

This is useful when:
- object keys are dynamic
- metrics are not fixed as columns

---

## 10. FLATTEN + JOIN

A common production pattern:
- flatten nested array
- join flattened elements to relational dimensions

Example:

    CREATE OR REPLACE TABLE dim_products (
        sku STRING,
        product_name STRING
    );

    SELECT
        o.event_id,
        i.value:sku::STRING AS sku,
        p.product_name,
        i.value:qty::NUMBER AS qty
    FROM raw_events o,
    LATERAL FLATTEN(input => o.payload:items) i
    LEFT JOIN dim_products p
        ON p.sku = i.value:sku::STRING;

### Typical use cases

- items joined to product dimension
- device IDs joined to device lookup
- nested user attributes joined to reference data

---

## 11. FLATTEN + WHERE

You can filter flattened rows like any other relational output.

    SELECT
        r.event_id,
        f.value:sku::STRING AS sku,
        f.value:qty::NUMBER AS qty
    FROM raw_events r,
    LATERAL FLATTEN(input => r.payload:items) f
    WHERE f.value:qty::NUMBER > 1;

This is common for:
- keeping only some nested records
- filtering noisy arrays
- extracting specific nested elements

---

## 12. Recursive Exploration Pattern

When the payload is unfamiliar, use recursive flatten first.

    SELECT
        f.path,
        f.key,
        f.index,
        f.value
    FROM raw_events r,
    LATERAL FLATTEN(input => r.payload, recursive => TRUE) f;

This is useful for:
- exploring unknown schema
- debugging new upstream payloads
- identifying paths for staging models

### Senior habit

Before writing complex extraction logic, inspect the payload recursively.

---

## 13. Typical Staging Pattern

A good production pattern is:

### Raw table

    CREATE OR REPLACE TABLE raw_events (
        event_id STRING,
        payload VARIANT
    );

### Staging model for scalar fields

    CREATE OR REPLACE VIEW stg_events AS
    SELECT
        event_id,
        payload:user_id::NUMBER AS user_id,
        payload:device.os::STRING AS device_os,
        payload:event_ts::TIMESTAMP_NTZ AS event_ts
    FROM raw_events;

### Exploded child model for arrays

    CREATE OR REPLACE VIEW stg_event_items AS
    SELECT
        r.event_id,
        f.index AS item_index,
        f.value:sku::STRING AS sku,
        f.value:qty::NUMBER AS qty
    FROM raw_events r,
    LATERAL FLATTEN(input => r.payload:items) f;

### Why this pattern is good

- keeps raw flexible
- makes analytics typed and predictable
- avoids flattening everything in every downstream query
- improves readability and reuse

### Interview answer

> I usually keep raw JSON in `VARIANT`, extract frequently used scalar fields into typed staging models, and create separate exploded child models for nested arrays. That gives a good balance between schema flexibility and analytical usability.

---

## 14. Performance Considerations

Semi-structured data is flexible, but not always the cheapest analytical layout.

### Important points

- data loaded into `VARIANT` can perform similarly to relational storage for regular JSON-native types
- non-native values such as dates/timestamps stored as strings can be slower and larger than typed relational columns
- frequently queried fields are often better extracted into typed columns
- repeated flattening in every query can be expensive
- flattening nested arrays can explode row counts dramatically

### Good practice

- keep raw payload in `VARIANT`
- extract high-value fields into typed staging/intermediate models
- explode arrays once in reusable models instead of repeatedly in BI queries

### Interview answer

> I use `VARIANT` for flexibility at ingestion time, but I do not keep everything purely semi-structured forever. For high-usage fields and repeated analytical access, I extract typed columns or child tables to improve maintainability and performance.

---

## 15. Null Handling

Snowflake distinguishes between:
- SQL `NULL`
- JSON `null`

These are not the same thing.

This matters when:
- constructing objects
- checking missing vs explicit null values
- comparing values in `VARIANT`

### Practical reminder

Do not assume that a missing field and a JSON `null` mean the same business thing.

---

## 16. Common Mistakes

### 1. Not casting extracted values

Weak:

    SELECT payload:user_id
    FROM raw_events;

Better:

    SELECT payload:user_id::NUMBER AS user_id
    FROM raw_events;

### 2. Using VARIANT forever

Flexible, but bad for:
- repeated BI queries
- clean joins
- typed analytics
- governance

### 3. Forgetting `OUTER => TRUE`

If arrays can be empty, rows may disappear unexpectedly.

### 4. Ignoring row explosion

Each extra `FLATTEN` can multiply rows.

### 5. Mixing parsing, flattening, business logic, and joins in one giant query

Better:
- raw
- staging extraction
- exploded child models
- marts

### 6. Assuming `TO_VARIANT` and `PARSE_JSON` are interchangeable

They are not.

---

## 17. Patterns You Should Know for Interviews

### Pattern 1 — Extract scalar fields

    SELECT
        payload:user_id::NUMBER AS user_id,
        payload:device.os::STRING AS os
    FROM raw_events;

### Pattern 2 — Explode array

    SELECT
        r.event_id,
        f.value:sku::STRING AS sku
    FROM raw_events r,
    LATERAL FLATTEN(input => r.payload:items) f;

### Pattern 3 — Two-level explode

    SELECT
        r.event_id,
        item.value:sku::STRING AS sku,
        disc.value:code::STRING AS discount_code
    FROM raw_events r,
    LATERAL FLATTEN(input => r.payload:items) item,
    LATERAL FLATTEN(input => item.value:discounts) disc;

### Pattern 4 — Explore unknown payload

    SELECT
        f.path,
        f.key,
        f.index,
        f.value
    FROM raw_events r,
    LATERAL FLATTEN(input => r.payload, recursive => TRUE) f;

### Pattern 5 — Keep parent rows with empty arrays

    SELECT
        r.event_id,
        f.value
    FROM raw_events r,
    LATERAL FLATTEN(input => r.payload:items, outer => TRUE) f;

---

## 18. Strong Interview Answers

### Q: How do you work with semi-structured data in Snowflake?

> I usually store raw payloads in `VARIANT`, extract scalar fields using path notation and explicit casts, and use `LATERAL FLATTEN` to explode nested arrays or objects into rows. For multi-level nesting, I chain multiple flatten operations. In production, I keep raw JSON flexible, but I move frequently used fields into typed staging or child models so downstream analytics is cleaner and faster.

### Q: Why use LATERAL FLATTEN?

> Because `FLATTEN` needs to stay correlated to the source row. `LATERAL` lets Snowflake evaluate the flatten function for each input row and expand only that row’s nested structure.

### Q: How do you handle deeply nested payloads?

> I first inspect the payload with recursive flatten, then build staged extraction models. I avoid pushing repeated multi-level flatten logic into BI queries and instead materialize reusable exploded layers.

---

## 19. One-Page Recap

- `VARIANT` = main semi-structured container
- `OBJECT` = key-value structure
- `ARRAY` = ordered collection
- `PARSE_JSON` = parse JSON string into `VARIANT`
- `TO_VARIANT` = wrap value as `VARIANT`
- path extraction = `payload:a.b[0]`
- cast extracted values explicitly
- `FLATTEN` = explode arrays/objects into rows
- `LATERAL` = correlate flatten to each input row
- nested arrays = multiple `LATERAL FLATTEN`
- `OUTER => TRUE` keeps rows with empty/missing arrays
- `RECURSIVE => TRUE` is great for exploration
- raw stays flexible, staging becomes typed
- repeated flattening should usually be moved into reusable models

---

## 20. Final One-Line Summary

Snowflake semi-structured work is mostly about three things: store flexibly in `VARIANT`, extract predictably with typed paths, and normalize nested arrays/objects with `LATERAL FLATTEN`.