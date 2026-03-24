# Reference Example - Local Data Platform Foundation

This folder contains a ready implementation kept as a reference example.

Its purpose is:

- self-checking after attempting the guided project
- comparing implementation decisions
- preserving a small but working platform-style stack for future project design

You should attempt the guided project first:

- `03-docker/pet-projects/04_local_data_platform_foundation`

Only after that should you compare your implementation with this reference example.

---

# 04 Local Data Platform Foundation

## Project Goal

Build a small local data-platform-style foundation using Docker Compose with at least one processing service and multiple supporting services.

## Scenario

You want a compact local environment that resembles the shape of a real data platform without turning into a heavyweight production clone. The stack should help you practice service boundaries, storage, configuration, and local workflows.

## Implemented Example

This reference implementation includes:

- one processing application
- one Postgres service for structured storage
- one MinIO service for object storage simulation
- one application flow that writes a summary into Postgres and uploads an artifact into MinIO
- unit tests for transformation and config logic
- Docker Compose for the full local stack

## What This Project Should Demonstrate

- Compose as a local platform modeling tool
- object storage and database services in one stack
- one application or ETL service using those dependencies
- clear boundaries between platform services and application services
- architectural reasoning about what belongs in a local stack

## Project Structure

	reference_example_local_data_platform_foundation/
		.dockerignore
		.env.example
		README.md
		architecture.md
		requirements.txt
		config/
			platform_config.json
		data/
			input/
				events.csv
		docker/
			Dockerfile
			docker-compose.yml
		src/
			config_loader.py
			db.py
			main.py
			object_store.py
			transformer.py
		tests/
			test_transformer.py

## Suggested Stack

- Postgres
- MinIO
- one Python ingestion or transformation service

## Suggested Folder Roles

- `src/` for processing logic
- `config/` for settings and examples
- `data/` for sample input and artifacts
- `docker/` for Compose assets and Dockerfiles
- `tests/` for local validation checks

## Expected Deliverables

- Compose stack with multiple services
- documented data flow across services
- validation steps for storage and processing behavior
- notes about trade-offs and scope boundaries

## How The Example Works

1. the processing app reads `data/input/events.csv`
2. it validates required fields and computes event counts by type
3. it loads raw rows into Postgres
4. it loads the summary into Postgres
5. it uploads a JSON summary artifact to MinIO

## How To Run Locally

Install dependencies:

```bash
python3 -m pip install -r requirements.txt
```

Run tests:

```bash
python3 -m unittest discover -s tests
```

To run the processing app locally, set runtime variables to a local Postgres and MinIO instance and run:

```bash
python3 src/main.py
```

## How To Run With Docker Compose

From the project root:

```bash
docker compose -f docker/docker-compose.yml up --build
```

## Validation Ideas

- start the full stack successfully
- verify MinIO console and API reachability
- verify Postgres persistence
- run one ingestion or transformation flow successfully

Useful validation queries:

```sql
SELECT event_type, event_count FROM event_counts_by_type ORDER BY event_type;
```

The MinIO bucket should contain a summary artifact named `event_summary.json`.

## What To Compare

When comparing this reference example with your own implementation, focus on:

- how the app uses two different storage systems for different purposes
- how runtime configuration stays outside the app code
- how the Compose stack models platform services versus application service
- how a small local stack stays focused instead of bloated

## Possible Improvements

- add a scheduler later
- add healthchecks
- add a lightweight monitoring layer
- move the same stack to another Linux runtime later