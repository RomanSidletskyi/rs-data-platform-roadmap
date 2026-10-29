# Snowflake Platform Learning Guide

This guide preserves the Snowflake learning routes and topic explanations from the former SQL-module section, now organized in the dedicated `16-cloud-databases/01-snowflake/` module.

Use the [capability map](00_snowflake_capability_map.md) for the full feature inventory and the [learning paths](01_learning_paths.md) for a beginner, cross-platform, or architecture route. This guide gives a more detailed reading sequence through the migrated Snowflake material.

The course is designed for a learner who already understands SQL syntax and now needs to understand Snowflake as:

- a cloud data warehouse
- an ingestion platform
- a semi-structured analytics engine
- a participant in open-table lakehouse architecture
- a system with explicit cost, freshness, and interoperability trade-offs

The section is intentionally theory-heavy and example-heavy at the same time.

The target outcome is not only:

- writing valid Snowflake SQL

The target outcome is also:

- understanding what Snowflake owns and what it does not own
- recognizing when Snowflake-native tables are the right answer
- recognizing when external tables or Iceberg are the right answer
- reasoning about refresh semantics, ingestion boundaries, and consumer contracts
- speaking about Snowflake at senior and architect level in real project discussions

## Reading Path

Recommended order:

1. [Snowflake SQL reference](reference/snowflake_sql.md)
2. [Snowflake ingestion](deep-dives/Snowflake_ingestion.md)
3. [Snowflake performance](deep-dives/Snowflake_performance.md)
4. [Snowflake semi-structured data](deep-dives/Snowflake_semi_structured_data.md)
5. [Snowflake-managed Iceberg](deep-dives/iceberg-and-external-tables/Snowflake_managed_Iceberg.md)
6. [Open Catalog](deep-dives/iceberg-and-external-tables/Snowflake_Open_Catalog.md)
7. [Open Catalog cookbook](deep-dives/iceberg-and-external-tables/Snowflake_Open_Catalog_cookbook.md)
8. [Externally managed Iceberg](deep-dives/iceberg-and-external-tables/Snowflake_externally_managed_Iceberg.md)
9. [Externally managed Iceberg cookbook](deep-dives/iceberg-and-external-tables/Snowflake_externally_managed_Iceberg_cookbook.md)
10. [Table type decision guide](deep-dives/iceberg-and-external-tables/Snowflake_table_type_decision_guide.md)
11. [External tables](deep-dives/iceberg-and-external-tables/Snowflake_external_tables.md)
12. [Dynamic tables](deep-dives/Snowflake_dynamic_tables.md)
13. [Data platform architecture](architecture/Data_platform_architecture.md)
14. [Non-functional requirements](architecture/Non_functional_requirements_NFR.md)
15. [Semi-structured performance](deep-dives/semi_structured_performance.md)
16. [System design answers](architecture/system_design_ready_answers.md)
17. [Senior architecture questions](architecture/Top_tricky_senior_questions.md)

## Suggested Study Tracks

Beginner-to-practical track:

1. [Snowflake SQL reference](reference/snowflake_sql.md)
2. [Snowflake ingestion](deep-dives/Snowflake_ingestion.md)
3. [Semi-structured data](deep-dives/Snowflake_semi_structured_data.md)
4. [External tables](deep-dives/iceberg-and-external-tables/Snowflake_external_tables.md)
5. [Table type decision guide](deep-dives/iceberg-and-external-tables/Snowflake_table_type_decision_guide.md)

Platform engineer track:

1. [Snowflake ingestion](deep-dives/Snowflake_ingestion.md)
2. [Snowflake performance](deep-dives/Snowflake_performance.md)
3. [Snowflake-managed Iceberg](deep-dives/iceberg-and-external-tables/Snowflake_managed_Iceberg.md)
4. [Open Catalog](deep-dives/iceberg-and-external-tables/Snowflake_Open_Catalog.md)
5. [Open Catalog cookbook](deep-dives/iceberg-and-external-tables/Snowflake_Open_Catalog_cookbook.md)
6. [Externally managed Iceberg](deep-dives/iceberg-and-external-tables/Snowflake_externally_managed_Iceberg.md)
7. [Externally managed Iceberg cookbook](deep-dives/iceberg-and-external-tables/Snowflake_externally_managed_Iceberg_cookbook.md)
8. [Dynamic tables](deep-dives/Snowflake_dynamic_tables.md)
9. [Data platform architecture](architecture/Data_platform_architecture.md)

