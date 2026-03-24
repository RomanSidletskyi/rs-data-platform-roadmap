# 04 Local Data Platform Foundation

## Project Goal

Build a small local data-platform-style foundation using Docker Compose with at least one processing service and multiple supporting services.

## Scenario

You want a compact local environment that resembles the shape of a real data platform without turning into a heavyweight production clone. The stack should help you practice service boundaries, storage, configuration, and local workflows.

## Project Type

This folder is a guided project, not a ready solution.

You are expected to build the implementation by following this README and the target design described in [architecture.md](architecture.md).

If a reference example is added later, it should live in a separate sibling folder named:

- `reference_example_local_data_platform_foundation`

## What This Project Should Demonstrate

- Compose as a local platform modeling tool
- object storage and database services in one stack
- one application or ETL service using those dependencies
- clear boundaries between platform services and application services
- architectural reasoning about what belongs in a local stack

## Starter Assets You Already Have

This guided project already includes:

- sample input data in `data/input/`
- `.env.example` with platform runtime variables
- starter config in `config/`
- starter notes in `src/`, `tests/`, and `docker/`

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

## What You Must Build

- a Compose stack that includes Postgres, MinIO, and one processing service
- one ingestion or transformation flow that uses at least one platform service
- persistent storage for both Postgres and MinIO
- a validation flow that proves data moved through the system correctly
- documentation that explains what is a platform service and what is an application service

## Project Structure

	04_local_data_platform_foundation/
		.env.example
		README.md
		architecture.md
		config/
			platform_config.json
		data/
			input/
				events.csv
		docker/
			README.md
		src/
			README.md
		tests/
			README.md

## Recommended Implementation Plan

### Step 1

Read [architecture.md](architecture.md) and understand the service boundaries and storage model.

### Step 2

Inspect the provided starter assets:

- `.env.example`
- `config/platform_config.json`
- `data/input/events.csv`

### Step 3

Implement the processing logic in `src/`:

- read the sample input data
- write at least one output into Postgres or MinIO
- optionally write to both to show different storage roles

### Step 4

Write tests in `tests/` for the core transformation or configuration logic.

### Step 5

Create Docker assets in `docker/`:

- Dockerfile for the processing app
- `docker-compose.yml` for Postgres, MinIO, and the app

### Step 6

Run the full stack and validate that the application interacts correctly with the platform services.

## Implementation Requirements

- use Compose for the full stack
- persist Postgres and MinIO state with volumes
- keep runtime settings in env vars or config files
- clearly separate application logic from platform services
- document the purpose of each component in the system

## Validation Ideas

- start the full stack successfully
- verify MinIO console and API reachability
- verify Postgres persistence
- run one ingestion or transformation flow successfully

## Definition Of Done

This project is complete if:

- the Compose stack starts successfully
- Postgres and MinIO both use persistent storage
- the processing app reads input data and produces at least one verified result
- you can explain the boundary between platform services and the application service
- you can explain why this stack is a useful learning foundation but not a full production platform

## Suggested Self-Check

After attempting the guided project independently, compare your implementation with:

- `03-docker/pet-projects/reference_example_local_data_platform_foundation`

## Possible Improvements

- add a scheduler later
- add healthchecks
- add a lightweight monitoring layer
- move the same stack to another Linux runtime later