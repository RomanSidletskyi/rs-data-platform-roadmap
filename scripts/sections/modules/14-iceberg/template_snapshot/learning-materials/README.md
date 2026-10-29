# Iceberg Learning Materials

This folder is the main theory and architecture path for the Iceberg module.

It is designed to take the learner from zero knowledge of open table formats to architect-level reasoning about metadata, catalogs, Spark execution, AWS deployment, and multi-engine control planes.

The intended outcome is not only:

- knowing Iceberg commands

The intended outcome is also:

- understanding why Iceberg exists above files
- understanding the full metadata tree and commit model
- reasoning about catalogs as the real control plane
- seeing how Iceberg behaves on AWS and across other platforms
- understanding how Spark actually reads, writes, and maintains Iceberg tables

## Reading Path

Start here:

1. `01_iceberg_foundations`
2. `02_metadata_and_table_internals`
3. `03_catalogs_and_control_plane`
4. `04_iceberg_on_aws_and_other_platforms`
5. `05_spark_with_iceberg`
6. `06_operations_governance_and_tradeoffs`
7. `07_iceberg_cookbook`

## Suggested Study Tracks

Beginner track:

1. `01_iceberg_foundations`
2. `02_metadata_and_table_internals`
3. `05_spark_with_iceberg`

Platform engineer track:

1. `02_metadata_and_table_internals`
2. `03_catalogs_and_control_plane`
3. `04_iceberg_on_aws_and_other_platforms`
4. `05_spark_with_iceberg`
5. `07_iceberg_cookbook`

Architect track:

1. `03_catalogs_and_control_plane`
2. `04_iceberg_on_aws_and_other_platforms`
3. `05_spark_with_iceberg`
4. `06_operations_governance_and_tradeoffs`
5. `07_iceberg_cookbook`

## What Each Block Is For

### 01_iceberg_foundations

Build the first-principles mental model.

Focus:

- what Iceberg is and is not
- why table formats exist above files
- when Iceberg solves real platform problems
- when it is too much complexity

### 02_metadata_and_table_internals

This is the deepest technical block.

Focus:

- metadata root files
- snapshots and manifests
- manifest lists versus manifests versus data files
- format versions `v1`, `v2`, and what changes operationally
- delete files, row-level semantics, and version-specific mutation behavior
- branching, tags, snapshot references, and retention behavior
- raw field-level reading of `metadata.json`, manifest lists, and manifests
- partition specs, sort orders, schemas, sequence numbers
- commit logic, metadata rebuilds, concurrency, row-level changes, and planning

### 03_catalogs_and_control_plane

This block explains the real control plane.

Focus:

- what catalogs do
- Glue, Hive, REST, Nessie, Open Catalog, and Unity-style patterns
- governance, namespaces, security, and ownership boundaries

### 04_iceberg_on_aws_and_other_platforms

This block places Iceberg in real infrastructure.

Focus:

- Iceberg on S3, Glue, Athena, EMR, and Spark
- where else Iceberg is built and operated
- what changes across cloud and platform choices

### 05_spark_with_iceberg

This is the execution-model block.

Focus:

- how Spark reads and writes Iceberg
- catalog configuration and APIs
- real Spark job shapes and `spark-submit` patterns
- practical Glue catalog usage on AWS
- streaming, maintenance, and troubleshooting

### 06_operations_governance_and_tradeoffs

This is the operating-model block.

Focus:

- maintenance
- small-files and cost problems
- architecture debt and anti-patterns
- when Iceberg should not be used

### 07_iceberg_cookbook

Decision-oriented recipes.

Use this after the theory chapters.

Focus:

- create and query flows
- evolution and time travel flows
- platform and catalog decision recipes
- merge, CDC, delete, and post-mutation compaction recipes
- SCD Type 1 and Type 2 design recipes with Spark and Iceberg
- fact-table upsert versus dimension SCD design recipes
- snapshot-based ingestion versus CDC ingestion design recipes

Recommended cookbook sequence:

1. `01_create_and_query_recipe.md`
2. `02_evolution_and_time_travel_recipe.md`
3. `03_catalog_and_platform_decision_recipe.md`
4. `04_manual_metadata_trace_recipe.md`
5. `05_v1_v2_mutation_decision_recipe.md`
6. `06_merge_and_cdc_patterns_recipe.md`
7. `07_scd_type_1_and_type_2_recipe.md`
8. `08_fact_upserts_vs_dimension_scd_recipe.md`
9. `09_snapshot_vs_cdc_ingestion_recipe.md`

## Learning Standard

This module should follow the strongest repository standard:

- theory first
- examples-heavy explanation
- architecture-first reasoning
- from zero to architect

Keep one rule in mind throughout the whole module:

- Iceberg is not only a file format decision; it is a metadata and control-plane design decision.