# Snowflake-managed Iceberg

## 1. Why This Topic Matters

Many teams want two things at the same time:

- warehouse-grade governance and SQL ergonomics
- open-table storage that can also be used outside the warehouse

That is the architectural space where Snowflake-managed Iceberg matters.

If you only know classic warehouse tables, you may assume the decision is simply:

- use native Snowflake tables inside Snowflake
- use Parquet files outside Snowflake

In real platforms, that is too shallow.

The real design question is often:

- should this dataset be warehouse-private?
- should it be open and multi-engine?
- who owns metadata evolution?
- who owns storage layout and lifecycle?

Snowflake-managed Iceberg is one answer to that problem.

---

## 2. What Iceberg Is

Apache Iceberg is an open table format.

Its job is to turn a group of files in object storage into a table with:

- snapshots
- schema evolution
- partition evolution
- table metadata
- transactional table semantics

Mental model:

- plain Parquet gives you files
- Iceberg gives you a table abstraction above files

That means an engine does not have to guess table state by scanning folders.

Instead, it can read metadata that describes:

- current snapshot
- manifest files
- data files
- schema and partition spec

---

## 3. What Snowflake-managed Iceberg Means

- table format is Apache Iceberg
- Snowflake owns the Iceberg catalog state and table lifecycle operations
- table files can use Snowflake-managed storage or customer-managed cloud storage through an external volume
- Snowflake queries the table as a first-class table object

Keep catalog ownership and storage ownership separate in your design. With Snowflake-managed storage, Snowflake stores and manages the files and bills for storage; permanent tables receive the documented Snowflake Fail-safe protection. With a customer-managed external volume, the customer owns cloud storage and its recovery; Snowflake does not provide Fail-safe for that storage option.

This is different from:

- native Snowflake tables, where Snowflake fully owns storage internals
- externally managed Iceberg, where another engine or catalog owns the Iceberg metadata

Short version:

- native table = Snowflake-native storage semantics
- Snowflake-managed Iceberg = open format, Snowflake-governed table state
- externally managed Iceberg = open format, externally governed table state

---

## 4. What It Is Not

Snowflake-managed Iceberg is not:

- a magical replacement for all native Snowflake tables
- a free interoperability win for every dataset
- a good default for temporary scratch models
- a substitute for clear ownership and data contracts

If the data is only used in Snowflake and does not need open-table interoperability, native tables are usually simpler.

---

## 5. Core Objects In The Design

The design involves:

- either Snowflake-managed storage or an object storage bucket/container plus external volume
- Iceberg table definition
- Snowflake warehouse for reads and writes
- governance model for who can create, evolve, and publish tables

### 5.1 External volume

An external volume connects Snowflake to customer-managed cloud storage for Iceberg table data and metadata. It is not required when you select Snowflake-managed storage.

Representative example:

```sql
CREATE OR REPLACE EXTERNAL VOLUME lakehouse_ext_vol
  STORAGE_LOCATIONS = (
    (
      NAME = 'main'
      STORAGE_PROVIDER = 'S3'
      STORAGE_BASE_URL = 's3://company-lakehouse/'
      STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::123456789012:role/snowflake-iceberg-role'
      STORAGE_AWS_EXTERNAL_ID = 'company-snowflake-prod'
    )
  );
```

Architecture meaning:

- Snowflake does not hide the storage boundary
- your platform team still owns the cloud storage account and access model
- the table becomes open-format, not warehouse-private

### 5.2 Create a Snowflake-managed Iceberg table

Representative example:

```sql
CREATE OR REPLACE ICEBERG TABLE curated.orders_iceberg (
    order_id NUMBER,
    customer_id NUMBER,
    order_ts TIMESTAMP_NTZ,
    order_date DATE,
    order_status STRING,
    amount NUMBER(18,2)
)
  EXTERNAL_VOLUME = 'lakehouse_ext_vol'
  CATALOG = 'SNOWFLAKE'
  BASE_LOCATION = 'curated/orders_iceberg';
```

Key idea:

- storage path is explicit
- catalog responsibility stays with Snowflake
- the table is open-format, but Snowflake remains the operating control plane

This example uses customer-managed storage through an external volume. Snowflake-managed storage is a separate supported storage option; compare storage ownership, recovery, external-engine access, and billing requirements before selecting either.

