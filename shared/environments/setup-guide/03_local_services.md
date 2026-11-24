# 3. Local Services

Everything here runs on your laptop for free. Ready Compose files live in [shared/docker/local-stacks](../../docker/local-stacks/); other tools use their official quickstarts.

## Port Map

Stacks are designed to run together unless marked otherwise.

| Port (127.0.0.1) | Service | Stack |
| --- | --- | --- |
| 5432 | PostgreSQL | A |
| 3306 | MySQL | A |
| 27017 | MongoDB | A |
| 8082 | Adminer (database web UI) | A |
| 9092 | Kafka broker | B |
| 8085 | Kafka UI | B |
| 10000, 10001, 10002 | Azurite blob, queue, table | C |
| 4040 | Spark UI (while a session runs) | Spark |
| 8080 | Airflow UI | Airflow |
| 8081 | Flink UI | Flink |
| 8090 | Trino | Trino |
| 8888 | Jupyter in the Iceberg quickstart | Iceberg (conflicts with Airflow and Azurite; run alone) |

## Common Commands

```bash
cd shared/docker/local-stacks/<stack>
docker compose up -d                 # start in background
docker compose ps                    # status and health
docker compose logs -f <service>     # follow logs
docker compose stop                  # pause, keep data
docker compose down                  # remove containers, keep named volumes
docker compose down -v               # remove containers and data
```

---

## Stack A: Databases

PostgreSQL 16, MySQL 8.4, MongoDB 7, and Adminer. Used by `02-sql`, `01-python`, pet projects, and as dbt practice targets.

1. **Configure:** create `shared/docker/local-stacks/databases/.env` (ignored by Git) to override default passwords:

   ```bash
   POSTGRES_PASSWORD=<choose one>
   MYSQL_ROOT_PASSWORD=<choose one>
   MYSQL_PASSWORD=<choose one>
   MONGO_PASSWORD=<choose one>
   ```

2. **Start:** `docker compose up -d` (or only one service: `docker compose up -d postgres`).
3. **Verify:**

   ```bash
   docker compose ps                                        # postgres and mysql healthy
   docker compose exec postgres psql -U dev -d practice -c "select version();"
   docker compose exec mysql mysql -udev -p practice -e "select version();"
   docker compose exec mongodb mongosh -u dev -p --eval "db.runCommand({ping:1})"
   ```

4. **Browse:** Adminer at <http://127.0.0.1:8082>; server `postgres` or `mysql` (container names), user `dev`.
5. **From Python:** `postgresql://dev:<password>@localhost:5432/practice`.

Make sure an env file in `shared/` is covered by `.gitignore` before writing passwords into it (`git check-ignore -v <file>` prints the matching rule).

---

## Stack B: Kafka

Single-node Apache Kafka in KRaft mode plus Kafka UI. Used by `05-confluent-kafka`, P14, P15.

1. **Start:** `cd shared/docker/local-stacks/kafka && docker compose up -d`
2. **Verify from the host:**

   ```bash
   kcat -b localhost:9092 -L
   echo '{"event":"hello"}' | kcat -b localhost:9092 -t demo -P
   kcat -b localhost:9092 -t demo -C -o beginning -e
   ```

3. **Verify inside the broker:**

   ```bash
   docker compose exec kafka /opt/kafka/bin/kafka-topics.sh --bootstrap-server kafka:19092 --list
   ```

4. **Browse:** Kafka UI at <http://127.0.0.1:8085>.

Two addresses, one broker: other containers connect to `kafka:19092`, programs on your Mac to `localhost:9092`. Mixing them up is the most common local Kafka error.

---

## Stack C: Azurite (Azure Storage Emulator)

Microsoft's emulator for Blob, Queue, and Table storage. Used by `09-azure-data-lake-storage` and for offline producer tests.

1. **Start:** `cd shared/docker/local-stacks/azurite && docker compose up -d`
2. **Verify:**

   ```bash
   az storage container create --name landing --connection-string "UseDevelopmentStorage=true"
   az storage container list --connection-string "UseDevelopmentStorage=true" -o table
   ```

3. **From Python:** `BlobServiceClient.from_connection_string("UseDevelopmentStorage=true")`.

