# Reference Example - ETL With Postgres Compose

This folder contains a ready implementation kept as a reference example.

Its purpose is:

- self-checking after attempting the guided project
- comparing implementation decisions
- preserving a working ETL plus database example for future project design

You should attempt the guided project first:

- `03-docker/pet-projects/02_etl_with_postgres_compose`

Only after that should you compare your implementation with this reference example.

---

# 02 ETL With Postgres Compose

## Project Goal

Build a small ETL workflow that runs with Docker Compose and loads data into Postgres.

## Scenario

You have a local CSV dataset with order records and want to load it into a relational target, then create at least one transformed analytics table. Docker Compose should model the full local system.

## Implemented Example

This reference implementation includes:

- a Python ETL application that reads the sample CSV source
- raw data loading into Postgres
- a transformed daily summary table in Postgres
- unit tests for validation and transformation logic
- Docker Compose with Postgres and the ETL application

## What This Project Should Demonstrate

- a small multi-service Compose setup
- Postgres as a stateful service with persistent volume
- ETL application configuration through environment variables
- app-to-database connectivity using service names
- clear separation between source data, code, and storage

## Project Structure

	reference_example_etl_with_postgres_compose/
		.dockerignore
		.env.example
		README.md
		architecture.md
		requirements.txt
		config/
			etl_config.json
		data/
			input/
				orders.csv
		docker/
			Dockerfile
			docker-compose.yml
		src/
			config_loader.py
			db.py
			main.py
			transformer.py
		tests/
			test_transformer.py

## Suggested Folder Roles

- `src/` for ETL code and SQL helpers
- `config/` for app config or env examples
- `data/` for sample source data
- `docker/` for compose and image files
- `tests/` for ETL and transformation checks

## Expected Deliverables

- Compose stack with app and Postgres
- sample dataset and load path
- one repeatable ETL run
- short validation instructions using SQL or logs

## How The Example Works

1. the ETL app reads `data/input/orders.csv`
2. it validates required fields from `config/etl_config.json`
3. it loads raw rows into `raw_orders`
4. it builds a daily summary from the raw data
5. it writes the transformed result into `daily_order_summary`

## How To Run Locally

Create or use a Python environment, then install dependencies:

```bash
python3 -m pip install -r requirements.txt
```

Run tests:

```bash
python3 -m unittest discover -s tests
```

To run the ETL locally against a Postgres instance:

```bash
export POSTGRES_DB=etl_lab
export POSTGRES_USER=etl_user
export POSTGRES_PASSWORD=etl_pass
export POSTGRES_HOST=localhost
export POSTGRES_PORT=5432
export INPUT_PATH=data/input/orders.csv
export CONFIG_PATH=config/etl_config.json

python3 src/main.py
```

## How To Run With Docker Compose

From the project root:

```bash
docker compose -f docker/docker-compose.yml up --build
```

To stop the stack while keeping database data:

```bash
docker compose -f docker/docker-compose.yml down
```

To remove the stack and the volume:

```bash
docker compose -f docker/docker-compose.yml down -v
```

## Validation Ideas

- start the stack successfully
- confirm database readiness
- run the ETL process
- verify loaded records in Postgres

Useful validation query:

```sql
SELECT order_date, order_count, total_amount
FROM daily_order_summary
ORDER BY order_date;
```

Expected summary rows:

- `2026-03-01` -> `2` rows -> `210.50`
- `2026-03-02` -> `2` rows -> `216.00`
- `2026-03-03` -> `1` row -> `210.00`

## What To Compare

When comparing this reference example with your own implementation, focus on:

- folder structure
- config loading pattern
- separation of transformation logic from database loading
- Dockerfile simplicity
- Compose service naming and persistence model

## Possible Improvements

- incremental load logic
- data quality checks
- staging and target tables
- retry and logging strategy