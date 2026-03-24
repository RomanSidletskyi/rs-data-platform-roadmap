# Databricks Learning Materials

This folder is the main theory and platform-design path for the Databricks module.

It is designed to take the learner from first-principles understanding of the platform to practical reasoning about governed compute, jobs, SQL warehouses, Unity Catalog, and lakehouse operating models.

## Reading Path

Start here:

1. `01_databricks_foundations`
2. `02_workspace_compute_and_runtime`
3. `03_data_engineering_patterns`
4. `04_unity_catalog_governance_and_security`
5. `05_databricks_sql_and_analytics_serving`
6. `06_operating_databricks_platforms`
7. `07_databricks_cookbook`

## Suggested Study Tracks

Beginner track:

1. `01_databricks_foundations`
2. `02_workspace_compute_and_runtime`
3. `03_data_engineering_patterns`

Platform engineer track:

1. `02_workspace_compute_and_runtime`
2. `04_unity_catalog_governance_and_security`
3. `06_operating_databricks_platforms`
4. `07_databricks_cookbook`

Analytics delivery track:

1. `03_data_engineering_patterns`
2. `05_databricks_sql_and_analytics_serving`
3. `07_databricks_cookbook`

## Practical Path

If you want the most platform-practical route first, prioritize these chapters:

1. `02_workspace_compute_and_runtime/01_all_purpose_vs_job_clusters_and_sql_warehouses.md`
2. `03_data_engineering_patterns/02_notebook_to_production_job_pattern.md`
3. `04_unity_catalog_governance_and_security/01_unity_catalog_mental_model.md`
4. `05_databricks_sql_and_analytics_serving/03_sql_warehouse_governance_and_cost_control.md`
5. `06_operating_databricks_platforms/02_ci_cd_asset_bundles_and_release_flow.md`
6. `07_databricks_cookbook/01_compute_selection_recipe.md`

## What Each Block Is For

### 01_databricks_foundations

Build the mental model.

Focus:

- what Databricks is and is not
- control plane versus compute plane
- workspaces, notebooks, repos, jobs, and workflows
- how Databricks relates to Spark, Delta, storage, and BI

### 02_workspace_compute_and_runtime

Learn the compute surfaces and runtime controls.

Focus:

- all-purpose clusters versus job clusters
- SQL warehouses
- storage-access surfaces such as volumes and external locations
- cluster policies, pools, standardization, cost levers

### 03_data_engineering_patterns

Place Databricks inside real engineering workflows.

Focus:

- medallion pipelines
- notebook-to-job promotion
- batch, incremental, and streaming shapes
- multi-task pipeline patterns

### 04_unity_catalog_governance_and_security

This is the governance block.

Focus:

- Unity Catalog mental model
- catalogs, schemas, tables, volumes, external locations
- permissions, secrets, identity boundaries
- environment isolation and governance anti-patterns

### 05_databricks_sql_and_analytics_serving

Connect platform processing with business consumption.

Focus:

- Databricks SQL as analytics layer
- gold-table delivery patterns
- dashboards and alerts
- SQL warehouse cost and consumer contracts

### 06_operating_databricks_platforms

This is the operating-model block.

Focus:

- workspace ownership and team boundaries
- CI/CD and Databricks Asset Bundles
- observability, backfills, and incident response
- when Databricks becomes platform debt

### 07_databricks_cookbook

Decision-oriented recipes.

Focus:

- compute selection
- job design
- Unity Catalog rollout decisions
- cost reduction and repair patterns

## Learning Standard

This module should follow the same repository standard as the strongest modules:

- theory first
- examples-heavy explanation
- architecture-first reasoning
- from zero to architect

The goal is not only to memorize where buttons live in the UI.

The goal is to understand what operating responsibilities appear when Spark becomes a shared managed lakehouse platform.