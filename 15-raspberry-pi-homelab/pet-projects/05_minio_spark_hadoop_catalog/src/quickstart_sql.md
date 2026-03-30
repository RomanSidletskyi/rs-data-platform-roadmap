# Quickstart SQL

## Goal

Create one working Iceberg table in MinIO through Spark using HadoopCatalog.

## Step 1

Start the stack:

```bash
docker compose --env-file ../config/.env.local -f docker/docker-compose.yml up -d
```

## Step 2

Open a shell in Spark container:

```bash
docker compose --env-file ../config/.env.local -f docker/docker-compose.yml exec spark bash
```

## Step 3

Start Spark SQL:

```bash
spark-sql
```

## Step 4

Run SQL:

```sql
CREATE NAMESPACE IF NOT EXISTS lab.db;

CREATE TABLE IF NOT EXISTS lab.db.events (
  event_id BIGINT,
  event_type STRING,
  event_ts TIMESTAMP
)
USING iceberg
PARTITIONED BY (days(event_ts));

INSERT INTO lab.db.events VALUES
  (1, 'page_view', TIMESTAMP '2026-03-27 09:00:00'),
  (2, 'checkout', TIMESTAMP '2026-03-27 09:05:00');

SELECT * FROM lab.db.events;
```

## Step 5

Validate in MinIO UI that the bucket contains:

- metadata files
- manifest files
- parquet data files

## Important Note

This project is intentionally simpler, but that simplicity comes from dropping the separate control plane.