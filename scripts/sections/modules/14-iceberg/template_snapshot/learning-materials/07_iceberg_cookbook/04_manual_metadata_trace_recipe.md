# Manual Metadata Trace Recipe

## Goal

Trace one Iceberg commit manually from catalog pointer to metadata root to manifest list to manifest to data file.

This recipe matters because many learners understand Iceberg only through SQL.

Here the goal is to understand the actual metadata chain.

## Scenario

Assume the table is:

```text
glue_prod.analytics.orders
```

and a new append job has just committed.

## Step 1. Identify The Current Metadata Location

Conceptually the catalog answer looks like:

```text
catalog table: analytics.orders
current metadata location:
s3://company-lakehouse/warehouse/analytics.db/orders/metadata/000121-a9b4.metadata.json
```

## Step 2. Inspect The Metadata Root Mentally

Representative snapshot entry:

```json
{
  "snapshot-id": 918273645546372820,
  "parent-snapshot-id": 918273645546372819,
  "sequence-number": 121,
  "manifest-list": "s3://company-lakehouse/warehouse/analytics.db/orders/metadata/snap-918273645546372820-1-9c77.avro",
  "summary": {
    "operation": "append"
  }
}
```

## Step 3. Move To The Manifest List

Representative path:

```text
s3://company-lakehouse/warehouse/analytics.db/orders/metadata/snap-918273645546372820-1-9c77.avro
```

Representative manifest list entry:

```json
{
  "manifest_path": "s3://company-lakehouse/warehouse/analytics.db/orders/metadata/manifest-8d12a3.avro",
  "content": 0,
  "added_snapshot_id": 918273645546372820,
  "added_files_count": 1,
  "added_rows_count": 125000
}
```

## Step 4. Move To The Manifest And Data File

Representative manifest entry:

```json
{
  "status": 1,
  "snapshot_id": 918273645546372820,
  "data_file": {
    "file_path": "s3://company-lakehouse/warehouse/analytics.db/orders/data/2026/03/27/00000-35-1e8d.parquet",
    "file_format": "PARQUET",
    "record_count": 125000
  }
}
```

## Final Mental Chain

```text
catalog
  -> metadata.json
      -> snapshot
          -> manifest list
              -> manifest
                  -> data file
```

## Why This Recipe Matters

If you can do this trace manually, then you really understand:

- why Iceberg is metadata-defined
- where commit state actually lives
- how to debug unexpected reads or writes