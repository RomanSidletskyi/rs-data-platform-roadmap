# Snowflake Externally Managed Iceberg Cookbook

## 1. How To Use This File

This file is the practical companion to `Snowflake_externally_managed_Iceberg.md`.

The theory file explains ownership, control-plane boundaries, and trade-offs.

This file explains:

- what you create first
- what you create next
- what healthy operating flow looks like
- how to debug the main failure modes

The goal is not just to memorize syntax.

The goal is to make the platform workflow concrete.

---

## 2. Scenario Map

This cookbook covers four practical situations:

1. Read an existing externally managed Iceberg table from a standard Snowflake database.
2. Turn on refresh and monitor sync health.
3. Use a catalog-linked database as the scalable platform pattern.
4. Write back to an externally managed table in a supported REST-catalog flow.

Before you touch SQL, decide which side owns the table lifecycle:

- remote engine owns lifecycle and Snowflake only participates
- Snowflake participates in creation through a catalog-linked database

If you do not know the answer, stop there.

---

## 3. Scenario 1: Register An Existing Remote Table In A Standard Database

Use this when:

- the table already exists in the remote catalog
- Snowflake should query it from a normal database
- you are not using a catalog-linked database for broad namespace sync

### 3.1 Create the catalog integration

Representative REST catalog example:

```sql
CREATE OR REPLACE CATALOG INTEGRATION rest_catalog_int
  CATALOG_SOURCE = ICEBERG_REST
  TABLE_FORMAT = ICEBERG
  CATALOG_URI = 'https://catalog.company.io/iceberg'
  ENABLED = TRUE
  REFRESH_INTERVAL_SECONDS = 60;
```

Why it exists:

- defines how Snowflake reaches the remote metadata authority
- controls sync polling interval at integration level

### 3.2 Create the external volume if credentials are not vended by catalog

```sql
CREATE OR REPLACE EXTERNAL VOLUME lakehouse_ext_vol
  STORAGE_LOCATIONS = (
    (
      NAME = 'main'
      STORAGE_PROVIDER = 'S3'
      STORAGE_BASE_URL = 's3://company-lakehouse/'
      STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::123456789012:role/snowflake-iceberg-access'
      STORAGE_AWS_EXTERNAL_ID = 'snowflake-prod-iceberg'
    )
  );
```

### 3.3 Register the remote Iceberg table in Snowflake

```sql
CREATE OR REPLACE ICEBERG TABLE curated.orders_remote
  EXTERNAL_VOLUME = 'LAKEHOUSE_EXT_VOL'
  CATALOG = 'REST_CATALOG_INT'
  CATALOG_TABLE_NAME = 'orders';
```

### 3.4 Validate that the table is usable

```sql
SELECT *
FROM curated.orders_remote
LIMIT 20;
```

```sql
SELECT
    order_date,
    COUNT(*) AS orders_cnt,
    SUM(net_amount) AS total_net_amount
FROM curated.orders_remote
GROUP BY order_date
ORDER BY order_date;
```

Architect note:

- the SQL looks simple
- the hard part is that table state is still owned outside Snowflake

---

## 4. Scenario 2: Refresh And Sync Health

Use this when:

- another engine changes the table
- Snowflake must see the latest snapshot
- you need to debug staleness

### 4.1 Manual refresh

```sql
ALTER ICEBERG TABLE curated.orders_remote REFRESH;
```

Use manual refresh when:

- a producer has just committed changes
- automated refresh is disabled
- you suspect Snowflake is behind remote reality

### 4.2 Turn on automated refresh

```sql
ALTER ICEBERG TABLE curated.orders_remote
  SET AUTO_REFRESH = TRUE;
```

Important rule:

- automated refresh reduces manual work
- it does not remove the need to observe sync health

### 4.3 Check refresh status

```sql
SELECT SYSTEM$AUTO_REFRESH_STATUS('CURATED.ORDERS_REMOTE');
```

Interpret this like an operator, not like a student:

- `RUNNING` means the refresh service is active
- `STALLED` means progress is blocked or behind
- `STOPPED` means the service is not advancing the table state

