# 07-databricks

This module teaches Databricks as a managed data-platform environment rather than as "Spark with a nicer notebook UI".

It sits after Spark for a reason.

First the learner needs the distributed processing mental model.

Then they can understand what Databricks adds around that engine:

- managed compute
- workspaces and collaboration surfaces
- job orchestration inside the platform
- governance through Unity Catalog
- SQL warehouses and analytics delivery
- operational patterns for teams that run lakehouse platforms at scale

## Why This Module Matters

Many engineers can write PySpark locally but still do not understand how a real managed lakehouse platform should be operated.

Databricks matters because it changes the problem from:

- how do I run one Spark job?

to:

- how do teams govern, schedule, secure, observe, and deliver data products on a shared platform?

That matters in real systems such as:

- medallion pipelines on cloud object storage
- governed analytics delivery to BI teams
- job-based production data engineering
- managed streaming and incremental pipelines
- multi-team workspaces with cost and access controls

Without a solid Databricks foundation, later modules such as Delta Lake, ADLS, Power BI, and end-to-end lakehouse projects become much more shallow.

## What This Module Is Really About

This module covers Databricks on three levels at the same time.

Level 1: platform fundamentals

- what Databricks is and is not
- control plane versus compute plane
- workspaces, notebooks, repos, jobs, and SQL warehouses
- how Databricks relates to Spark, Delta Lake, ADLS, and BI

Level 2: engineering practice

- cluster selection and compute modes
- medallion pipeline design in Databricks
- notebook-to-job promotion
- Databricks Asset Bundles and release flow
- SQL warehouse and curated analytics delivery patterns

Level 3: architecture and platform operations

- Unity Catalog governance boundaries
- environment isolation across dev, stage, and prod
- cost control and performance trade-offs
- platform ownership, observability, backfills, and reliability
- when Databricks is the right platform and when it is not

## What Databricks Is

Databricks is a managed data and analytics platform built around the lakehouse model.

At a practical level, it gives you:

- managed Spark-based compute
- notebook and SQL authoring surfaces
- jobs and workflow execution
- workspace collaboration features
- Unity Catalog governance
- integrations with storage, BI, and machine learning workflows

For a data engineer, Databricks is usually the place where raw-to-curated processing, governed analytics tables, and production jobs meet.

## Databricks Vs Spark Vs Delta Lake Vs ADLS Vs Power BI

These concepts should be separated clearly.

- Apache Spark: the processing engine
- Databricks: the managed platform around Spark and lakehouse workflows
- Delta Lake: the table format and transactional storage layer often used inside that platform
- ADLS: the object storage layer where data files physically live in Azure-centered setups
- Power BI: a downstream analytics and BI consumption layer

Short version:

- Spark = compute engine
- Databricks = managed platform and workspace
- Delta Lake = table/storage semantics
- ADLS = cloud storage substrate
- Power BI = business consumption layer

This distinction matters because beginners often say "Databricks stores data" or "Databricks is Spark".

Those statements are incomplete.

Usually:

- data physically lives in cloud storage
- tables are represented through Delta or another table layer
- Spark does the compute
- Databricks manages the environment where teams build and run that compute

## What Databricks Is Not

Databricks is not:

- a substitute for understanding Spark execution
- a guarantee that every notebook is production-ready
- the same thing as Delta Lake
- a BI semantic layer by itself
- a reason to skip governance, environment design, or platform ownership

Common bad assumptions:

- "If it runs in a notebook, it is production data engineering"
- "Databricks automatically fixes weak data models"
- "More cluster size is the answer to every slow pipeline"
- "A shared workspace with no governance is still a platform"

## Databricks In The Learning Sequence

This module sits in the Lakehouse phase.

The intended progression is:

- Spark teaches distributed processing
- Databricks teaches managed lakehouse platform operation
- Delta Lake deepens table-format and transactional modeling
- ADLS deepens cloud storage and data layout thinking

That means this module should not duplicate Spark internals unnecessarily.

It should teach what changes when distributed compute is embedded inside a managed platform used by teams.

## Main Learning Goals

By the end of this module, the learner should be able to:

- explain Databricks as a platform rather than just a notebook product
- distinguish workspaces, compute, jobs, repos, SQL warehouses, and governance layers
- choose between all-purpose clusters, job clusters, and SQL warehouses responsibly
- place Unity Catalog correctly in the platform architecture
- design medallion pipelines in a Databricks-friendly way
- move from exploratory notebooks toward repeatable production jobs
- reason about environment isolation, secrets, permissions, and release boundaries
- explain Databricks cost drivers and common platform debt patterns
- connect Databricks outputs to Delta, ADLS, and BI consumers cleanly

## Module Structure

    07-databricks/
        README.md
        learning-materials/
        simple-tasks/
        pet-projects/

## Learning Materials

The learning materials are organized into seven topic groups.

1. `01_databricks_foundations`
2. `02_workspace_compute_and_runtime`
3. `03_data_engineering_patterns`
4. `04_unity_catalog_governance_and_security`
5. `05_databricks_sql_and_analytics_serving`
6. `06_operating_databricks_platforms`
7. `07_databricks_cookbook`

## Best Entry Points

If the learner wants the cleanest beginner-to-architect route:

1. `learning-materials/01_databricks_foundations`
2. `learning-materials/02_workspace_compute_and_runtime`
3. `simple-tasks/01_databricks_foundations`
4. `simple-tasks/02_workspace_compute_and_runtime`
5. `pet-projects/01_medallion_batch_pipeline_workspace_lab`

If the learner wants the platform-engineering route first:

1. `learning-materials/04_unity_catalog_governance_and_security`
2. `learning-materials/06_operating_databricks_platforms`
3. `learning-materials/07_databricks_cookbook`
4. `pet-projects/03_jobs_and_asset_bundle_release_lab`

If the learner wants the analytics-delivery route first:

1. `learning-materials/05_databricks_sql_and_analytics_serving`
2. `pet-projects/02_unity_catalog_governed_gold_layer_lab`
3. `pet-projects/04_kafka_to_databricks_serving_pipeline_lab`

## How The Module Parts Work Together

- `learning-materials/` explains concepts, trade-offs, and platform decisions
- `simple-tasks/` forces small implementation and design choices
- `pet-projects/` turns those choices into production-shaped Databricks labs

The strongest sequence is usually:

1. read one learning block
2. complete the matching task block
3. use one pet project to combine compute, governance, and delivery concerns

## Expected Outcome

After this module, the learner should be able to discuss Databricks as a real platform with clear boundaries around compute, governance, storage, jobs, and analytics consumers rather than treating it as just a place where notebooks run.