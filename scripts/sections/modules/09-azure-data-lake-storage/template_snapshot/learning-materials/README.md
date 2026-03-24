# Azure Data Lake Storage Learning Materials

This folder is the main theory and platform-design path for the Azure Data Lake Storage module.

It is designed to take the learner from first-principles understanding of ADLS Gen2 as a storage foundation to practical reasoning about namespace design, access control, ingestion patterns, lifecycle trade-offs, and architecture boundaries.

The intended outcome is not only:

- knowing which Azure resources need to be created

The intended outcome is also:

- understanding why hierarchical namespace changes the storage model
- seeing why naming, path design, and ownership rules matter before data volume grows
- recognizing the boundary between storage design and compute design
- learning how ADLS supports lakehouse, warehouse, and governed data-platform patterns without becoming a dumping ground

## Reading Path

Start here:

1. `01_adls_foundations`
2. `02_namespace_layout_and_storage_modeling`
3. `03_security_identity_and_governance`
4. `04_ingestion_access_and_operating_patterns`
5. `05_cost_performance_and_reliability`
6. `06_adls_in_data_platform_architecture`
7. `07_adls_cookbook`

## Suggested Study Tracks

Beginner track:

1. `01_adls_foundations`
2. `02_namespace_layout_and_storage_modeling`
3. `03_security_identity_and_governance`

Platform engineer track:

1. `02_namespace_layout_and_storage_modeling`
2. `03_security_identity_and_governance`
3. `05_cost_performance_and_reliability`
4. `06_adls_in_data_platform_architecture`

Practical engineer track:

1. `04_ingestion_access_and_operating_patterns`
2. `05_cost_performance_and_reliability`
3. `07_adls_cookbook`

## Practical Path

If you want the most implementation-relevant route first, prioritize these chapters:

1. `02_namespace_layout_and_storage_modeling/01_container_strategy_and_path_design.md`
2. `03_security_identity_and_governance/01_rbac_acl_and_identity_mental_model.md`
3. `04_ingestion_access_and_operating_patterns/01_raw_landing_curated_and_publish_zones.md`
4. `05_cost_performance_and_reliability/02_transaction_size_small_files_and_listing_costs.md`
5. `06_adls_in_data_platform_architecture/02_adls_with_databricks_synapse_and_fabric.md`
6. `07_adls_cookbook/01_container_and_path_decision_recipe.md`

These chapters should become the densest mix of:

- practical examples
- storage-design reasoning
- security and ownership trade-offs
- architecture-level explanations

## What Each Block Is For

### 01_adls_foundations

Build the storage mental model.

Focus:

- what ADLS Gen2 is and is not
- hierarchical namespace
- blob storage versus lake storage mental models
- core resource boundaries

Questions to keep in mind:

- what does ADLS improve over flat object storage?
- what is still only a file system concern rather than a data-model concern?
- what responsibilities stay with engineers even when storage is managed?

### 02_namespace_layout_and_storage_modeling

Learn how to structure the lake deliberately.

Focus:

- container strategy
- folder and path naming
- dataset ownership and domain boundaries
- partitioning and file-layout implications at the storage level

Questions to keep in mind:

- which paths are stable contracts and which are internal?
- who owns each path boundary?
- what path decisions become painful later if left vague?

### 03_security_identity_and_governance

This is the access-control block.

Focus:

- Entra ID identities
- RBAC versus ACLs
- managed identities and service principals
- least privilege and governance anti-patterns

Questions to keep in mind:

- who should reach the storage account, container, or folder?
- what should be inherited and what should be explicit?
- where does convenience create future security debt?

### 04_ingestion_access_and_operating_patterns

Place storage inside real workflows.

Focus:

- raw landing, curated, and publish patterns
- batch, streaming, and event-driven ingestion shapes
- access patterns from Spark, SQL engines, and applications
- replay and overwrite safety

Questions to keep in mind:

- where does landed data become trusted?
- how should producers and consumers be separated?
- what paths are safe for repeated writes and backfills?

### 05_cost_performance_and_reliability

This is the storage-operating block.

Focus:

- transaction and listing behavior
- small files and file-count growth
- lifecycle and retention
- resilience, recovery, and monitoring

Questions to keep in mind:

- what actually drives storage cost here?
- which patterns create operational slowness before they create outages?
- how do we keep recovery possible without keeping everything forever?

### 06_adls_in_data_platform_architecture

Place ADLS in the bigger system.

Focus:

- ADLS with Databricks, Synapse, Fabric, and orchestration tools
- storage versus catalog versus compute boundaries
- medallion-style storage and domain-driven data products
- when ADLS is necessary but not sufficient

Questions to keep in mind:

- what does storage own and what does it not own?
- what contracts sit above paths and files?
- when does a storage problem actually signal a modeling or ownership problem?

### 07_adls_cookbook

Decision-oriented recipes.

Focus:

- how to choose containers and path boundaries
- how to separate teams and environments safely
- how to expose publish paths to consumers
- how to control cost and recovery risk

Use this block after the theory chapters, not before them.

## Learning Standard

This module should follow the same repository standard as the strongest modules:

- theory first
- examples-heavy explanation
- architecture-first reasoning
- from zero to architect

The goal is not only to learn storage terminology.

The goal is to understand what changes when a cloud file system becomes the foundational storage layer of a governed data platform.

Keep one architectural rule in mind while reading the whole block:

- ADLS gives durable scalable storage, but it does not by itself create good ownership, good contracts, good schemas, or good platform boundaries.