---

## 6. Why Teams Choose It

### 1. Multi-engine access

You may want Snowflake, Spark, Trino, or another engine to read the same table format.

### 2. Better platform portability

The dataset does not become fully locked into one warehouse storage format.

### 3. Cleaner lakehouse publishing pattern

You can publish curated data in a table format that has stronger semantics than loose files.

### 4. Governance with interoperability

Teams want Snowflake governance and developer experience without losing open-format table semantics.

---

## 7. When Native Snowflake Tables Are Still Better

Native Snowflake tables are usually better when:

- the dataset is Snowflake-only
- top priority is simplest operations inside Snowflake
- you do not need open-format interoperability
- the table is highly warehouse-internal and short-lived
- you want to minimize platform moving parts

Architectural rule:

- do not add Iceberg because it sounds modern
- add Iceberg because a real boundary requires open-table behavior

---

## 8. Snowflake-managed Iceberg vs External Tables

These are often confused.

### Snowflake-managed Iceberg

- table abstraction above files
- snapshot-based table semantics
- schema and partition evolution model
- better fit for curated shared datasets

### External tables

- query files in place
- lighter metadata model
- good for discovery, raw access, or low-governance exposure
- weaker table-management semantics

Short rule:

- external table = file-query access layer
- managed Iceberg = open-format managed table layer

---

## 9. Snowflake-managed Iceberg vs Externally Managed Iceberg

### Snowflake-managed Iceberg

Use when:

- Snowflake is your main control plane
- you want Snowflake to manage table state
- you want interoperability without giving up Snowflake ownership

### Externally managed Iceberg

Use when:

- another platform already owns the Iceberg catalog
- Spark or a lakehouse metadata layer is the primary source of truth
- Snowflake is one consumer among multiple compute engines

Key architecture question:

- who is the system of record for table metadata?

If you cannot answer that clearly, your design is not ready.

---

## 10. Practical Write Pattern

Representative insert pattern:

```sql
INSERT INTO curated.orders_iceberg
SELECT
    order_id,
    customer_id,
    order_ts,
    CAST(order_ts AS DATE) AS order_date,
    order_status,
    amount
FROM mart.orders_ready_for_publish
WHERE order_date >= CURRENT_DATE - 7;
```

This is conceptually simple, but architecturally important.

You are not just writing rows.

You are publishing a table that may be read beyond Snowflake.

That means you should think about:

- schema stability
- partition strategy
- snapshot churn
- downstream compatibility

---

## 11. Partition Strategy

Weak strategy:

- partition by too many columns
- partition by high-cardinality keys
- mimic OLTP indexing habits

Better strategy:

- partition by stable, common filter dimensions such as date or coarse business domain
- keep partition strategy understandable to non-Snowflake engines too
- optimize for long-term interoperability, not only one query today

Representative design:

```sql
CREATE OR REPLACE ICEBERG TABLE curated.events_iceberg (
    event_id STRING,
    event_type STRING,
    event_ts TIMESTAMP_NTZ,
    event_date DATE,
    payload VARIANT
)
  EXTERNAL_VOLUME = 'lakehouse_ext_vol'
  CATALOG = 'SNOWFLAKE'
  BASE_LOCATION = 'curated/events_iceberg';
```

Then shape writes so `event_date` becomes the natural partitioning boundary in the open table design.

---

## 12. Good Architecture Pattern

Pattern:

- raw events land in object storage
- Snowflake ingests raw operational tables for transformation work
- curated interoperable datasets are published as Snowflake-managed Iceberg tables
- downstream Spark or Trino reads the curated Iceberg data without rebuilding the dataset elsewhere

Why this is strong:

- raw zone stays replayable
- transformation logic can stay in Snowflake
- published datasets remain open-format
- consumer boundary becomes explicit

---

## 13. Bad Architecture Pattern

Pattern:

- every table becomes Iceberg by default
- temporary models and internal marts are published as open tables
- no clear distinction between internal transformation tables and shared contract tables

Why this is bad:

- more storage and lifecycle complexity
- weaker clarity about what is actually a contract
- unnecessary operational surface area
- harder governance discussions

Iceberg should usually be a deliberate publish boundary, not your universal default.

---

## 14. Cookbook: Publish A Shared Curated Table

