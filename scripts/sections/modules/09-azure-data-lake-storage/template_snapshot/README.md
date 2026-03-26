# Azure Data Lake Storage

## What This Module Is About

This module is about Azure Data Lake Storage Gen2 as a production storage layer for analytics and data platform work.

It is not only about creating a storage account or uploading files.

It is about understanding how storage layout, security boundaries, naming rules, lifecycle decisions, and access patterns shape the whole data platform.

## Why This Module Matters

ADLS is often treated as a simple bucket for files.

That is too shallow.

In practice, storage decisions affect:

- ingestion reliability
- replay and backfill safety
- governance boundaries
- interoperability with Spark, Databricks, Synapse, dbt, and BI tools
- cost, performance, and operational risk

A weak storage design creates platform debt long before SQL or compute code becomes the visible problem.

## Module Outcome

By the end of this module, the learner should be able to:

- explain what ADLS Gen2 is and why hierarchical namespace matters
- design containers and folder paths intentionally instead of ad hoc
- reason about security with Entra ID, RBAC, and ACLs
- choose ingestion and serving access patterns deliberately
- recognize common ADLS anti-patterns early
- place ADLS correctly inside a broader Azure data platform architecture

## Module Parts

- `learning-materials/`
- `simple-tasks/`
- `pet-projects/`

Start with `learning-materials`.