Limits: no Event Grid, no Data Lake (hierarchical namespace) API, no Snowflake access. Use it to test producers and storage code, then switch to a real storage account for the pipeline.

---

## DuckDB

A free in-process analytical database: ideal for quick SQL on CSV, JSON, and Parquet files, including files from the end-to-end projects.

```bash
brew install duckdb
duckdb -c "SELECT count(*) FROM read_json_auto('landing_local/wiki/**/*.ndjson.gz')"
```

---

## Spark and Delta Lake

Local mode: Spark runs inside one Python process; no cluster needed. Requires Java 17.

```bash
mkdir -p ~/labs/spark && cd ~/labs/spark
python3.12 -m venv .venv && source .venv/bin/activate
pip install "pyspark==3.5.*" "delta-spark==3.2.*"
```

```python
from delta import configure_spark_with_delta_pip
from pyspark.sql import SparkSession

builder = (
    SparkSession.builder.appName("local-lab").master("local[*]")
    .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension")
    .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog")
)
spark = configure_spark_with_delta_pip(builder).getOrCreate()
spark.range(5).write.format("delta").mode("overwrite").save("/tmp/delta/demo")
spark.read.format("delta").load("/tmp/delta/demo").show()
```

- **Verify:** the table prints; Spark UI at <http://127.0.0.1:4040> while the session is open.
- **Version rule:** Delta Lake releases pair with specific Spark versions; keep the pair from the Delta release notes.

---

## Airflow

Two options.

**Full local deployment with the official Compose file** (closest to production):

```bash
mkdir -p ~/labs/airflow && cd ~/labs/airflow
curl -LfO "https://airflow.apache.org/docs/apache-airflow/stable/docker-compose.yaml"
mkdir -p ./dags ./logs ./plugins ./config
echo "AIRFLOW_UID=$(id -u)" > .env
docker compose up airflow-init
docker compose up -d
```

- **Verify:** UI at <http://127.0.0.1:8080>; the default credentials are printed in the official guide for the version you downloaded.
- **Needs:** at least 4 GB, preferably 8 GB of Docker memory.

**Lightweight single process** (fast for learning DAG syntax): install Airflow into a venv with the official constraints file for your Python version, then run `airflow standalone`. Follow the "Quick Start" page of the Airflow documentation for the exact constraint URL.

A Raspberry Pi variant with MinIO and Postgres exists in [shared/docker/compose/raspberry-pi/airflow-minio-postgres](../../docker/compose/raspberry-pi/airflow-minio-postgres/README.md).

---

## Flink

```bash
brew install apache-flink
FLINK_HOME="$(brew --prefix apache-flink)/libexec"
"$FLINK_HOME/bin/start-cluster.sh"
"$FLINK_HOME/bin/sql-client.sh"          # interactive Flink SQL
"$FLINK_HOME/bin/stop-cluster.sh"
```

- **Verify:** UI at <http://127.0.0.1:8081>; in the SQL client, `SELECT 1;` returns a row.
- **Kafka source:** add the Kafka SQL connector JAR that matches your Flink version to `$FLINK_HOME/lib`, then restart the cluster.

---

## Iceberg and Trino

**Iceberg:** use the official Spark quickstart from the Apache Iceberg documentation ("Spark Quickstart"). It provides a Compose file with Spark, a REST catalog, S3-compatible storage, and Jupyter notebooks. Copy that file into `~/labs/iceberg`, run `docker compose up -d`, and open the notebook URL it prints. Run it alone: it uses ports that other stacks also use.

**Trino** (query engine for Iceberg, Postgres, and more):

```bash
docker run -d --name trino -p 127.0.0.1:8090:8080 trinodb/trino
docker exec -it trino trino --execute "SELECT 1"
docker rm -f trino
```

---

## Troubleshooting

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| `port is already allocated` | Another stack or local service uses the port | `lsof -iTCP:<port> -sTCP:LISTEN`; stop it or change the host port |
| Container restarts in a loop | Not enough Docker memory | Raise memory in Docker Desktop or `colima start --memory 8` |
| `exec format error` | amd64-only image on Apple Silicon | Add `platform: linux/amd64` to the service |
| Client cannot reach Kafka | Wrong listener address | Host: `localhost:9092`; containers: `kafka:19092` |
| Old data after restart | Named volume kept | `docker compose down -v` |