Scenario:

- finance wants daily order facts in Snowflake
- a machine learning team wants the same curated table in Spark
- you do not want two different pipelines producing two different truths

Recipe:

1. Build and validate the dataset in native Snowflake staging or mart tables.
2. Publish the stable contract as a Snowflake-managed Iceberg table.
3. Keep contract columns explicit and versioned.
4. Partition coarsely by business-friendly time boundaries.
5. Treat schema changes as consumer-impacting events.

Representative publish step:

```sql
CREATE OR REPLACE ICEBERG TABLE publish.finance_orders (
    order_id NUMBER,
    customer_id NUMBER,
    order_date DATE,
    net_amount NUMBER(18,2),
    gross_amount NUMBER(18,2),
    currency STRING,
    load_ts TIMESTAMP_NTZ
)
  EXTERNAL_VOLUME = 'lakehouse_ext_vol'
  CATALOG = 'SNOWFLAKE'
  BASE_LOCATION = 'publish/finance_orders';

INSERT OVERWRITE INTO publish.finance_orders
SELECT
    order_id,
    customer_id,
    order_date,
    net_amount,
    gross_amount,
    currency,
    CURRENT_TIMESTAMP()
FROM mart.finance_orders_daily;
```

Why this recipe works:

- the contract is explicit
- the publish layer is separated from raw and staging layers
- external consumers read the same governed table, not a copy

---

## 15. Common Failure Modes

### 1. Interoperability theater

Team says they need Iceberg, but no second engine actually uses the data.

Result:

- complexity without return

### 2. No ownership of metadata evolution

Nobody owns schema and snapshot discipline.

Result:

- unstable downstream consumption

### 3. Publishing unstable internal models

Analyst-facing or intermediate tables are exposed as open-table contracts.

Result:

- constant breaking changes

### 4. Over-partitioning

Too many partitions or unstable partition logic.

Result:

- poor cross-engine performance and hard operations

---

## 16. Decision Heuristics

Choose native Snowflake tables when:

- Snowflake is the only engine
- the table is internal
- the fastest path to reliable warehouse analytics matters most

Choose Snowflake-managed Iceberg when:

- the table is a shared curated contract
- open-table interoperability is real
- Snowflake should remain the metadata control plane

Choose externally managed Iceberg when:

- another platform owns the catalog
- Snowflake is not the primary metadata authority

---

## 17. What Happens Under The Hood

This is the layer most teams skip.

If you stop at:

- `CREATE ICEBERG TABLE`
- `INSERT INTO`

you understand the interface, but not the operating model.

### 17.1 The real physical layout

For a Snowflake-managed Iceberg table, object storage contains at least two logical areas:

- `data/` for Parquet data files
- `metadata/` for Iceberg metadata files

Mental model:

- Parquet files hold row data
- manifest files list groups of data files
- manifest lists group manifests for a snapshot
- metadata files describe table state, schema, partition spec, and current snapshot lineage

Architecturally important point:

- the table is not discovered by folder scanning
- the table is discovered by following metadata references

That means a query engine does not ask:

- what files happen to exist under this prefix?

It asks:

- what is the current metadata pointer?
- which snapshot does it reference?
- which manifests and data files belong to that snapshot?

### 17.2 What the catalog actually owns

The Iceberg catalog is not just a registry of names.

Its critical job is to maintain the current metadata pointer for a table and update it atomically.

That is the heart of table state.

For Snowflake-managed Iceberg:

- Snowflake is the catalog
- Snowflake writes metadata files to your external volume
- Snowflake performs atomic updates to table state

This is the core difference from plain files in a lake.

Plain files give you storage.

Iceberg gives you controlled table state.

### 17.3 What a write really does

When you run a write like `INSERT`, `MERGE`, `UPDATE`, or `DELETE`, do not think only in terms of rows.

Think in terms of snapshot evolution.

At a high level, Snowflake does work like this:

1. Produce new Parquet data files or row-level delete artifacts, depending on the operation and table capabilities.
2. Build or update manifest information.
3. Generate new Iceberg metadata representing the new table snapshot.
4. Atomically move the table to the new snapshot.

Representative write flow:

