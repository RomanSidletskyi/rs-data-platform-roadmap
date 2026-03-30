# Quickstart SQL

## Goal

Use Spark to create and query one real Iceberg table through Nessie with data stored in MinIO.

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

Launch `spark-sql`.

The package coordinates are already pinned in `spark-defaults.conf.template`.

On the first run, Spark may download dependencies for a while.

Use:

```bash
spark-sql
```

## Step 4

Run SQL:

```sql
CREATE NAMESPACE IF NOT EXISTS lab.db;

SHOW CURRENT NAMESPACE;

LIST REFERENCES IN lab;

SHOW REFERENCE IN lab;

CREATE TABLE IF NOT EXISTS lab.db.orders (
  order_id BIGINT,
  customer_id BIGINT,
  order_ts TIMESTAMP,
  amount DECIMAL(18,2)
)
USING iceberg
PARTITIONED BY (days(order_ts));

INSERT INTO lab.db.orders VALUES
  (1, 101, TIMESTAMP '2026-03-27 10:00:00', 25.50),
  (2, 102, TIMESTAMP '2026-03-27 11:00:00', 40.00);

SELECT * FROM lab.db.orders;

CREATE BRANCH IF NOT EXISTS dev IN lab;

LIST REFERENCES IN lab;
```

## Step 5

Validate in MinIO UI that warehouse objects exist.

You should see:

- metadata root files
- manifest files
- parquet data files

## Step 6

Validate in Nessie terms that the catalog is active, not bypassed:

- `SHOW REFERENCE IN lab` returns `main`
- `LIST REFERENCES IN lab` shows at least `main` and `dev`
- the table resolves as `lab.db.orders`, not as a direct path read

## Important Note

This project is still a homelab, not a benchmark stack.

If the first package download is too heavy for your Pi, start with the simpler `05_minio_spark_hadoop_catalog` project and come back to this one later.