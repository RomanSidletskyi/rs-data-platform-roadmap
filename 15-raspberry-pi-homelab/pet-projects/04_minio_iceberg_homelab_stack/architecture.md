# Architecture

## Target Shape

The stack is intentionally small:

1. `MinIO` for object storage
2. `Nessie` for catalog control plane
3. `Spark` for Iceberg table creation and reads

## Why This Shape Is Better Than MinIO Alone

MinIO stores objects, but it does not decide:

- which snapshot is current
- how a table is registered
- which branch or ref the table should resolve through

Nessie introduces the missing catalog layer.

Spark introduces the compute layer.

## Service Roles

MinIO:

- stores warehouse files
- stores metadata and data artifacts

Nessie:

- stores catalog state and references
- separates metadata control plane from object storage

Spark:

- creates tables
- writes data
- reads data
- runs maintenance-style procedures in future exercises

## Homelab Trade-Offs

Strengths:

- cheap
- transparent
- good for learning metadata and catalog behavior

Weaknesses:

- limited CPU and RAM
- weak fit for large merges and compaction
- not a strong concurrency environment