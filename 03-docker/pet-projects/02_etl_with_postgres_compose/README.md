# 02 ETL With Postgres Compose

## Project Goal

Build a small ETL workflow that runs with Docker Compose and loads data into Postgres.

## Scenario

You have a local CSV dataset with order records and want to load it into a relational target, then create at least one transformed analytics table. Docker Compose should model the full local system.

## Project Type

This folder is a guided project, not a ready solution.

You are expected to build the implementation by following this README and the target design described in [architecture.md](architecture.md).

If a reference example is added later, it should live in a separate sibling folder named:

- `reference_example_etl_with_postgres_compose`

## What This Project Should Demonstrate

- a small multi-service Compose setup
- Postgres as a stateful service with persistent volume
- ETL application configuration through environment variables
- app-to-database connectivity using service names
- clear separation between source data, code, and storage

## Starter Assets You Already Have

This guided project already includes:

- sample source data in `data/input/`
- `.env.example` with runtime variables
- starter config in `config/`
- starter notes in `src/`, `tests/`, and `docker/`

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

## What You Must Build

- a Python ETL application that reads `data/input/orders.csv`
- a Postgres target service in Docker Compose
- at least one raw load into a database table
- at least one transformed output such as a daily summary table or region summary table
- one validation step using SQL or logs
- a Docker image for the ETL app
- a Compose file that runs the app and the database together

## Project Structure

	02_etl_with_postgres_compose/
		.env.example
		README.md
		architecture.md
		config/
			etl_config.json
		data/
			input/
				orders.csv
		docker/
			README.md
		src/
			README.md
		tests/
			README.md

## Recommended Implementation Plan

### Step 1

Read [architecture.md](architecture.md) and understand the target components, storage model, and network model.

### Step 2

Inspect the provided starter assets:

- `.env.example`
- `config/etl_config.json`
- `data/input/orders.csv`

### Step 3

Implement the ETL logic in `src/`:

- read the CSV source data
- validate required columns
- create one raw load path
- create one transformed summary output

### Step 4

Write tests in `tests/`:

- at least one transformation test
- at least one validation test
- optionally one SQL-generation or config test

### Step 5

Create Docker assets in `docker/`:

- Dockerfile for the ETL app
- `docker-compose.yml` for app and Postgres

### Step 6

Run the ETL flow through Compose and verify the loaded data in Postgres.

## Implementation Requirements

- use environment variables for database connectivity and file paths
- use the Compose service name as the Postgres host
- persist Postgres data in a named volume
- keep machine-specific paths out of code
- make the ETL app runnable both locally and in Docker

## Validation Ideas

- start the stack successfully
- confirm database readiness
- run the ETL process
- verify loaded records in Postgres

## Definition Of Done

This project is complete if:

- the ETL app loads source records into Postgres
- one transformed summary table or output is created
- the Compose stack runs successfully
- Postgres state survives container recreation because of a named volume
- you can explain why the ETL app must use the service name instead of `localhost`

## Suggested Self-Check

After attempting the guided project independently, compare your implementation with:

- `03-docker/pet-projects/reference_example_etl_with_postgres_compose`

## Possible Improvements

- incremental load logic
- data quality checks
- staging and target tables
- retry and logging strategy