```sql
MERGE INTO curated.orders_iceberg AS tgt
USING mart.orders_publish_delta AS src
ON tgt.order_id = src.order_id
WHEN MATCHED AND src.is_deleted = TRUE THEN DELETE
WHEN MATCHED THEN UPDATE SET
  customer_id = src.customer_id,
  order_ts = src.order_ts,
  order_date = CAST(src.order_ts AS DATE),
  order_status = src.order_status,
  amount = src.amount
WHEN NOT MATCHED THEN INSERT (
  order_id,
  customer_id,
  order_ts,
  order_date,
  order_status,
  amount
) VALUES (
  src.order_id,
  src.customer_id,
  src.order_ts,
  CAST(src.order_ts AS DATE),
  src.order_status,
  src.amount
);
```

Architectural takeaway:

- a write is a table-state publication event
- each successful commit creates a new table snapshot
- consumers read a coherent snapshot, not a half-written folder

### 17.4 Metadata generation is observable

Snowflake documents that it automatically generates Iceberg metadata and writes it to the `metadata` directory on the external volume.

You can also force or inspect metadata generation explicitly.

Representative inspection:

```sql
SELECT SYSTEM$GET_ICEBERG_TABLE_INFORMATION('CURATED.ORDERS_ICEBERG');
```

Representative output shape contains a metadata location such as:

- `s3://my-bucket/.../metadata/v1.metadata.json`

This matters because it lets you reason about the table as a real Iceberg object, not a Snowflake-only abstraction.

### 17.5 Why DDL can look surprising in metadata history

Snowflake documents an important nuance for Snowflake-managed Iceberg:

- Snowflake processes DDL as individual transactions
- Iceberg metadata does not always show a new schema version for each individual DDL
- close DDL and DML changes can appear grouped or slightly out of intuitive order in Iceberg metadata

This matters if your team assumes:

- one SQL DDL statement always equals one neat visible Iceberg schema-version step

That assumption is too simplistic.

Architectural rule:

- treat Snowflake as the operational authority for the table state
- do not build brittle governance logic that assumes a one-statement-to-one-version narrative in metadata history

---

## 18. Storage Layout, Optimization, And Maintenance

Snowflake-managed Iceberg is not self-maintaining by magic.

Snowflake does perform a lot of lifecycle management, but you still need to understand what is automatic, what is tunable, and what can bite you.

### 18.1 Data compaction

Snowflake supports data compaction for Snowflake-managed Iceberg tables.

Why it exists:

- many small files hurt read efficiency
- too much file fragmentation increases metadata overhead and query cost

Representative configuration:

```sql
CREATE OR REPLACE ICEBERG TABLE curated.orders_iceberg (
    order_id NUMBER,
    customer_id NUMBER,
    order_ts TIMESTAMP_NTZ,
    order_date DATE,
    order_status STRING,
    amount NUMBER(18,2)
)
  EXTERNAL_VOLUME = 'lakehouse_ext_vol'
  CATALOG = 'SNOWFLAKE'
  BASE_LOCATION = 'curated/orders_iceberg'
  ENABLE_DATA_COMPACTION = TRUE;
```

And you can change it later:

```sql
ALTER ICEBERG TABLE curated.orders_iceberg
  SET ENABLE_DATA_COMPACTION = FALSE;
```

Architectural meaning:

- if a table is rarely queried, you might reduce maintenance cost by disabling data compaction
- if the table is a shared contract queried often, compaction usually helps more than it hurts

### 18.2 Manifest compaction and snapshot expiry

Snowflake-managed Iceberg also has maintenance that is automatic:

- manifest compaction
- snapshot expiry

Snowflake docs explicitly say these are enabled automatically and cannot be disabled.

What that means in practice:

- metadata overhead is continuously managed
- old table history is not kept forever
- the table stays queryable through the current valid snapshot chain

### 18.3 Target file size is an explicit architectural control

Snowflake lets you influence Parquet file size.

Representative example:

```sql
ALTER ICEBERG TABLE curated.orders_iceberg
  SET TARGET_FILE_SIZE = '128MB';
```

This is not cosmetic.

It changes the shape of future writes and affects how maintenance rewrites older files over time.

Use this when:

- small files are hurting read efficiency
- you need more predictable cross-engine file sizing
- you want to tune for bigger analytical reads instead of tiny write batches

