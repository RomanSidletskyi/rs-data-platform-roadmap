# Reading Metadata JSON, Manifest List, And Manifest Fields

## 1. Why This File Exists

Many learners understand the hierarchy:

- metadata root
- manifest list
- manifest
- data file

but still do not understand what the important fields actually mean.

This chapter fixes that.

The goal is not to memorize every field from the spec.

The goal is to know which fields matter most when reading raw Iceberg metadata by hand.

## 2. Representative `metadata.json` Shape

Simplified example:

```json
{
  "format-version": 2,
  "table-uuid": "8c17c4f2-1d6d-4dc5-b7c8-90da11f4c000",
  "location": "s3://company-lakehouse/warehouse/analytics.db/orders",
  "last-sequence-number": 121,
  "last-updated-ms": 1774605600000,
  "last-column-id": 8,
  "current-schema-id": 0,
  "schemas": [
    {
      "schema-id": 0,
      "type": "struct",
      "fields": [
        {"id": 1, "name": "order_id", "required": true, "type": "long"},
        {"id": 2, "name": "customer_id", "required": false, "type": "string"}
      ]
    }
  ],
  "default-spec-id": 0,
  "partition-specs": [
    {
      "spec-id": 0,
      "fields": [
        {"name": "order_day", "transform": "day", "source-id": 3, "field-id": 1000}
      ]
    }
  ],
  "default-sort-order-id": 0,
  "sort-orders": [
    {"order-id": 0, "fields": []}
  ],
  "current-snapshot-id": 918273645546372820,
  "snapshots": [
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
      },
      "schema-id": 0
    }
  ],
  "snapshot-log": [
    {
      "snapshot-id": 918273645546372820,
      "timestamp-ms": 1774605600000
    }
  ],
  "metadata-log": [
    {
      "metadata-file": "s3://company-lakehouse/warehouse/analytics.db/orders/metadata/000120-7f5c.metadata.json",
      "timestamp-ms": 1774605500000
    }
  ],
  "properties": {
    "write.format.default": "parquet",
    "write.target-file-size-bytes": "536870912"
  }
}
```

## 3. The Most Important `metadata.json` Fields

### `format-version`

Tells you which table-format semantics are allowed.

This is one of the first fields to inspect because it immediately changes how you reason about mutations.

### `location`

This is the base table location.

It tells writers where table data and metadata belong conceptually.

### `last-sequence-number`

Especially important in `v2` thinking.

It represents the highest sequence assigned so far and is part of mutation-aware metadata reasoning.

### `schemas` And `current-schema-id`

These tell you:

- which schemas have existed
- which one is current

This is why renames and schema evolution are metadata problems, not folder problems.

### `partition-specs` And `default-spec-id`

These tell you:

- which partition specs have existed
- which one writers should currently use by default

### `snapshots` And `current-snapshot-id`

These define the current and historical table states.

If you need to know what the table is right now, this area matters most.

### `snapshot-log`

This gives the progression of snapshot state over time.

### `metadata-log`

This gives the chain of older metadata root files.

This matters for operational debugging and understanding how table roots advanced.

## 4. The Snapshot Entry Is One Of The Most Important Objects

Inside `metadata.json`, one snapshot entry usually answers:

- what snapshot ID is this
- what is its parent
- what sequence number it has
- where its manifest list lives
- what the operation was

If you understand the snapshot entry, you understand where to jump next in the metadata tree.

## 5. Representative Manifest List Entry

Simplified example:

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

## 6. The Most Important Manifest List Fields

### `manifest_path`

This is where the actual manifest file lives.

### `content`

This tells you whether the manifest tracks:

- data files
- delete files

That matters immediately for mutation-aware tables.

### `sequence_number` And `min_sequence_number`

These are part of the logic that helps the planner reason about applicability and relative age.

### File And Row Counts

Fields like:

- `added_files_count`
- `existing_files_count`
- `deleted_files_count`
- `added_rows_count`

help with planning and high-level interpretation of what changed.

## 7. Representative Manifest Entry

Simplified example:

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
    "partition": {
      "order_day": "2026-03-27",
      "status": "paid"
    },
    "record_count": 125000,
    "file_size_in_bytes": 268435456,
    "value_counts": {
      "1": 125000,
      "2": 125000
    },
    "null_value_counts": {
      "2": 0
    },
    "lower_bounds": {
      "1": "1001"
    },
    "upper_bounds": {
      "1": "999999"
    }
  }
}
```

## 8. The Most Important Manifest Entry Fields

### `status`

Usually interpreted as:

- existing
- added
- deleted

This tells you how the file participates in the snapshot lifecycle.

### `snapshot_id`

Tells you which snapshot added or deleted the file entry.

### `sequence_number`

Important especially in `v2` mutation-aware logic.

### `data_file.content`

This tells you whether the nested file is:

- a normal data file
- a position delete file
- an equality delete file

### `file_path`

This is the concrete object-store path to the file.

### `partition`

This is not a folder guess.

It is the partition tuple stored as metadata.

### `record_count`, `file_size_in_bytes`, `lower_bounds`, `upper_bounds`

These are critical planning fields.

They allow pruning before full data reads.

## 9. How To Read These Three Layers Together

The most useful reading sequence is:

1. open `metadata.json` to identify current snapshot and manifest list
2. open manifest list to see which manifests matter
3. open manifests to see which data or delete files matter

That is the practical debugging path.

## 10. What To Look For During Troubleshooting

If something looks wrong, inspect these questions in order:

1. Is the catalog pointing to the metadata root you expected?
2. Is the current snapshot the one you expected?
3. Does the manifest list contain the right data and delete manifests?
4. Do manifest entries point to the files you expected?
5. Are row counts and bounds plausible?

## 11. Why This Matters For Architects

At architect level, you do not need to memorize the full spec line by line.

But you do need to be able to look at a raw `metadata.json`, manifest list, and manifest entry and understand:

- what changed
- what is current
- what the planner will likely do
- where the failure or misunderstanding probably sits

## 12. Architect Rule

If you can read these three layers calmly, you are no longer treating Iceberg as magic.

You are treating it as an explicit metadata system.