# Pet Project 04 - MinIO Iceberg Homelab Stack

## Goal

Build a Raspberry Pi homelab stack where MinIO stores Iceberg data, Nessie provides the catalog control plane, and Spark creates and queries the tables.

## Why This Project Matters

This project turns Raspberry Pi from a generic Docker host into a small lakehouse lab.

It teaches:

- storage versus catalog separation
- Spark plus Iceberg configuration in a real container stack
- why MinIO alone is not a table format solution
- what a realistic low-cost Iceberg lab looks like

## Scope

- one MinIO service
- one Nessie service
- one Spark service container
- one demo warehouse bucket
- one documented SQL validation path

## Expected Outcome

You can create an Iceberg table backed by MinIO and cataloged by Nessie from a Spark container running in your homelab.

## Project Files

- `architecture.md`
- `requirements.md`
- `docker/docker-compose.yml`
- `config/.env.example`
- `config/.env.local.example`
- `config/spark-defaults.conf.template`
- `runbook.md`
- `src/quickstart_sql.md`
- `tests/validation_checklist.md`

## Important Constraint

This project is for homelab learning.

It is not a production-hardened lakehouse stack.

## Suggested Workflow

1. review `architecture.md`
2. read `requirements.md` and keep the single-node homelab limitations in mind
3. copy `config/.env.local.example` into an uncommitted `config/.env.local`
4. start the compose stack
5. follow `runbook.md`
6. run the SQL in `src/quickstart_sql.md`
7. verify artifacts in MinIO and metadata state through Nessie-backed catalog resolution

## Version Baseline

This project pins the Spark package coordinates to a tested documentation baseline:

- Spark 3.5 line
- Scala 2.12 line
- Apache Iceberg `1.10.1`
- Nessie Spark extensions `0.104.5`

This matches the current Iceberg and Nessie documentation for Spark 3.5.

## What Is Pinned Versus Flexible

- Spark package coordinates are pinned in `config/spark-defaults.conf.template`
- Spark image tag is pinned to the Spark 3.5 line in `config/.env.example`
- Nessie image tag is pinned in `config/.env.example`
- MinIO image may still be replaced if your Raspberry Pi needs a different arm64-compatible release

## Homelab Reality Check

The first `spark-sql` start may spend time downloading Maven packages.

That is normal for this lab.

On a Raspberry Pi, cold starts are materially slower than on a laptop or cloud VM.