### 4.4 Read snapshot refresh history

```sql
SELECT *
FROM TABLE(
  INFORMATION_SCHEMA.ICEBERG_TABLE_SNAPSHOT_REFRESH_HISTORY(
    TABLE_NAME => 'ORDERS_REMOTE'
  )
)
ORDER BY REFRESHED_AT DESC;
```

Use it to answer:

- when was the last successful refresh?
- did refresh fail repeatedly?
- is the gap operational or only perceived?

### 4.5 Incident sequence for a stopped table

If refresh is stopped:

1. Disable auto refresh.
2. Force a manual refresh.
3. Re-enable auto refresh.
4. Re-check status and refresh history.

Representative commands:

```sql
ALTER ICEBERG TABLE curated.orders_remote SET AUTO_REFRESH = FALSE;
```

```sql
ALTER ICEBERG TABLE curated.orders_remote REFRESH;
```

```sql
ALTER ICEBERG TABLE curated.orders_remote SET AUTO_REFRESH = TRUE;
```

If that does not recover the table, the next place to look is not random SQL.

The next place to look is:

- remote catalog health
- remote commit history
- external maintenance operations

---

## 5. Scenario 3: Catalog-Linked Database For Large-Scale Participation

Use this when:

- Snowflake should consume a whole remote Iceberg namespace
- the platform wants synchronized discovery of schemas and tables
- manual one-by-one registration is too fragile

### 5.1 Create the linked database

```sql
CREATE DATABASE lakehouse_linked_db
  LINKED_CATALOG = (
    CATALOG = 'REST_CATALOG_INT'
  );
```

### 5.2 Inspect sync status

```sql
SELECT SYSTEM$CATALOG_LINK_STATUS('LAKEHOUSE_LINKED_DB');
```

```sql
SELECT SYSTEM$GET_CATALOG_LINKED_DATABASE_CONFIG('LAKEHOUSE_LINKED_DB');
```

### 5.3 Query discovered objects

```sql
USE DATABASE lakehouse_linked_db;

SELECT *
FROM analytics.orders
LIMIT 20;
```

### 5.4 Operational rule for linked databases

Catalog-linked databases are strong when the platform accepts one truth:

- the remote catalog is authoritative for namespace and table discovery

That means naming policy and schema governance must be stable across engines.

If one side uses lowercase quoted names and the other side assumes classic Snowflake case folding, operations become brittle.

---

## 6. Scenario 4: Write Back In A Supported REST-Catalog Pattern

Use this when:

- Snowflake should contribute writes to an externally managed table
- the remote catalog supports the required Iceberg REST workflow
- the team explicitly accepts that commit success depends on remote-catalog health

### 6.1 Create the table in a catalog-linked database

```sql
USE DATABASE lakehouse_linked_db;
CREATE SCHEMA IF NOT EXISTS sales;
USE SCHEMA sales;

CREATE OR REPLACE ICEBERG TABLE orders_remote (
  order_id NUMBER,
  order_date DATE,
  customer_id STRING,
  net_amount NUMBER(18,2),
  load_ts TIMESTAMP_NTZ
)
PARTITION BY (order_date)
TARGET_FILE_SIZE = '64MB';
```

Why this pattern matters:

- Snowflake can participate in table creation through the linked catalog flow
- but the metadata authority is still external

### 6.2 Insert data

```sql
INSERT INTO orders_remote VALUES
  (1, '2026-03-01', 'c_101', 120.50, CURRENT_TIMESTAMP()),
  (2, '2026-03-01', 'c_102', 90.00, CURRENT_TIMESTAMP());
```

### 6.3 Merge corrections

