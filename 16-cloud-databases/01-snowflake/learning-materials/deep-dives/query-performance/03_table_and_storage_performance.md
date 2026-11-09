# Table and Storage Performance: Native, External, and Iceberg

Performance tuning starts with understanding what the scan reads and who owns the table state. A Snowflake native table, an external table, and an Iceberg table can all be queried with SQL, but their storage, metadata, write, and maintenance paths differ.

## 1. Snowflake Native Tables

A standard Snowflake table is stored in Snowflake-managed storage and automatically organized into columnar micro-partitions. Snowflake maintains metadata that can prune irrelevant partitions and columns. Users do not create traditional B-tree indexes or manually define static partitions for standard table scans.

### What to inspect

- columns projected and bytes scanned
- filters and partitions scanned versus total
- natural clustering and overlap for repeated predicates
- join/aggregation/window input rows and spill
- table growth and mutation patterns
- Query Profile's extracted VARIANT paths, when relevant

### Design implications

- Stable, frequently filtered and joined attributes are good candidates for typed columns.
- Natural load order can produce useful clustering without a declared clustering key.
- Repeated merges or random inserts can increase overlap and weaken pruning over time.
- A wider schema does not automatically make every scan slow because Snowflake uses columnar storage, but selecting unused wide or semi-structured values can increase work.
- Cluster keys are an optional maintenance decision, not a partitioning prerequisite.

## 2. External Tables

An external table is a read-only Snowflake object over files in an external stage. It records file-level metadata and exposes rows/virtual columns; it does not ingest the file data into standard Snowflake table storage. Query latency and pruning depend on storage location, file format, file and row-group layout, path partitions, metadata registration, and the query shape.

### Performance factors

- **File and row-group size:** Snowflake documentation provides format-specific sizing recommendations. For Parquet, the documented recommended file range is 256–512 MB and row groups 16–256 MB; treat these as starting guidance and benchmark the actual workload.
- **Path layout:** stable date or domain paths let partition expressions eliminate irrelevant files. A path convention is part of the table contract.
- **Virtual columns:** define frequently used fields as typed external-table columns instead of repeatedly extracting raw `VALUE` paths when that improves the observed plan.
- **Metadata freshness:** file arrival and external-table metadata registration are separate. Event-based auto-refresh and manual refresh have setup and maintenance costs.
- **Repeated serving:** repeated heavy joins or BI queries over external files may justify materialization, ingestion into native tables, or a supported open-table path.

External tables are read-only and do not provide Iceberg snapshot semantics. Current Snowflake documentation also describes Parquet Direct as a preview read-only Iceberg option for Parquet files; check its current availability and restrictions before adopting it.

## 3. Iceberg Tables

Iceberg adds a table metadata and snapshot layer over data files. Query performance therefore depends on file/row-group shape, partition specification and evolution, snapshot metadata, delete files where applicable, catalog/refresh behavior, and the reading engine.

Keep these dimensions separate:

- **Catalog authority:** Snowflake-managed Iceberg has Snowflake as catalog authority; externally managed Iceberg relies on the remote catalog.
- **Storage authority:** Snowflake-managed tables can use Snowflake-managed storage or a customer-managed external volume. Externally managed tables use external storage and catalog paths.
- **Maintenance authority:** Snowflake manages lifecycle operations for supported Snowflake-managed tables; externally managed table maintenance is owned by the external catalog/engine toolchain.

Poor file sizing, too many small files, high snapshot churn, excessive position-delete files, or delayed metadata refresh can affect performance independently of the SQL text. External engines may have different capabilities and cost behavior than Snowflake.

## 4. Comparison By Access Pattern

| Workload | Native Snowflake table | External table | Iceberg table |
| --- | --- | --- | --- |
| Repeated Snowflake joins and curated BI | Usually the simplest default; inspect native pruning and compute | Can incur repeated external reads and file-metadata dependency | Viable, but adds table/catalog and storage lifecycle considerations |
| Rapid discovery of new partner files | Requires an ingestion step before queries see native rows | Strong fit for quick read-only exposure when refresh is reliable | Often more table machinery than discovery alone needs |
| Snowflake plus another engine need one table state | Native table is not itself an open Iceberg contract | Files may be read elsewhere, but external-table metadata is not the shared Iceberg table state | Strong fit when a real shared table contract and one clear catalog owner exist |
| Low-latency updates and mutations | Native DML and warehouse operations | Read-only; not a mutation target | Behavior depends on catalog, specification version, write support, and maintenance |
| Recovery and retention | Snowflake table lifecycle controls apply by table type/configuration | External storage lifecycle and file versioning are outside the table object | Depends on catalog ownership, storage mode, snapshots, retention, and supported recovery features |

## 5. Choosing An Ingestion Boundary

A common platform pattern is:

```text
Object storage files
    -> external table for discovery and validation
    -> COPY INTO / transformation into native raw and curated tables
    -> optional Iceberg publish when another engine needs the same table contract
```

This is not a mandatory three-layer design. Use it when each boundary solves a real need. For a stable high-value Snowflake-only serving dataset, going directly to native tables may be simpler. For an existing Spark-owned Iceberg catalog, register or connect Snowflake to that authority instead of publishing a competing one.

## 6. Table-Level Performance Review

Before adding an optimization feature, write down:

- query pattern and frequency
- table size, growth, and mutation rate
- selectivity and expected result size
- file sizes, row groups, and partition distribution where applicable
- current partitions/files scanned and bytes scanned
- freshness target and metadata refresh behavior
- ongoing compute, storage, catalog, and cloud egress costs
- which team owns maintenance and incident response

Use representative Query Profile evidence to choose a change. Do not select clustering, a materialized view, Search Optimization, or Iceberg from table size alone.

## Official References

- [Micro-partitions and clustering](https://docs.snowflake.com/en/user-guide/tables-clustering-micropartitions)
- [External tables](https://docs.snowflake.com/en/user-guide/tables-external-intro)
- [Iceberg tables](https://docs.snowflake.com/en/user-guide/tables-iceberg)
