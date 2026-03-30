# How Commits Rebuild Metadata

## 1. The Wrong Mental Model

The wrong beginner mental model is:

- Spark writes parquet
- Iceberg somehow notices it

That is not how a real commit works.

Iceberg commit flow is explicit metadata construction.

The engine does not just drop files into a folder. It builds a new valid table state.

## 2. The Right Mental Model

For a successful write, the engine usually does all of this:

1. reads current table metadata
2. plans the change against a base snapshot
3. writes new data files or delete files
4. writes new manifests for those files
5. decides which existing manifests can be reused
6. writes a new manifest list for the new snapshot
7. writes a new metadata JSON root
8. asks the catalog to publish that new metadata root atomically or near-atomically according to the catalog implementation

That is the real commit path.

## 3. Why Metadata Is Rebuilt In Layers

Iceberg uses immutable metadata artifacts.

That means once a manifest or metadata JSON file is written, it is not edited in place.

Instead, a newer table state is described by writing newer metadata files that reference the correct mix of:

- reused old artifacts
- brand new artifacts

This is crucial for:

- snapshot isolation
- commit retries
- time travel
- concurrent writers

## 4. Append Commit Example

For a simple append job, the rebuild is often relatively small.

Typical shape:

1. writer reads current metadata root `v120.metadata.json`
2. writer creates new data files
3. writer writes a new manifest describing those files
4. writer writes a new manifest list that contains:
   - reused manifests from prior snapshot
   - the new manifest for the appended files
5. writer writes `v121.metadata.json`
6. catalog pointer is updated from `v120` to `v121`

Notice what did not happen:

- old parquet files were not rewritten
- all old manifests were not rewritten
- the whole table was not rescanned and reconstructed

## 5. Concrete File-By-File Example Of A New Commit

Assume the table root is:

```text
s3://company-lakehouse/warehouse/analytics.db/orders/
```

Before the new append, the current catalog pointer references:

```text
s3://company-lakehouse/warehouse/analytics.db/orders/metadata/000120-7f5c.metadata.json
```

Now a new Spark append job writes one new parquet file.

### Step 1. New Data File Is Written

```text
s3://company-lakehouse/warehouse/analytics.db/orders/data/2026/03/27/00000-35-1e8d.parquet
```

That file contains rows, but it is not yet the authoritative table state by itself.

### Step 2. A New Manifest File Is Written

Representative path:

```text
s3://company-lakehouse/warehouse/analytics.db/orders/metadata/manifest-8d12a3.avro
```

Conceptually that manifest contains an entry like:

```json
{
      "status": 1,
      "snapshot_id": 918273645546372820,
      "sequence_number": 121,
      "file_sequence_number": 121,
      "data_file": {
            "content": 0,
            "file_path": "s3://company-lakehouse/warehouse/analytics.db/orders/data/2026/03/27/00000-35-1e8d.parquet",
            "file_format": "PARQUET",
            "record_count": 125000,
            "file_size_in_bytes": 268435456,
            "partition": {
                  "order_day": "2026-03-27",
                  "status": "paid"
            }
      }
}
```

This is where the new data file first becomes part of structured Iceberg metadata.

### Step 3. A New Manifest List Is Written

Representative path:

```text
s3://company-lakehouse/warehouse/analytics.db/orders/metadata/snap-918273645546372820-1-9c77.avro
```

Conceptually this manifest list references:

- older reused manifests from snapshot 120
- new manifest `manifest-8d12a3.avro`

Representative entry for the new manifest:

```json
{
      "manifest_path": "s3://company-lakehouse/warehouse/analytics.db/orders/metadata/manifest-8d12a3.avro",
      "manifest_length": 48192,
      "partition_spec_id": 0,
      "content": 0,
      "sequence_number": 121,
      "min_sequence_number": 121,
      "added_snapshot_id": 918273645546372820,
      "added_files_count": 1,
      "existing_files_count": 0,
      "deleted_files_count": 0,
      "added_rows_count": 125000,
      "existing_rows_count": 0,
      "deleted_rows_count": 0
}
```

At this layer, Iceberg is indexing the manifest itself, not the data file directly.

### Step 4. A New Metadata JSON Root Is Written

Representative path:

```text
s3://company-lakehouse/warehouse/analytics.db/orders/metadata/000121-a9b4.metadata.json
```

Conceptually the new metadata root includes a snapshot entry like:

```json
{
      "snapshot-id": 918273645546372820,
      "parent-snapshot-id": 918273645546372819,
      "sequence-number": 121,
      "timestamp-ms": 1774605600000,
      "manifest-list": "s3://company-lakehouse/warehouse/analytics.db/orders/metadata/snap-918273645546372820-1-9c77.avro",
      "summary": {
            "operation": "append",
            "added-data-files": "1",
            "added-records": "125000"
      }
}
```