Architect track:

1. [Snowflake-managed Iceberg](deep-dives/iceberg-and-external-tables/Snowflake_managed_Iceberg.md)
2. [Open Catalog](deep-dives/iceberg-and-external-tables/Snowflake_Open_Catalog.md)
3. [Open Catalog cookbook](deep-dives/iceberg-and-external-tables/Snowflake_Open_Catalog_cookbook.md)
4. [Externally managed Iceberg](deep-dives/iceberg-and-external-tables/Snowflake_externally_managed_Iceberg.md)
5. [Externally managed Iceberg cookbook](deep-dives/iceberg-and-external-tables/Snowflake_externally_managed_Iceberg_cookbook.md)
6. [Table type decision guide](deep-dives/iceberg-and-external-tables/Snowflake_table_type_decision_guide.md)
7. [External tables](deep-dives/iceberg-and-external-tables/Snowflake_external_tables.md)
8. [Dynamic tables](deep-dives/Snowflake_dynamic_tables.md)
9. [Data platform architecture](architecture/Data_platform_architecture.md)
10. [Non-functional requirements](architecture/Non_functional_requirements_NFR.md)
11. [System design answers](architecture/system_design_ready_answers.md)

## What The New Files Add

### `Snowflake_managed_Iceberg.md`

Use this file to understand:

- why open table formats matter
- what Snowflake-managed Iceberg really means
- how external volume, table metadata, and object storage boundaries fit together
- when Iceberg is a real interoperability strategy and when it is just complexity

### `Snowflake_Open_Catalog.md`

Use this file to understand:

- what Snowflake Open Catalog actually is and why it is not the same thing as a Snowflake table type
- how Open Catalog sits between Snowflake-managed and externally managed Iceberg patterns
- when Open Catalog is a shared REST-catalog control plane versus when it is only a sync target
- how service principals, catalog roles, credential vending, and sync boundaries change architecture

### `Snowflake_Open_Catalog_cookbook.md`

Use this file to understand:

- how to set up practical Open Catalog flows for query, sync, and engine onboarding
- how service principals, catalog integrations, and storage layout appear in real workflows
- how Open Catalog differs operationally from Horizon Catalog for external-engine access
- how to debug the most common control-plane and storage-boundary mistakes

### `Snowflake_externally_managed_Iceberg.md`

Use this file to understand:

- what changes when Snowflake is not the metadata control plane
- how external catalogs, catalog integrations, and catalog-linked databases actually work
- when Snowflake should be one engine in an Iceberg ecosystem instead of the owner of table state
- how to reason about refresh, write support, catalog sync, and operational failure modes

### `Snowflake_externally_managed_Iceberg_cookbook.md`

Use this file to understand:

- how to assemble end-to-end externally managed Iceberg patterns with real SQL
- how standard databases differ from catalog-linked databases in practice
- how to operationalize refresh, writes, health checks, and incident recovery
- how Glue-like and REST-catalog-like workflows differ at the platform boundary

### `Snowflake_table_type_decision_guide.md`

Use this file to understand:

- how to choose between native Snowflake tables, Snowflake-managed Iceberg, externally managed Iceberg, and external tables
- which trade-offs are about control-plane ownership versus performance versus interoperability
- which option fits raw, curated, published, and multi-engine contracts
- how to defend the decision in architecture reviews and interviews

### `Snowflake_external_tables.md`

Use this file to understand:

- how to query files in place without loading them into native Snowflake tables
- when external tables are a fast discovery layer versus a bad substitute for modeled ingestion
- how partition expressions, metadata columns, and file-layout choices shape performance

### `Snowflake_dynamic_tables.md`

Use this file to understand:

- how declarative refresh works in Snowflake
- when target-lag-driven pipelines are a good fit
- where dynamic tables fit relative to tasks, streams, dbt, and materialized views
- how to think about freshness, cost, and transformation boundaries

## Practical Standard

This folder should be studied with two questions in mind:

1. What problem is this feature solving in a real platform?
2. What platform debt appears if the feature is used in the wrong place?

The practical examples are intentionally shaped as:

- small cookbook snippets
- production-shaped SQL patterns
- design rules for choosing between similar options

If you use the section correctly, you should leave with:

- syntax fluency
- operational intuition
- architecture judgment