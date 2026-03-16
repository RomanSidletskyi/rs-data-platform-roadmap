# Lakehouse to BI System Design

## Problem Statement

Design a data platform that ingests raw data into a lakehouse, transforms it through bronze, silver, and gold layers, and serves business-ready data to a BI tool.

## Typical Use Cases

- analytics platforms
- curated business reporting
- multi-stage data quality pipelines
- unified batch and streaming analytics
- enterprise dashboards

## Example Architecture

    Sources
        ->
    Ingestion
        ->
    Bronze Layer
        ->
    Silver Layer
        ->
    Gold Layer
        ->
    Semantic / BI Layer
        ->
    Dashboards

## Core Components

- ingestion layer
- object storage
- transactional table format
- bronze layer
- silver layer
- gold layer
- governance and catalog
- BI semantic layer
- dashboards

## Why Each Component Exists

### Ingestion Layer

Moves source data into the platform.

### Bronze Layer

Stores raw or minimally processed records.

### Silver Layer

Holds cleaned, validated, and standardized data.

### Gold Layer

Contains business-ready aggregates, marts, and curated tables.

### Governance and Catalog

Controls access and improves data discoverability.

### BI Semantic Layer

Presents business-friendly data definitions and relationships.

### Dashboards

Deliver reporting and analytics to users.

## Data Flow

1. ingest source data
2. write raw or near-raw data to bronze
3. clean and standardize into silver
4. model business-friendly outputs in gold
5. expose curated data through a semantic model
6. deliver dashboards and reports

## When To Use This Design

- multiple downstream analytics use cases
- a need for raw and curated layers
- shared enterprise data platform
- historical retention and reprocessing needs
- BI consumers require trusted business-ready data

## When Not To Use This Design

- tiny local workflows
- simple single-table reporting
- scripts where a database alone is enough
- one-time ad hoc analysis

## Trade-Offs

Benefits:

- clear separation of layers
- reusable data model
- better governance
- supports both engineering and analytics workflows

Drawbacks:

- more complex than a simple database solution
- needs disciplined data modeling
- can become expensive or messy if poorly designed

## Failure Handling

Typical strategies:

- store raw data in bronze
- rerun transformations from stable upstream layers
- validate before promoting to the next layer
- separate bad records into quarantine
- monitor freshness and data quality

## Common Mistakes

- letting BI read bronze directly
- mixing raw and business logic in one layer
- skipping silver validation
- no semantic model
- no ownership of gold metrics

## Interview Questions

- Why not connect BI directly to raw files?
- What is the purpose of bronze, silver, and gold?
- Why is silver different from gold?
- Why use a semantic layer?
- What are the benefits of a lakehouse over plain files?

## Related Repository Work

- 07-databricks
- 08-delta-lake
- 09-azure-data-lake-storage
- 10-powerbi-fabric
- real-projects/06_databricks_adls_powerbi
- docs/architecture/04_lakehouse_architecture
