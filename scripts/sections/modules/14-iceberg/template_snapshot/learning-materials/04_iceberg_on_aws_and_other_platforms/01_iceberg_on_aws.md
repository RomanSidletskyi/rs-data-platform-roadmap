# Iceberg On AWS

## 1. Why AWS Is A Common Iceberg Home

AWS is one of the most common environments for Iceberg because the pieces line up naturally:

- S3 as durable object storage
- Glue as a metadata authority
- Athena for serverless SQL reads
- EMR or Spark for heavy compute
- optionally Trino, Flink, or other engines on top

## 2. Typical AWS Architecture

A common design looks like:

```text
Spark / EMR / Glue jobs
        |
        v
      S3 data + metadata files
        |
        v
      Glue catalog
        |
        +--> Athena reads
        +--> Spark reads/writes
        +--> Trino or other engines
```

The key point is that S3 stores data and metadata files, but Glue often acts as the official catalog entrypoint.

In many real systems, the roles look like this:

- S3 = durable object storage for data and metadata
- Glue = table discovery and metadata authority
- Spark on EMR or Glue jobs = heavy writer and transformer
- Athena = cheap serverless SQL reader for selected use cases
- Trino or other engines = optional read or federated compute layer

## 3. Why S3 Changes Table Design

S3 is durable and scalable, but it is still object storage, not a local filesystem.

That means table design must care about:

- file count
- metadata size
- listing behavior
- commit and cleanup discipline

Iceberg helps because it avoids folder-scan-as-truth thinking.

But teams still need to care about:

- write amplification from too many tiny batches
- lifecycle policies that accidentally conflict with metadata history
- cross-account access patterns
- cost of repeated planning and file access at scale

## 4. Glue As Catalog

Glue is common because it fits AWS-native tooling.

It works well when the organization is already AWS-centered.

But teams still need to think about:

- ownership
- permissions
- multi-engine expectations
- maintenance responsibility

Glue is often the easiest default on AWS, but not automatically the best long-term control plane if the platform wants richer catalog-layer governance or non-AWS-centered architecture.

## 5. Athena And Spark Roles

Athena is usually read-oriented in analytical patterns.

Spark is often the heavier write and maintenance engine.

This division matters because not every engine has identical support for every Iceberg operation.

Typical practical split:

- Spark does most writes, compaction, schema evolution, and heavy transforms
- Athena does lightweight analytical reading where supported and cost-effective

That split is healthy when teams do not force every engine to be everything.

## 6. Architect Rule For AWS

Do not design “Iceberg on AWS” as only “S3 + Glue.”

Design it as:

- storage layer
- metadata layer
- compute/write layer
- read/consumer layer
- ownership layer

If any one of those is implicit, the AWS Iceberg design is incomplete.