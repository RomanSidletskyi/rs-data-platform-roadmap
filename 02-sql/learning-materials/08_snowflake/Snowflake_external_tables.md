# Snowflake External Tables

## 1. Why This Topic Matters

Not every dataset should be loaded into native warehouse tables immediately.

Sometimes you need to:

- inspect files where they already live
- expose a raw or lightly structured dataset quickly
- avoid full ingestion before understanding the data
- query lake storage directly from Snowflake

That is where external tables fit.

They give Snowflake a table-like view over files in external storage.

The key phrase is table-like.

They are useful, but they are not the same as a fully managed warehouse table.

---

## 2. What An External Table Is

An external table is metadata in Snowflake that points to files in external storage.

Snowflake does not first copy those files into native table storage.

Instead, it keeps metadata about file locations and presents a queryable object.

Mental model:

- stage = access path to storage
- external table = queryable metadata layer above staged files

---

## 3. What It Is Good For

External tables are strong when you need:

- rapid exposure of lake files to SQL users
- low-friction access to raw or semi-structured data
- staged discovery before building a real ingestion model
- path-based partitioning over object storage

They are weaker when you need:

- heavy warehouse-optimized performance
- strong mutation semantics
- rich table lifecycle management
- stable modeled serving layers for many consumers

---

## 4. What It Is Not

An external table is not:

- a replacement for every raw ingestion table
- a strong curated serving layer by default
- a substitute for proper contracts and modeled schemas
- a magical way to get native-table performance on arbitrary files

If the dataset becomes central to reporting or joins, loading it into native tables or publishing it as Iceberg may be the better design.

---

## 5. Core Building Blocks

You usually need:

- storage integration
- external stage
- file format
- external table definition

### 5.1 Storage integration

Representative example:

```sql
CREATE OR REPLACE STORAGE INTEGRATION raw_s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('s3://company-raw/');
```

Why it matters:

- keeps credentials out of ad hoc SQL
- makes bucket access a governed platform object

### 5.2 External stage

```sql
CREATE OR REPLACE STAGE raw_orders_stage
  URL = 's3://company-raw/orders/'
  STORAGE_INTEGRATION = raw_s3_int;
```

### 5.3 File format

```sql
CREATE OR REPLACE FILE FORMAT ff_json_orders
  TYPE = JSON;
```

---

## 6. Create An External Table

Representative JSON example:

```sql
CREATE OR REPLACE EXTERNAL TABLE ext_raw.orders_json (
    order_date DATE AS TO_DATE(SPLIT_PART(METADATA$FILENAME, '/', 3)),
    order_id STRING AS (VALUE:order_id::STRING),
    customer_id STRING AS (VALUE:customer_id::STRING),
    order_ts TIMESTAMP_NTZ AS (VALUE:order_ts::TIMESTAMP_NTZ),
    amount NUMBER(18,2) AS (VALUE:amount::NUMBER(18,2)),
    status STRING AS (VALUE:status::STRING)
)
WITH LOCATION = @raw_orders_stage
FILE_FORMAT = (FORMAT_NAME = ff_json_orders)
PATTERN = '.*[.]json';
```

What this does:

- points to files in the stage
- maps file content into columns
- derives one partition-like attribute from the file path

Architecture note:

- file layout becomes part of table design
- if your folder naming is chaotic, your external table design will also be chaotic

---

## 7. Query Pattern

```sql
SELECT
    order_date,
    status,
    COUNT(*) AS orders_cnt,
    SUM(amount) AS total_amount
FROM ext_raw.orders_json
WHERE order_date >= '2026-03-01'
GROUP BY order_date, status
ORDER BY order_date, status;
```

This is useful for:

- fast validation
- raw-zone profiling
- operational debugging
- lightweight exploration before ingestion design is finalized

---

## 8. Metadata Columns Matter

Snowflake metadata columns are one of the most practical reasons to like external file-based patterns.

Important examples:

- `METADATA$FILENAME`
- `METADATA$FILE_LAST_MODIFIED`

Representative example:

```sql
SELECT
    METADATA$FILENAME AS src_file,
    COUNT(*) AS row_cnt,
    MIN(order_ts) AS min_order_ts,
    MAX(order_ts) AS max_order_ts
FROM ext_raw.orders_json
GROUP BY METADATA$FILENAME
ORDER BY src_file;
```

Use cases:

- detect duplicate file delivery
- check whether late-arriving files landed
- explain strange data spikes to operators

---

## 9. External Tables vs `COPY INTO`

This is a core architectural decision.

### External tables

Use when:

- you want to query files in place
- you are still exploring or lightly consuming data
- freshness comes from file visibility, not loaded tables

### `COPY INTO`

Use when:

- you want native Snowflake table performance
- you need stronger modeled raw tables
- the data becomes part of stable warehouse transformations

Short rule:

- external table = access without loading
- `COPY INTO` = ingest into warehouse-native operational tables

---

## 10. External Tables vs Snowflake-managed Iceberg

