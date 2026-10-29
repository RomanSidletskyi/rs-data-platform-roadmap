# Solution: Task Set 09

These are example approaches. A different answer can be strong when it states the assumptions, constraints, and evidence supporting it.

## Scenario 1: Filters on a Nested Event Field Scan Too Much

Check Query Profile, partitions scanned, data distribution, types, and whether the nested fields are eligible for subcolumnarization. Snowflake can collect and use metadata for some semi-structured paths; it is inaccurate to assume that only top-level attributes can ever prune. Extraction has limits and is affected by path depth, nulls, and type consistency.

For recurring filters and joins, project `event_ts` and `customer_id` into typed columns in a curated/staging table. Compare representative workloads before considering clustering or Search Optimization. The cost of extra storage and transformation must be justified by repeated query savings.

## Scenario 2: `FLATTEN` Produces an Unexpected Row Explosion

The grain changes from event to item to item-discount. Expanding two arrays creates a multiplicative result when each discount is paired with each item under the actual input structure. Filter source records and payload paths, project only needed elements, and expand only at the grain required by the output. If several consumers repeat the same expansion, consider a tested staging table or transformation model.

Compare counts and business totals at event, item, and discount grain using a representative sample. Query optimizers may reorder work, so validate the actual plan rather than assuming textual SQL order alone controls execution.

## Scenario 3: External Table or Native Serving Table?

Use the external table as a discovery/validation boundary when same-day file visibility matters. Once the schema and quality rules are stable, load validated data into native Snowflake tables for repeated joins, curated contracts, and completeness controls. Make the load replayable with source file/batch identity and deterministic deduplication.

An Iceberg publish is justified if another engine must consume the same table contract. Otherwise it adds catalog, storage, and lifecycle responsibilities without a stated need. A materialized view over an external table can help eligible repeated reads, but check edition, refresh behavior, and cost; it does not replace the full ingestion contract.

## Scenario 4: Snowflake and Spark Need the Same Curated Table

Snowflake-managed Iceberg is a candidate because Snowflake owns publishing and the data must be shared as an Iceberg contract. Snowflake can use Snowflake-managed storage or an external volume, subject to current configuration and feature support. Snowflake owns the Iceberg catalog state; the platform must separately provide Spark with a supported catalog/access path and govern it.

Native Snowflake tables are simpler and often a better Snowflake-only serving choice, but they do not themselves provide the same open-table contract. Verify external-engine read/write direction, region, account, security, and lifecycle support before selecting Iceberg.

## Scenario 5: Spark and Glue Already Own the Iceberg Catalog

Externally managed Iceberg is the likely fit: Glue remains the metadata authority and Snowflake joins through a supported catalog integration. Explicitly assign catalog maintenance, schema evolution, snapshot retention, storage access, refresh/commit monitoring, and incident ownership.

Current Snowflake documentation describes write support for externally managed Iceberg through supported Iceberg REST catalog integrations and Iceberg specification versions 2 and 3, with important limitations. Validate the exact catalog endpoint, credential vending or external-volume setup, transaction semantics, row-level delete behavior, and region/storage compatibility. If only reads are needed, do not enable a write path without a requirement.

## Scenario 6: Open Catalog or Horizon Catalog?

Horizon Catalog is the recommended direction for a new customer exposing Snowflake-managed Iceberg tables to external query engines. Current Snowflake documentation says new customers cannot create their first Snowflake Open Catalog account; existing Open Catalog customers can continue using and creating additional accounts.

Open Catalog remains relevant for existing deployments and for Iceberg tables where it is the actual external catalog authority. It is not interchangeable with Horizon: compare whether the requirement is external engines reading Snowflake-managed tables or multiple engines sharing an external catalog control plane. Recheck product onboarding and availability before a production decision.

## Scenario 7: New Files Exist but External-Table Results Look Stale

First verify that files are in the stage path and match the external table's pattern and file format. Then inspect external-table file registration/history and auto-refresh event registration; use `ALTER EXTERNAL TABLE ... REFRESH` when manual registration is appropriate. Ownership transfer can disable auto-refresh, so check the current `AUTO_REFRESH` setting and event integration.

External-table metadata registration is separate from query-result reuse. Changes not yet reflected in registered metadata do not necessarily invalidate a persisted query result. Confirm that registration completed and then rerun the query. Monitor refresh errors and freshness, not just object-storage timestamps.

## Scenario 8: Choose a Freshness and Orchestration Model

Dynamic tables may fit a supported declarative SQL transformation with a target freshness objective. Streams and tasks may fit explicit incremental SQL or task-graph control. dbt is useful for versioned SQL transformations, tests, lineage, and deployment. Airflow is a candidate for the workflow crossing files, external API, Snowflake, and notification.

Assign one system ownership of end-to-end scheduling, retries, and incident state. Snowflake-native tasks can own an internal subgraph if the external orchestrator clearly owns the broader workflow and duplicate schedules are avoided.

## Scenario 9: Shared Warehouse Queues and Spend Rises

Use query history and Query Profile to distinguish queue time from execution, then inspect warehouse load, concurrent workload classes, idle runtime, and usage attribution. A BI warehouse and scheduled transformation/ingestion warehouses may isolate noisy workloads; scheduling and auto-suspend can reduce idle usage. Choose the simplest separation that solves measured contention.

Do not resize everything or add multi-cluster capacity until you know whether the problem is concurrency, scan volume, spill, or inefficient SQL. Compare cost and effects on all consumers after any change.

## Scenario 10: Choose a File and Partition Layout

Start with stable date-oriented paths and well-sized Parquet files/row groups suited to the workload. External tables can derive partition columns from paths; Iceberg has explicit partition metadata and transforms. Avoid high-cardinality `customer_id` partitioning and excessive dimensions unless query and data volume evidence supports them.

Tiny files add metadata and scheduling overhead. Inconsistent folders make partition expressions and operations brittle. Benchmark common date and customer queries and consider sorting/clustering or a different serving table where supported; do not assume one layout optimizes both table types equally.

## Scenario 11: A Multi-Engine Schema Change Breaks Consumers

Treat the dataset as a versioned contract. Add compatible fields first, test decimal widening and nested-field behavior in each engine, avoid ordinal-position reads, publish schema and type guarantees, and observe consumer adoption. For renames, prefer a transition with old and new names or a versioned table/view until consumers migrate.

Validate read/write compatibility against the Iceberg spec version and each engine's implementation. Set a deprecation window and owner; remove the old field only after consumer evidence and an agreed change process.

## Scenario 12: Regional Recovery for an Iceberg Data Product

Replicating Snowflake alone is insufficient. Include Iceberg data files, current snapshot/catalog metadata, catalog availability and promotion, storage access, credentials, network path, Snowflake account/region capabilities, Spark configuration, orchestration, consumer endpoints, and validation.

Define the consistency point and who declares failover. Run a timed exercise that restores access, checks the latest committed snapshot and data quality, restarts producers/consumers, and measures RPO/RTO. Include data-residency restrictions, cloud egress, storage replication lag, and failure of the catalog as separate trade-offs.

## Review Rubric

A strong response states assumptions, compares a simpler alternative, identifies the correct metadata or operational owner, ties performance claims to measurements, and specifies how correctness and recovery will be validated. A feature list without a constraint-driven recommendation is incomplete.