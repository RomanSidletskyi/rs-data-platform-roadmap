# 05 Snowflake Storage And Ingestion

## Overview

These tasks focus on the practical Snowflake boundary between object storage, stages, file formats, external tables, and native raw tables.

The main goal is not only to write valid SQL.

The main goal is to understand when data should:

- stay in files
- be exposed through an external table
- be loaded into a native Snowflake raw table

---

## Task 1 — Design A Safe External Stage

### Goal

Create a stage definition for raw order files stored in S3.

### Input

Storage path:

- `s3://company-raw/orders/`

Requirements:

- use a storage integration
- avoid embedding raw credentials in the stage

### Requirements

- write the `CREATE STORAGE INTEGRATION` statement
- write the `CREATE STAGE` statement
- explain why this is better than placing credentials directly in SQL

### Expected Output

- one storage integration definition
- one stage definition
- a short explanation of the security boundary

### Extra Challenge

Add one sentence explaining how you would scope allowed locations if only `orders/` should be visible to Snowflake.

---

## Task 2 — Create File Formats For JSON And Parquet

### Goal

Define file formats for two ingestion cases.

### Input

Case 1:

- event payloads in JSON

Case 2:

- curated order snapshots in Parquet

### Requirements

- write one `CREATE FILE FORMAT` for JSON
- write one `CREATE FILE FORMAT` for Parquet
- explain which one is better for schema drift and which one is better for efficient analytical scans

### Expected Output

- two file format statements
- a short comparison note

### Extra Challenge

Explain why CSV would usually be the riskiest of the three formats operationally.

---

## Task 3 — Load Raw Orders With Metadata Columns

### Goal

Write a `COPY INTO` pattern that preserves useful ingestion metadata.

### Input

Target table:

- `raw.orders_raw`

Columns:

- `order_id`
- `customer_id`
- `order_ts`
- `amount`
- `src_filename`
- `src_row_number`
- `src_last_modified`
- `load_ts`

### Requirements

- load from a JSON stage
- cast fields explicitly
- include at least three metadata columns
- explain why metadata retention matters operationally

### Expected Output

- one `COPY INTO ... FROM (SELECT ...)` statement
- a short explanation of debugging and lineage benefits

### Extra Challenge

Explain which column you would use first when investigating duplicate file delivery.

---

## Task 4 — Choose Between External Table And Native Raw Table

### Goal

Decide the right first step for a new partner feed.

### Input

Scenario:

- partner drops unstable JSON files once per day
- analysts want quick visibility
- engineering does not yet trust the schema

### Requirements

- choose either an external table first or native raw table first
- justify the choice in 4 to 6 bullet points
- describe what condition would make you switch to the other option later

### Expected Output

- one decision
- one justification
- one trigger for the next architecture step

### Extra Challenge

Explain why “load everything immediately because warehouse tables are always better” is not a strong answer here.

---

## Task 5 — Query A Raw External Table By File And Date

### Goal

Write a profiling query over an external table.

### Input

Table:

- `ext_raw.orders_json`

Available columns:

- `order_date`
- `order_id`
- `amount`
- `status`
- `METADATA$FILENAME`

### Requirements

- group by `order_date`
- count rows
- count distinct files
- sum `amount`
- return one filename-level diagnostic column in a second query

### Expected Output

- one daily profiling query
- one file-level diagnostic query

### Extra Challenge

Add logic to count rows where `order_id` is null.

---

## Task 6 — Design A Raw Ingestion Table Contract

### Goal

Propose the structure of a native raw table for order events.

### Input

Business fields:

- `order_id`
- `customer_id`
- `order_ts`
- `status`
- `amount`
- raw payload

### Requirements

- define a Snowflake table with both business columns and ingestion audit columns
- include one column for raw semi-structured payload retention
- explain why raw tables should usually avoid heavy business transformations

### Expected Output

- one `CREATE TABLE` statement
- a short architecture explanation

### Extra Challenge

Explain why “cleaning” status values aggressively inside the raw table can create replay problems later.