# Pet Project 05 - MinIO Spark Hadoop Catalog

## Goal

Build the smallest practical Raspberry Pi lab where Spark creates Iceberg tables in MinIO without Nessie.

## Why This Project Exists

The previous project is more realistic architecturally because it separates storage from a proper control plane.

This project exists because sometimes you need the shortest path from zero to working Iceberg artifacts.

## What You Learn

- MinIO as S3-compatible storage for Iceberg
- Spark catalog configuration with `type=hadoop`
- how Iceberg still works without a separate catalog service
- what you lose when you skip Nessie

## Scope

- one MinIO service
- one Spark service
- one warehouse bucket
- one `spark-sql` validation flow

## Project Files

- `architecture.md`
- `requirements.md`
- `docker/docker-compose.yml`
- `config/.env.example`
- `config/spark-defaults.conf.template`
- `src/quickstart_sql.md`
- `tests/validation_checklist.md`

## When To Use This Variant

Use this first when:

- your Raspberry Pi is resource-constrained
- you want fewer moving parts
- you want to see raw Iceberg metadata appear in object storage fast
- you do not need Git-like branches or control-plane experiments yet

## Limits

- no separate catalog service
- no Nessie branches or tags
- weaker learning around governance and collaborative control plane
- object-store plus file-based catalog patterns are less robust than a dedicated catalog service

## Suggested Workflow

1. review `architecture.md`
2. review `requirements.md`
3. copy `config/.env.example` into an uncommitted local env file
4. start the stack
5. run `spark-sql`
6. execute the SQL in `src/quickstart_sql.md`
7. verify metadata and data artifacts in MinIO