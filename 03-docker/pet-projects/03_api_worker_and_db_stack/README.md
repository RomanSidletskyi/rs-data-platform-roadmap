# 03 API Worker And DB Stack

## Project Goal

Model a small multi-service application stack with an API, a worker, and a database using Docker Compose.

## Scenario

An API accepts work requests. A worker processes queued or persisted jobs. A database stores job metadata and results. The goal is to use Docker as a local system modeling tool, not just a container runner.

## Project Type

This folder is a guided project, not a ready solution.

You are expected to build the implementation by following this README and the target design described in [architecture.md](architecture.md).

If a reference example is added later, it should live in a separate sibling folder named:

- `reference_example_api_worker_and_db_stack`

## What This Project Should Demonstrate

- multiple application services in one Compose stack
- different responsibilities for API and worker processes
- shared configuration patterns
- service-to-service communication and debugging
- local distributed-system thinking in a small, understandable form

## Starter Assets You Already Have

This guided project already includes:

- sample request payloads in `data/requests/`
- `.env.example` with runtime variables
- starter app config in `config/`
- starter notes in `src/`, `tests/`, and `docker/`

## Suggested Folder Roles

- `src/` for API and worker code
- `config/` for settings and env examples
- `data/` for local sample payloads or fixtures
- `docker/` for Compose and Dockerfile assets
- `tests/` for API and worker validation

## Expected Deliverables

- Compose stack with API, worker, and Postgres
- one documented request flow from submission to processed result
- validation steps using logs or database queries

## What You Must Build

- an API service that accepts a work request
- a worker service that processes pending work
- a Postgres service that stores job state and results
- a Compose stack that runs all three services together
- a documented request-to-result flow
- tests for at least one part of the processing logic

## Project Structure

	03_api_worker_and_db_stack/
		.env.example
		README.md
		architecture.md
		config/
			app_config.json
		data/
			requests/
				sample_job.json
		docker/
			README.md
		src/
			README.md
		tests/
			README.md

## Recommended Implementation Plan

### Step 1

Read [architecture.md](architecture.md) and understand the responsibility boundaries between API, worker, and database.

### Step 2

Inspect the provided starter assets:

- `.env.example`
- `config/app_config.json`
- `data/requests/sample_job.json`

### Step 3

Implement the API and worker in `src/`:

- one endpoint or request handler for job intake
- one worker loop or processing function
- one database write path for status or results

### Step 4

Write tests in `tests/`:

- at least one API or input-validation test
- at least one worker or processing test

### Step 5

Create Docker assets in `docker/`:

- Dockerfile or multiple Dockerfiles if you want clearer service separation
- `docker-compose.yml` for API, worker, and Postgres

### Step 6

Run the full stack and verify the request flow from API submission to processed result.

## Implementation Requirements

- keep API and worker responsibilities separate
- use environment variables for runtime configuration
- use the Compose service name for database connectivity
- store job state in Postgres
- make the system debuggable through logs

## Validation Ideas

- start all services successfully
- submit a job to the API
- observe worker processing through logs
- verify job result persistence in the database

## Definition Of Done

This project is complete if:

- the API accepts at least one job request
- the worker processes that job successfully
- job status or result is persisted in Postgres
- the Compose stack starts all services together
- you can explain why separating API and worker responsibilities improves system clarity

## Suggested Self-Check

After attempting the guided project independently, compare your implementation with:

- `03-docker/pet-projects/reference_example_api_worker_and_db_stack`

## Possible Improvements

- add a queue or broker later
- add retry handling
- add request validation
- add metrics or health endpoints