### 18.4 Automatic clustering is not the same thing as partitioning

Snowflake supports Automatic Clustering for Snowflake-managed Iceberg tables.

That gives you another physical-optimization lever.

Representative example:

```sql
CREATE OR REPLACE ICEBERG TABLE curated.orders_iceberg (
    order_id NUMBER,
    customer_id NUMBER,
    order_ts TIMESTAMP_NTZ,
    order_date DATE,
    order_status STRING,
    amount NUMBER(18,2)
)
  EXTERNAL_VOLUME = 'lakehouse_ext_vol'
  CATALOG = 'SNOWFLAKE'
  BASE_LOCATION = 'curated/orders_iceberg'
  CLUSTER BY (order_date, order_status);
```

Important distinction:

- partitioning is Iceberg table layout semantics
- clustering is Snowflake physical optimization behavior

Do not conflate them.

### 18.5 Storage protection is your responsibility

Snowflake docs are very explicit here:

- Iceberg data is in your external cloud storage
- Snowflake does not provide Fail-safe for that storage

Architectural consequence:

- cloud-side retention, recovery, and backup posture are your problem
- if the storage account is misconfigured, Snowflake does not save you

This is one of the biggest differences from native Snowflake tables.

---

## 19. Row-Level Changes Across Iceberg Versions And Interop Consequences

If you are going from engineer to architect level, this part matters a lot.

Important clarification:

- Apache Iceberg historically starts with format versions `v1` and `v2`
- `v2` is the widely adopted baseline for modern row-level change semantics
- Snowflake also documents preview support for `v3` features

So this section is not claiming Iceberg only has `v2` and `v3`.

It is focusing on the part that matters for row-level behavior in Snowflake today:

- `v1` is the older baseline
- `v2` introduces the modern row-level delete model used in most current Iceberg discussions
- `v3` adds newer capabilities such as deletion vectors, default values, and row lineage

### 19.1 Copy-on-write versus merge-on-read

For row-level changes, Iceberg can behave in two broad ways:

- copy-on-write
- merge-on-read

Conceptually:

- copy-on-write rewrites affected data files
- merge-on-read keeps extra delete information and merges it during reads

Architectural trade-off:

- copy-on-write favors read simplicity
- merge-on-read favors write speed but can make reads and maintenance more complex

### 19.2 What Snowflake supports

Snowflake docs say:

- for Iceberg v2, Snowflake supports position deletes only for externally managed Iceberg tables
- for Iceberg v3, Snowflake supports deletion vectors for both Snowflake-managed and externally managed Iceberg tables

The parameter that matters operationally is:

- `ENABLE_ICEBERG_MERGE_ON_READ`

Representative example:

```sql
ALTER ICEBERG TABLE curated.orders_iceberg
  SET ENABLE_ICEBERG_MERGE_ON_READ = FALSE;
```

Use this kind of choice deliberately.

If downstream engines do not support the row-level delete behavior you are relying on, your beautiful open-table design becomes only theoretically interoperable.

### 19.3 V3 brings useful schema-evolution capabilities

Snowflake-managed Iceberg also supports Iceberg v3 capabilities in preview, including default values and row lineage.

Representative example with a default value:

```sql
CREATE OR REPLACE ICEBERG TABLE curated.user_events (
    event_id NUMBER,
    user_id NUMBER,
    event_type STRING,
    event_ts TIMESTAMP_NTZ,
    event_version NUMBER DEFAULT 1
)
  EXTERNAL_VOLUME = 'lakehouse_ext_vol'
  CATALOG = 'SNOWFLAKE'
  BASE_LOCATION = 'curated/user_events'
  ICEBERG_VERSION = 3;
```

Representative evolution:

```sql
ALTER ICEBERG TABLE curated.user_events
  ADD COLUMN event_source STRING DEFAULT 'app';
```

Why this matters architecturally:

- you can evolve schemas while presenting values for historical rows
- contract evolution can become safer
- but you must still validate whether every consuming engine supports the same v3 features you intend to use

### 19.4 Row lineage changes the CDC conversation

Snowflake documents support for row lineage in Iceberg v3 with generated fields such as:

- `_row_id`
- `_last_updated_sequence_number`

That is important if you care about:

- matching rows across snapshots
- identifying row-level changes more reliably
- building CDC-like consumers on open-table history