This file is now the root description of the newest valid table state.

### Step 5. The Catalog Pointer Is Updated

Only now does the catalog point the table to the new metadata root.

Conceptually, the catalog mapping becomes:

```text
catalog table: analytics.orders
current metadata location:
s3://company-lakehouse/warehouse/analytics.db/orders/metadata/000121-a9b4.metadata.json
```

In a service catalog such as Glue, this means the table entry or versioned table metadata now references the newest metadata location.

So the end-to-end chain is:

```text
catalog entry
      -> 000121-a9b4.metadata.json
                  -> snapshot 918273645546372820
                              -> snap-918273645546372820-1-9c77.avro
                                          -> manifest-8d12a3.avro
                                                      -> 00000-35-1e8d.parquet
```

That is the exact mental model you want to keep.

## 6. Why Manifest List Is Rewritten Every Snapshot

Each new snapshot has its own manifest list because the snapshot's set of manifests is part of the snapshot definition.

Even when many manifests are reused, the manifest list still has to be rewritten to define the new snapshot.

This is one of the most important details learners often miss.

## 7. Why Existing Manifests Are Often Reused

Manifest reuse is a scaling feature.

If each commit rewrote every manifest in a large table, metadata cost would explode.

Instead, Iceberg tries to reuse immutable manifests where possible and only add or replace the metadata layers that must change.

## 8. How Sequence Numbers Help Retries

In newer Iceberg semantics, sequence-related information allows commit retries to avoid rewriting every lower metadata artifact.

A useful practical idea is:

- commit retry should be as cheap as correctness allows

That is one reason the spec allows certain values to be inherited through higher metadata layers.

## 9. Overwrite Commit Is Harder Than Append

An overwrite or rewrite commit is more complex because it may:

- add new files
- mark old files as deleted from the snapshot state
- produce both added and deleted manifest entries
- validate that no conflicting concurrent write invalidated the write scope

So overwrite jobs are not “append plus delete.”

They require stronger validation logic.

## 10. Mutation Commits With Delete Files

For mutation-aware flows, a commit may produce:

- new data files
- new delete files
- new manifests for those artifacts
- a new manifest list with data and delete manifest references

This makes planning and commit behavior richer, but also more complex.

That complexity is one reason workload shape must influence table design.

## 11. Where The Catalog Path Fits Architecturally

The catalog does not usually store the full data-file inventory itself.

It stores the pointer to the authoritative metadata root for the table.

That is a crucial distinction.

The catalog answers:

- where is the current metadata root

The metadata root and its descendants answer:

- which snapshot is current
- which manifests define that snapshot
- which files define those manifests

So when someone asks where the table “is,” the architect answer is:

- in storage as data and metadata files
- in the catalog as the pointer to the current metadata root

## 12. Commit Conflict Example

Imagine two writers start from the same base snapshot.

Writer A:

- reads snapshot 100
- prepares new metadata

Writer B:

- also reads snapshot 100
- prepares new metadata

If writer A commits first, the table is now at snapshot 101.

Writer B cannot blindly publish metadata based on the stale assumption that snapshot 100 is still current.

So writer B must:

- refresh table metadata
- detect whether the new table state conflicts with its intended operation
- retry if safe
- fail if unsafe

That is optimistic concurrency in practice.

## 13. Commit Flow Diagram

```text
base metadata.json
      |
      v
read current snapshot
      |
      v
write new data/delete files
      |
      v
write new manifest(s)
      |
      v
reuse old manifest(s) where valid
      |
      v
write new manifest list
      |
      v
write new metadata.json
      |
      v
publish new metadata pointer through catalog
```

## 14. What Actually Gets "Rebuilt"

The correct answer is:

- not the whole table
- not every lower-level file
- but the metadata path to the new snapshot

Usually, every commit rebuilds at least:

- snapshot state
- manifest list
- metadata root

Sometimes it also creates new manifests.

It does not necessarily rewrite all existing manifests or data files.

## 15. Why Cleanup Must Be Separate

Because old metadata and data artifacts may still belong to active or retained snapshots, physical deletion cannot be coupled naively to logical replacement.

That is why cleanup is usually governed by snapshot expiration and orphan-file handling rather than immediate blind deletes.

## 16. Operational Consequence

If a team says:

- we only write parquet files to S3 and Glue will see them

then they are not operating Iceberg correctly.

Iceberg correctness depends on publishing a coherent metadata chain, not on storage presence alone.

## 17. Architect Rule

Every write creates a new authoritative metadata path.

If you teach commits only as file writes, you are teaching the wrong system.