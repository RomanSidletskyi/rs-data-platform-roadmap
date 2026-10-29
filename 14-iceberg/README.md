# Iceberg

This module is a full learning path for Apache Iceberg from first principles to architect-level reasoning.

The goal is not only to know Iceberg syntax.

The goal is also to understand:

- why Iceberg exists above Parquet files
- how its metadata tree really works
- why catalogs are the real control plane of an Iceberg platform
- how Spark plans and executes Iceberg reads and writes
- where Iceberg fits well and where it creates unnecessary platform complexity

## Why This Module Matters

Many engineers first meet Iceberg through a narrow lens:

- a Spark demo
- a `CREATE TABLE USING iceberg` example
- a table-format comparison chart

That is too shallow for production work.

Iceberg becomes important when teams need:

- table semantics above raw files
- safe schema and partition evolution
- snapshot-based history and time travel
- multi-engine interoperability
- clearer separation between storage, metadata control plane, and compute engines

At architect level, the hard questions are not only about SQL.

They are about:

- metadata ownership
- catalog choice
- object-store realities
- write concurrency
- consumer contracts
- engine interoperability boundaries

## What You Will Learn

This module covers:

- what Iceberg is and what it is not
- why table formats exist above plain files
- detailed metadata structure: metadata JSON, manifest lists, manifests, data files, snapshots, sequence numbers, specs, sort orders
- format versions `v1`, `v2`, and the practical implications of newer metadata semantics
- delete files, snapshot references, branching, and retention behavior
- commit model, optimistic concurrency, and row-level change semantics
- the catalog layer: Hive, Glue, REST, Nessie, Open Catalog, Unity-style control planes
- Iceberg on AWS with S3, Glue, Athena, EMR, and Spark
- where else Iceberg is built and operated across engines and platforms
- how Spark reads, writes, plans, and maintains Iceberg tables with real job examples
- when to use Iceberg, when not to use it, and what platform debt it can create

## Learning Structure

### Learning Materials

The theory path is organized into seven blocks:

1. `01_iceberg_foundations`
2. `02_metadata_and_table_internals`
3. `03_catalogs_and_control_plane`
4. `04_iceberg_on_aws_and_other_platforms`
5. `05_spark_with_iceberg`
6. `06_operations_governance_and_tradeoffs`
7. `07_iceberg_cookbook`

Start with [learning-materials/README.md](/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/14-iceberg/learning-materials/README.md).

### Simple Tasks

This module now starts practical work with:

- metadata and current-table-state tracing
- Spark + Glue catalog setup and first writes
- `MERGE`, CDC, fact upserts, and SCD modeling choices

Current simple-task blocks:

1. `01_iceberg_metadata_and_table_state`
2. `02_spark_glue_and_first_writes`
3. `03_merge_cdc_and_modeling_patterns`
4. `04_schema_partition_and_compatibility`
5. `05_branching_retention_and_governance`
6. `06_troubleshooting_and_failure_modes`
7. `07_maintenance_cost_and_cleanup`

This module should continue training the learner on:

- first table creation and inspection
- reading table metadata
- schema and partition evolution decisions
- catalog configuration choices
- Spark read and write patterns
- maintenance and failure-mode reasoning

### Pet Projects

This module now starts guided project work with:

1. `01_spark_glue_orders_lakehouse`

This module should continue including project work around:

- Spark + Iceberg batch pipelines
- lakehouse publish contracts on AWS
- multi-engine catalog design
- operations and troubleshooting scenarios at scale

## Related Modules

- 06-spark-pyspark
- 07-databricks
- 08-delta-lake
- 09-azure-data-lake-storage
- 13-flink

## Completion Criteria

By the end of this module, you should be able to:

- explain the full Iceberg metadata structure from metadata root file down to data files
- compare Iceberg against plain Parquet and other table-format approaches at architecture level
- explain what a catalog does and why it is central to the platform design
- reason about AWS-native Iceberg designs with S3, Glue, Athena, EMR, and Spark
- explain how Spark plans scans, commits writes, and performs maintenance with Iceberg
- defend when Iceberg is the right answer and when native warehouse tables or simpler file patterns are better
