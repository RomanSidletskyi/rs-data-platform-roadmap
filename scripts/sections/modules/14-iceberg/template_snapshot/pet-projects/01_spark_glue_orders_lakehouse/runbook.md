# Runbook

## Goal

Run an optional local lab for this project so you can validate Iceberg table creation, inserts, and metadata layout before thinking about full AWS deployment details.

## Important Scope Note

The target architecture remains Glue-backed on AWS.

This runbook uses a local approximation:

- MinIO instead of S3
- Spark in Docker instead of managed Spark
- HadoopCatalog instead of Glue

That is enough to validate core Iceberg table behavior, namespace structure, and storage outcomes.

## Step 1. Prepare local env

Create an uncommitted env file:

```bash
cp config/.env.local.example config/.env.local
```

## Step 2. Start the local lab

```bash
docker compose --env-file config/.env.local -f docker/docker-compose.yml up -d
```

## Step 3. Check service state

```bash
docker compose --env-file config/.env.local -f docker/docker-compose.yml ps
```

Expected shape:

- `orders-lakehouse-minio` is running
- `orders-lakehouse-spark` is running
- `orders-lakehouse-minio-init` has exited successfully

## Step 4. Open a shell in Spark container

```bash
docker compose --env-file config/.env.local -f docker/docker-compose.yml exec spark bash
```

## Step 5. Start Spark SQL

```bash
spark-sql
```

The local Spark config already mounts `config/spark-defaults.local.conf.template` as `spark-defaults.conf`.

## Step 6. Run the local quickstart SQL

Inside the Spark container, use:

```bash
spark-sql -f src/local_lab_quickstart.sql
```

## Step 7. Inspect MinIO

Open the MinIO console and verify that the `iceberg-warehouse` bucket contains:

- Iceberg metadata files
- manifest files
- parquet data files

## Step 8. Compare local output with target architecture

After the local lab works, compare what you saw with:

- `architecture.md`
- `requirements.md`
- `contract.md`

The point is to understand what carries over cleanly from local Iceberg behavior and what is specific to Glue as a control plane.