### External tables

- file-oriented access layer
- lighter governance semantics
- often best for raw exploration or simple query exposure

### Snowflake-managed Iceberg

- table-format contract above files
- stronger open-table semantics
- better fit for curated published datasets

If external tables help you read the lake, Iceberg helps you publish a real table in the lake.

---

## 11. Good Architecture Pattern

Pattern:

- raw partner files land in object storage
- Snowflake external tables expose them immediately for validation
- once schema and quality rules are clear, `COPY INTO` loads them into native raw tables
- downstream models operate on native or curated publish tables, not directly on raw external files forever

Why this is strong:

- fast onboarding of new feeds
- controlled move from discovery to managed ingestion
- external tables stay at the boundary where they are most useful

---

## 12. Bad Architecture Pattern

Pattern:

- external tables become the permanent main serving layer for dashboards, finance reporting, and complex joins

Why this is bad:

- performance depends heavily on raw file shape
- consumer contracts stay weak
- debugging file-layout drift becomes a business-facing problem
- transformations become too tightly coupled to lake path structure

External tables are often a boundary tool, not a final semantic layer.

---

## 13. Practical File Layout Rules

Strong layout example:

```text
s3://company-raw/orders/dt=2026-03-20/hour=10/part-0001.json
s3://company-raw/orders/dt=2026-03-20/hour=11/part-0001.json
s3://company-raw/orders/dt=2026-03-21/hour=09/part-0001.json
```

Why this is good:

- path-derived filters are understandable
- partition-like pruning is possible
- operational debugging is easier

Weak layout example:

```text
s3://company-raw/orders/final/new/latest/retry/fix1/file.json
```

Why this is bad:

- impossible to reason about logically
- path semantics are unstable
- partition expressions become brittle

---

## 14. Cookbook: Rapidly Expose A New Partner Feed

Scenario:

- a partner drops daily JSON files in S3
- analysts want same-day visibility
- engineering does not yet trust the schema enough to model a raw ingestion table immediately

Recipe:

1. Create storage integration and stage.
2. Create a JSON file format.
3. Define an external table with explicit casts.
4. Profile row counts, null rates, and filename-level distribution.
5. Once the feed stabilizes, move to `COPY INTO` native raw tables.

Representative profiling query:

```sql
SELECT
    order_date,
    COUNT(*) AS rows_cnt,
    COUNT_IF(order_id IS NULL) AS null_order_id_cnt,
    COUNT(DISTINCT METADATA$FILENAME) AS files_cnt,
    SUM(amount) AS gross_amount
FROM ext_raw.orders_json
GROUP BY order_date
ORDER BY order_date;
```

Why this recipe works:

- exploration happens quickly
- ingestion design is based on real feed behavior
- the team avoids locking a bad schema into native tables too early

---

## 15. Cookbook: Build A Controlled Raw Ingestion Handoff

Scenario:

- external table already exists
- now the feed is stable enough for managed warehouse ingestion

Recipe:

```sql
CREATE OR REPLACE TABLE raw.orders_ingested (
    order_id STRING,
    customer_id STRING,
    order_ts TIMESTAMP_NTZ,
    amount NUMBER(18,2),
    status STRING,
    src_file STRING,
    load_ts TIMESTAMP_NTZ
);

INSERT INTO raw.orders_ingested
SELECT
    order_id,
    customer_id,
    order_ts,
    amount,
    status,
    METADATA$FILENAME,
    CURRENT_TIMESTAMP()
FROM ext_raw.orders_json
WHERE order_date = CURRENT_DATE - 1;
```

This handoff is useful when you want:

- stable warehouse tables for joins and downstream transforms
- explicit ingestion timestamps
- repeatable replay logic

---

## 16. Common Failure Modes

### 1. Using external tables as a permanent substitute for modeling

Result:

- weak semantic layer

### 2. Ignoring file layout design

Result:

- poor partition pruning and hard debugging

### 3. No cast discipline

Result:

- type ambiguity leaks into downstream logic

### 4. No boundary between exploration and production

Result:

- ad hoc raw access becomes accidental production architecture

---

## 17. Decision Heuristics

Choose external tables when:

- you need fast raw exposure
- the dataset is still exploratory or boundary-facing
- you want SQL access before full ingestion modeling

Choose native raw tables when:

- the data is operationally important inside Snowflake
- downstream joins and transformations depend on it heavily
- you need stronger performance and data-management control

Choose Snowflake-managed Iceberg when:

- the output should stay open-format as a durable published table

---

## 18. Interview-Ready Summary

Strong short answer:

> I use external tables when I need governed SQL access to files in object storage without immediately loading them into native Snowflake tables. They are strong for discovery, raw-zone exposure, and boundary access. I do not treat them as the default final serving layer for core analytics models.

Architect takeaway:

- external tables are excellent at exposing files
- native tables are excellent at powering warehouse operations
- Iceberg is better when the business need is an open managed table, not just file access