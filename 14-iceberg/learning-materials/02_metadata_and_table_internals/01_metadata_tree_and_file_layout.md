# Metadata Tree And File Layout

## 1. Why Metadata Is The Heart Of Iceberg

The most important thing to understand about Iceberg is this:

- the table is not defined by folders
- the table is defined by metadata

Object storage holds the bytes, but metadata defines the table state.

## 2. High-Level Metadata Structure

A simplified Iceberg table has:

- data files
- manifest files
- a manifest list
- a metadata JSON file for each table version
- a catalog entry pointing to the current metadata file

Mental model:

1. catalog points to current metadata JSON
2. metadata JSON points to current snapshot
3. snapshot points to a manifest list
4. manifest list points to manifest files
5. manifest files point to data and delete files

That chain is the real table structure.

## 3. What Usually Lives In The Metadata JSON

The current metadata JSON is one of the most important files in the whole system.

Conceptually it carries information such as:

- table UUID
- current schema ID
- list of schemas and field IDs
- current partition spec ID
- list of partition specs
- current sort order ID
- list of sort orders
- current snapshot ID
- snapshot history
- metadata-log entries for older metadata roots
- table properties
- metadata location references used by engines and catalogs

That is why reading only data files tells you almost nothing about real table state.

## 4. Why Field IDs Matter More Than Names

Iceberg tracks schema fields by IDs, not only names.

This is a deep design choice.

Why it matters:

- renames become safer
- readers do not rely only on column order
- schema evolution has a more stable identity model

Without field IDs, schema evolution in multi-engine file systems becomes much more fragile.

## 5. Why Partition Spec Is Metadata, Not Path Convention

In weak data lakes, partitioning is often only a folder naming habit.

In Iceberg, partition logic is table metadata.

That means the engine can reason about partitioning through the spec itself rather than through ad hoc path parsing.

This is what makes partition evolution possible without forcing the entire table into one permanent directory convention.

## 6. Typical Storage Layout

Many Iceberg tables have a structure conceptually like:

```text
table_root/
  data/
    ... parquet files ...
  metadata/
    v1.metadata.json
    v2.metadata.json
    snap-12345.avro
    snap-12346.avro
    manifest-aaa.avro
    manifest-bbb.avro
```

The exact names vary by engine, but the layered pattern is the key idea.

It is useful to think about the metadata directory as containing three broad classes of files:

- table-version roots such as `vN.metadata.json`
- snapshot-level indexing artifacts such as manifest lists
- file-level indexing artifacts such as manifests

The data directory then holds the actual parquet or other supported data files plus possible delete files.

## 7. How Readers Reach Actual Data Files

Readers do not jump straight from table name to parquet files.

They usually follow a layered resolution path:

1. table name is resolved through a catalog
2. catalog returns current metadata location
3. metadata location identifies current snapshot
4. snapshot identifies manifest list
5. manifest list identifies manifests
6. manifests identify concrete files with stats and partition data
7. engine selects the final scan set

This is one reason Iceberg can be much smarter than path-based directory scans.

## 8. Why This Structure Matters

This structure gives Iceberg important properties:

- readers can identify current state without listing all data files
- multiple snapshots can coexist safely
- planning can prune files before data scan starts
- history can be preserved without copying entire tables

It also separates responsibilities cleanly:

- storage stores files
- metadata defines validity
- catalog defines discoverability of current state

## 9. Why Folder Scans Are Not The Source Of Truth

In weak lake designs, engines discover data by listing directories.

Iceberg is different.

The correct file set is determined from metadata.

That is why orphan files can exist:

- files may be present in storage but not belong to the current snapshot

Architectural consequence:

- storage presence alone does not define table correctness
- metadata correctness defines table correctness

## 10. Architect Summary

If you understand only folders, you do not yet understand Iceberg.

If you understand:

- metadata roots
- snapshot chains
- manifest hierarchy
- field IDs and specs
- catalog pointer semantics

then you are finally reasoning about the real table.