But again, architect-level answer is not “great, turn it on everywhere.”

The real question is:

- which consumers actually understand and preserve those semantics?

---

## 20. Failure Modes Under The Hood

### 20.1 Orphan files after failed writes

Snowflake docs explicitly call out that if a DML operation fails and rolls back, some Parquet files may already have been written to storage but not referenced by Iceberg metadata.

These are orphan files.

That means:

- storage cost can drift away from logical table usage
- object storage listing may show files the table no longer references
- operational cleanup is not the same as normal table maintenance

Important official limitation:

- Snowflake does not support orphan file deletion for Snowflake-managed Iceberg tables

If usage looks wrong, Snowflake recommends checking metrics and contacting support.

Representative storage inspection:

```sql
SELECT metrics.*, tables.table_name
FROM snowflake.account_usage.table_storage_metrics AS metrics
JOIN snowflake.account_usage.tables AS tables
  ON metrics.id = tables.table_id
 AND metrics.table_schema_id = tables.table_schema_id
 AND metrics.table_catalog_id = tables.table_catalog_id
WHERE tables.is_iceberg = 'YES'
  AND tables.table_name = 'ORDERS_ICEBERG';
```

### 20.2 Cross-region and cross-cloud surprise costs

Snowflake supports cross-region and cross-cloud external volumes.

That does not mean it is free.

If compute and storage are separated badly, you can pay for:

- storage-provider egress
- Snowflake cross-region transfer charges

This is one of the classic architecture mistakes:

- table format decision made by platform team
- region-placement cost discovered later by finance

### 20.3 Partition evolution assumptions

Iceberg as a format supports partition evolution.

But Snowflake docs also note important limitations for Snowflake-managed tables.

In practice, do not assume you can casually mutate partition strategy on a long-lived contract table without consequences.

The safe architect habit is:

- choose a coarse stable partition design at contract creation
- treat partition redesign as a migration, not a casual ALTER habit

---

## 21. Operational Cookbook: How To Inspect A Real Table

### 21.1 See table definition and properties

```sql
SHOW ICEBERG TABLES LIKE 'ORDERS_ICEBERG' IN SCHEMA curated;
```

```sql
DESC ICEBERG TABLE curated.orders_iceberg;
```

### 21.2 Inspect current metadata location

```sql
SELECT SYSTEM$GET_ICEBERG_TABLE_INFORMATION('CURATED.ORDERS_ICEBERG');
```

Use this to answer:

- where is the current metadata file?
- did metadata generation succeed?
- is Snowflake publishing snapshot metadata correctly?

### 21.3 Check optimization posture

```sql
SHOW PARAMETERS LIKE 'target_file_size' FOR TABLE curated.orders_iceberg;
```

```sql
SHOW PARAMETERS LIKE 'enable_data_compaction' FOR TABLE curated.orders_iceberg;
```

### 21.4 Check storage optimization history

```sql
SELECT *
FROM snowflake.account_usage.iceberg_storage_optimization_history
WHERE table_name = 'ORDERS_ICEBERG'
ORDER BY start_time DESC;
```

Use this to inspect:

- compaction activity
- maintenance timing
- billed credits for compaction work

### 21.5 Practical debug checklist

If a Snowflake-managed Iceberg table feels wrong, ask in this order:

1. Is this really a contract table, or should it have stayed native?
2. Is Snowflake the correct metadata control plane for this dataset?
3. Is the external volume in the right region and storage account?
4. Is file-size behavior healthy, or are we drowning in small files?
5. Is table maintenance helping, or are we paying cost for a table nobody queries?
6. Do all consuming engines support the Iceberg features we are actually using?
7. Is storage usage drifting because of orphan files?

---

## 22. Interview-Ready Summary

Strong short answer:

> I use Snowflake-managed Iceberg when I need a curated open-format table that stays governed from Snowflake but should not be trapped inside Snowflake-native storage semantics. I would not use it for every table. I would reserve it for datasets that cross an engine boundary or represent a durable publish contract.

Architect takeaway:

- native tables optimize simplicity inside Snowflake
- Snowflake-managed Iceberg optimizes governed interoperability
- externally managed Iceberg optimizes external control-plane ownership

The right answer depends less on syntax and more on who owns the table contract.