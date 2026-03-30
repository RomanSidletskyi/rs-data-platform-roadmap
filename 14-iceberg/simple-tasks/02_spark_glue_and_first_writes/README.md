# 02 Spark Glue And First Writes

## Overview

These tasks focus on the first practical operating boundary for Iceberg on AWS:

- Spark as compute engine
- Glue as catalog
- S3 as data and metadata storage

The main goal is not only to write `CREATE TABLE USING iceberg`.

The main goal is to understand who owns:

- execution
- metadata registration
- object-store layout

---

## Task 1 - Configure Spark For Glue Catalog

### Goal

Write the minimal Spark configuration for a Glue-backed Iceberg catalog.

### Input

Requirements:

- catalog name `glue_prod`
- warehouse `s3://company-lakehouse/warehouse`
- Iceberg Spark SQL extensions enabled

### Requirements

- write the main Spark configs
- include the catalog implementation class
- include the Glue catalog type
- include the S3 file IO implementation

### Expected Output

- one SparkSession config block or `spark-submit` config set

### Extra Challenge

Explain in one sentence what object actually stores the table entry after `CREATE TABLE` runs.

---

## Task 2 - Create A First Iceberg Table Through Glue

### Goal

Write a credible first table definition.

### Input

Table:

- `glue_prod.analytics.orders`

Columns:

- `order_id`
- `customer_id`
- `order_ts`
- `amount`

### Requirements

- create namespace if needed
- write a `CREATE TABLE ... USING iceberg` statement
- partition by `days(order_ts)`
- set `format-version = 2`

### Expected Output

- one namespace statement
- one table statement

### Extra Challenge

Explain why this statement means Spark is creating the table through Glue catalog rather than bypassing it.

---

## Task 3 - Choose Append Versus Overwrite Partitions

### Goal

Pick the safe write pattern.

### Input

Scenario A:

- new daily file batch for a brand-new day

Scenario B:

- corrected re-computation for one already loaded day

### Requirements

- choose append or partition-scoped overwrite for each scenario
- explain why broad overwrite is dangerous

### Expected Output

- two write decisions
- one warning paragraph

### Extra Challenge

Explain why “just truncate and reload the whole table” is often a weak operating model.

---

## Task 4 - Write A Batch Append Job

### Goal

Write a simple Spark append pattern.

### Input

Source:

- `s3://raw-company/orders/dt=2026-03-27/`

Target:

- `glue_prod.analytics.orders`

### Requirements

- read parquet source
- select only business columns needed
- filter null `order_id`
- append into the Iceberg table

### Expected Output

- one short PySpark write snippet

### Extra Challenge

Explain which extra ingestion column you would add first if replay diagnostics become necessary.

---

## Task 5 - Read A Table By Snapshot

### Goal

Write a time-travel read.

### Input

Snapshot id:

- `918273645546372819`

### Requirements

- read the table by `snapshot-id`
- explain one reason to do this outside of disaster recovery

### Expected Output

- one Spark read snippet
- one short use-case explanation

### Extra Challenge

Explain the difference between business-time history and technical snapshot history.

---

## Task 6 - Run A Small-File Maintenance Action

### Goal

Write a first compaction call.

### Input

Table:

- `analytics.orders`

### Requirements

- call `rewrite_data_files`
- explain why this is an operational task rather than a business transformation

### Expected Output

- one SQL procedure call
- one short explanation

### Extra Challenge

Explain why compaction should usually be scheduled and governed rather than triggered randomly by analysts.