# Real Project Examples For Interview

## Purpose

This file is focused on concrete first-person answers.

The goal is to help you say:

- what the problem was
- what you actually implemented
- how the flow worked in practice
- why you chose that solution

---

## Example 1: dbt Incremental For 9 Brands With Shared Logic

### Scenario

We had 9 brands.

Each brand had:

- its own source tables
- its own detailed output tables
- its own aggregated output tables

But the transformation logic and validation rules were the same across all brands.

The main challenge was avoiding duplicated SQL and duplicated maintenance across 9 separate flows.

### What I Did In Practice

In practice, I did not build one huge shared model for all brands, and I also did not duplicate the full implementation 9 times.

What I did was:

- define separate sources for each brand
- keep separate final detail and aggregate models per brand
- move repeated SQL logic into reusable macros
- standardize the same validation rules across all 9 flows
- use incremental models for large detailed tables

So physically the outputs stayed separated by brand, but the implementation logic was centralized.

### Concrete Answer You Can Say

In that case, we had 9 brands, and each brand had its own raw source tables and its own final detail and aggregate tables. The business logic was the same, so I did not want to maintain 9 copies of the same dbt code. What I implemented was a pattern where the source and target definitions stayed brand-specific, but the transformation logic itself was moved into shared macros and reusable model patterns. I also kept the same validation logic across all brands. As a result, when we changed the business rule, I could update the shared logic once instead of manually changing 9 separate flows.

### More Practical Version

The main thing I implemented was the split between brand-specific objects and shared logic. Sources and final tables were separate because that was the business requirement, but the SQL transformations and tests were standardized. For large detailed tables, I also used incremental materialization so that we processed only new or changed data instead of rebuilding everything every time.

### If They Ask What Exactly Was Reused

What I reused was the transformation pattern itself: common filters, common column logic, common calculations, and common validation checks. I kept the models readable, but removed copy-paste logic from the flows.

### Short Version

I kept separate dbt flows per brand at the source and output level, but I centralized the transformation and validation logic so the implementation was maintainable and consistent.

---

## Example 2: Run dbt Only When Source Data Was Updated

### Scenario

dbt should not run only because of a fixed schedule.

It should run when the source was actually refreshed.

The source itself was loaded by jobs.

You wanted two patterns:

1. with Airflow
2. without Airflow

### Option A: With Airflow

### What I Did In Practice With Airflow

With Airflow, I made dbt depend on source readiness instead of a fixed time schedule.

The practical implementation was:

1. the upstream ingestion job loaded the source
2. Airflow checked a readiness condition, for example an audit table or status record
3. only if the source was marked as successfully loaded did Airflow start `dbt run`
4. after that, Airflow triggered `dbt test`

So dbt only ran when fresh source data was actually available.

### Concrete Answer You Can Say

With Airflow, I implemented source-driven dbt execution. Instead of running dbt on a blind schedule, I added an upstream readiness check in the DAG. The source-loading job finished first, then Airflow checked a status or audit signal, and only after successful readiness did it trigger dbt run and dbt test. That prevented unnecessary runs and made the flow more reliable.

### Short Version

I used Airflow to make dbt dependent on source completion, not on a fixed cron schedule.

---

### Option B: Without Airflow

### What I Did In Practice Without Airflow

Without Airflow, I would still not schedule dbt blindly.

The practical approach is:

1. the source-loading job writes a completion flag or updates a control table
2. a script or downstream job checks that flag
3. only then does it trigger dbt
4. after dbt finishes, the status can be updated again for the next cycle

So the trigger is still source-driven, just without a full orchestration layer.

### Concrete Answer You Can Say

Without Airflow, I would still make dbt conditional on source readiness. The way to do that in practice is to let the upstream loading job update a control table or success flag, and then trigger dbt only if that signal is present. So the logic stays the same: dbt runs only after a successful source refresh. The difference is that dependency handling and monitoring are simpler than in Airflow.

### Short Version

Without Airflow, I would use job chaining or a control-table signal so dbt starts only after a successful source load.

---

## Example 3: Airflow + dbt + Databricks For Heavy JSON Parsing From Confluent

### Scenario

The source data came from Confluent and included heavy or complex JSON payloads.

The challenge was that direct warehouse-side parsing was not always the best choice for:

- nested structures
- schema complexity
- performance
- normalization before analytics use

### What I Did In Practice

For heavy JSON coming from Confluent, I did not try to parse everything directly in dbt.

The practical flow I used was:

1. raw JSON arrived from Confluent
2. Databricks parsed and flattened the complex nested payloads
3. the parsed output was written into a structured layer
4. Airflow orchestrated the sequence and triggered downstream steps only after Databricks completed successfully
5. dbt then built the detail and aggregate warehouse models on top of already structured data
6. dbt tests validated the final datasets

### Concrete Answer You Can Say

For that case, I used Databricks, Airflow, and dbt together, but each tool had a clear role. The raw data came from Confluent in heavy nested JSON format, so I used Databricks to do the parsing and flattening because that was the most practical place for heavy transformation. Airflow orchestrated the process and handled dependencies, and once the data was already structured, dbt built the warehouse-side detail and aggregate models and applied the validation layer. So the key thing I implemented was a clean separation between heavy parsing, orchestration, and analytical transformation.

### More Direct Version

What I actually did was move the heavy JSON normalization into Databricks, keep orchestration in Airflow, and use dbt only after the data became structured enough for warehouse modeling. That made the pipeline easier to maintain and more scalable than trying to force all logic into one tool.

### Short Version

I used Databricks for heavy JSON parsing, Airflow for orchestration, and dbt for the final warehouse models and tests.

---

## How To Use These Examples In Interview

Use the practical sequence:

1. start with the problem
2. say what you implemented
3. say how the flow worked
4. finish with the result

---

## Quick Final Phrases

- "I kept brand-specific sources and targets separate, but centralized the shared dbt logic."
- "I made dbt run only after a successful source refresh, not on a blind schedule."
- "I used Databricks for the heavy JSON work, Airflow for orchestration, and dbt for the warehouse layer."
- "My focus was to make the flow maintainable and reliable, not just technically working."