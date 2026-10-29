# Snowflake External Tables Interview Cheat Sheet

## What external tables are

A Snowflake external table lets Snowflake query files stored outside Snowflake storage, typically in S3, ADLS, or GCS.

It is useful when you want metadata-managed access to external files without first loading everything into native Snowflake tables.

## Key Interview Questions And Answers

### 1. What is a Snowflake external table?

A Snowflake external table is metadata in Snowflake that maps to files in external object storage.

It allows SQL access to those files while the data physically remains outside Snowflake-managed storage.

### 2. When would you use an external table?

Good use cases:

- quick access to raw files
- exploration of partner-delivered data
- staged ingestion layers
- cases where data should remain in object storage first

### 3. When is an external table a weak fit?

It is a weak fit when you need:

- strong warehouse-managed performance for repeated heavy analytics
- reliable mutation semantics
- fully curated serving contracts

In those cases, native tables or Iceberg-based publish patterns are often stronger.

### 4. What is the difference between an external table and a native Snowflake table?

Strong short answer:

- external table reads external files in place
- native table stores data inside Snowflake-managed storage

Native tables are usually stronger for repeated transformations and serving workloads.

### 5. What are the main building blocks for an external table setup?

Usually:

- storage integration
- stage
- file format
- external table definition

### 6. Why use a storage integration?

A storage integration is safer than embedding cloud credentials directly in SQL.

It centralizes the access boundary and is easier to govern.

### 7. What are common limitations of external tables?

Common limitations include:

- less control than native tables
- performance dependence on file layout
- weaker support for mutation-heavy workflows
- need to manage refresh and metadata discovery carefully

### 8. What is `AUTO_REFRESH` or metadata refresh about?

Snowflake needs awareness of new or changed files.

Depending on cloud setup, this can happen through refresh mechanisms so the external table metadata stays aligned to the files.

### 9. How would you explain external tables versus Snowflake-managed Iceberg tables?

Good answer:

- external tables expose files directly for query access
- Snowflake-managed Iceberg tables provide a stronger table contract with Iceberg metadata and open-table semantics

External tables are more about external file exposure.

Iceberg tables are more about governed table state.

### 10. Where do external tables fit in architecture?

They often fit best in:

- exploration layers
- raw exposure layers
- ingestion boundaries before native curation

They are usually not the best final serving contract for business consumers.

## Practical SQL Example

### Storage integration

```sql
CREATE OR REPLACE STORAGE INTEGRATION raw_orders_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('s3://company-raw/orders/');
```

### Stage

```sql
CREATE OR REPLACE STAGE raw_orders_stage
  URL = 's3://company-raw/orders/'
  STORAGE_INTEGRATION = raw_orders_int;
```

### File format

```sql
CREATE OR REPLACE FILE FORMAT ff_orders_json
  TYPE = JSON;
```

### External table

```sql
CREATE OR REPLACE EXTERNAL TABLE ext_raw.orders_json (
  order_date DATE AS TO_DATE(VALUE:order_date::STRING),
  order_id STRING AS (VALUE:order_id::STRING),
  customer_id STRING AS (VALUE:customer_id::STRING),
  amount NUMBER(18,2) AS (VALUE:amount::NUMBER(18,2)),
  status STRING AS (VALUE:status::STRING)
)
WITH LOCATION = @raw_orders_stage
FILE_FORMAT = (FORMAT_NAME = ff_orders_json)
PATTERN = '.*[.]json';
```

### Profiling query

```sql
SELECT
  order_date,
  COUNT(*) AS rows_cnt,
  COUNT_IF(order_id IS NULL) AS null_order_id_cnt,
  SUM(amount) AS gross_amount
FROM ext_raw.orders_json
GROUP BY order_date
ORDER BY order_date;
```

## Good Interview Phrases

- "I use external tables as an external file exposure layer, not automatically as the final analytics contract."
- "A storage integration is better than embedding raw credentials into stage definitions."
- "If repeated analytics and governed serving matter, I usually move from external exposure to native curated tables or an open-table publish pattern."

## Common Mistakes To Avoid In Answers

- saying external tables are the same as native tables
- ignoring storage integration and security model
- treating external tables as the best answer for every analytics workload
- forgetting that file layout quality strongly affects the experience

## Quick Summary

Snowflake external tables are best understood as a governed SQL interface over files in external object storage. They are strong for raw data exposure, lightweight profiling, and ingestion boundaries. They are weaker than native tables or governed Iceberg publish contracts for repeated heavy transformations and stable business-serving layers.