```sql
MERGE INTO orders_remote AS tgt
USING (
  SELECT 2 AS order_id, '2026-03-01'::DATE AS order_date, 'c_102' AS customer_id, 92.00 AS net_amount, CURRENT_TIMESTAMP() AS load_ts
  UNION ALL
  SELECT 3, '2026-03-01'::DATE, 'c_103', 75.25, CURRENT_TIMESTAMP()
) AS src
ON tgt.order_id = src.order_id
WHEN MATCHED THEN UPDATE SET
  tgt.order_date = src.order_date,
  tgt.customer_id = src.customer_id,
  tgt.net_amount = src.net_amount,
  tgt.load_ts = src.load_ts
WHEN NOT MATCHED THEN INSERT (
  order_id,
  order_date,
  customer_id,
  net_amount,
  load_ts
) VALUES (
  src.order_id,
  src.order_date,
  src.customer_id,
  src.net_amount,
  src.load_ts
);
```

### 6.4 Important write constraints

Do not hide these constraints from yourself:

- externally managed write support is compatibility-bound, not universal
- autocommit is the supported operating model in documented externally managed write paths
- remote commit failures are part of the design, not an exception outside the design

If the platform requires large multi-step transactional behavior inside Snowflake control, native tables or Snowflake-managed Iceberg may be the better answer.

---

## 7. Scenario 5: Glue-Like Consumption Pattern

Use this when:

- AWS Glue or a Glue-like catalog owns the Iceberg metadata
- Spark or another engine writes and maintains the table
- Snowflake mainly consumes the published table

Reference pattern:

```sql
CREATE OR REPLACE ICEBERG TABLE curated.customer_360_remote
  EXTERNAL_VOLUME = 'LAKEHOUSE_EXT_VOL'
  CATALOG = 'GLUE_OR_REST_INT'
  CATALOG_TABLE_NAME = 'customer_360'
  AUTO_REFRESH = TRUE;
```

Recommended operating model:

- let Spark own compaction and snapshot expiry
- let Snowflake own query serving and freshness verification
- make refresh history part of BI incident debugging

This is strong when one platform clearly owns data maintenance and Snowflake clearly owns analytical consumption.

---

## 8. Scenario 6: Check Files And Diagnose Drift

When someone says, "Snowflake data does not match lakehouse data," check actual table files and refresh history before debating semantics.

Representative query:

```sql
SELECT *
FROM TABLE(
  INFORMATION_SCHEMA.ICEBERG_TABLE_FILES(
    TABLE_NAME => 'ORDERS_REMOTE'
  )
)
LIMIT 50;
```

Questions this helps answer:

- what files does Snowflake think belong to the current snapshot?
- did a refresh bring in the expected snapshot?
- is the mismatch due to stale registration or due to remote maintenance?

---

## 9. Practical Anti-Patterns

### Anti-pattern 1: Treating refresh as an implementation detail

Wrong mindset:

- "The table exists, so Snowflake always sees the latest state."

Correct mindset:

- refresh is part of data freshness architecture

### Anti-pattern 2: Using externally managed Iceberg when Snowflake is the real owner

Wrong mindset:

- "Open format sounds more advanced, so use it by default."

Correct mindset:

- if Snowflake is the real owner, use native tables or Snowflake-managed Iceberg unless there is a real interoperability requirement

### Anti-pattern 3: Ignoring external maintenance

Wrong mindset:

- "Snowflake can query it, so Snowflake will also keep it healthy."

Correct mindset:

- compaction, snapshot cleanup, and some delete-file complexity remain external responsibilities

---

## 10. Architecture Review Questions

Use these questions before approving the design:

1. Which system is the metadata authority?
2. Which team owns compaction, snapshot expiry, and schema evolution?
3. What freshness target is expected between remote commits and Snowflake visibility?
4. Is catalog-linked database sync required, or is one-table registration enough?
5. Does the platform really need Snowflake writes, or only Snowflake reads?
6. What is the recovery procedure when auto refresh stalls or remote commit status is ambiguous?

If these answers are weak, the design is weak.

---

## 11. Short Summary

This cookbook gives you the concrete operator view:

- register the table correctly
- refresh and monitor it explicitly
- use catalog-linked databases for scale
- treat writes as remote-catalog-integrated operations, not purely Snowflake-local actions
- keep maintenance ownership explicit

That is the practical difference between understanding the feature and actually being able to run it.