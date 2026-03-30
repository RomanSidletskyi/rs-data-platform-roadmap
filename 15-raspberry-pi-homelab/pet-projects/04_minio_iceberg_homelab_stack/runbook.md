# Runbook

## Goal

Bring the stack up on Raspberry Pi with the fewest surprises possible.

## Step 1. Prepare local env

Create an uncommitted env file:

```bash
cp config/.env.local.example config/.env.local
```

If your Pi already uses MinIO credentials elsewhere, replace the defaults.

## Step 2. Start the stack

```bash
docker compose --env-file config/.env.local -f docker/docker-compose.yml up -d
```

## Step 3. Check service health

```bash
docker compose --env-file config/.env.local -f docker/docker-compose.yml ps
```

Expected shape:

- `minio` is running
- `nessie` is running
- `spark` is running
- `minio-init` has exited successfully

## Step 4. Enter Spark container

```bash
docker compose --env-file config/.env.local -f docker/docker-compose.yml exec spark bash
```

## Step 5. Start Spark SQL

```bash
spark-sql
```

First cold start can be slow because Spark resolves Maven packages.

## Step 6. Run the SQL quickstart

Execute the statements from `src/quickstart_sql.md`.

## Step 7. Validate object storage

In MinIO Console, confirm the bucket contains:

- `metadata/` files
- manifest artifacts
- data files

If you only see data files and no metadata artifacts, the write path is wrong.

## Step 8. Validate catalog behavior

Inside `spark-sql`, confirm:

```sql
SHOW REFERENCE IN lab;
LIST REFERENCES IN lab;
```

If those fail, you do not have a working Nessie control plane.

## Failure Patterns

### `ClassNotFoundException`

Usually means the package line is wrong for Spark or Scala.

Recheck the pinned versions in `config/spark-defaults.conf.template`.

### `Connection refused` to MinIO or Nessie

Usually means the compose network is up but one service is not healthy yet.

Wait a bit and retry.

### Slow or stalled cold start on Pi

This can be normal during the first package resolution.

If it is too heavy for your device, use the simpler `05_minio_spark_hadoop_catalog` project first.