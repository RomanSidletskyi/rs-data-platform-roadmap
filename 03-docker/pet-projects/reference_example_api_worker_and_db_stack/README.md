# Reference Example - API Worker And DB Stack

This folder contains a ready implementation kept as a reference example.

Its purpose is:

- self-checking after attempting the guided project
- comparing implementation decisions
- preserving a working API plus worker plus database stack for future project design

You should attempt the guided project first:

- `03-docker/pet-projects/03_api_worker_and_db_stack`

Only after that should you compare your implementation with this reference example.

---

# 03 API Worker And DB Stack

## Project Goal

Model a small multi-service application stack with an API, a worker, and a database using Docker Compose.

## Scenario

An API accepts work requests. A worker processes queued or persisted jobs. A database stores job metadata and results. The goal is to use Docker as a local system modeling tool, not just a container runner.

## Implemented Example

This reference implementation includes:

- a Flask API that accepts job requests
- a worker process that polls pending jobs from Postgres
- a shared Postgres database for job state and results
- unit tests for job processing and config logic
- Docker Compose for API, worker, and Postgres

## What This Project Should Demonstrate

- multiple application services in one Compose stack
- different responsibilities for API and worker processes
- shared configuration patterns
- service-to-service communication and debugging
- local distributed-system thinking in a small, understandable form

## Project Structure

	reference_example_api_worker_and_db_stack/
		.dockerignore
		.env.example
		README.md
		architecture.md
		requirements.txt
		config/
			app_config.json
		data/
			requests/
				sample_job.json
		docker/
			Dockerfile
			docker-compose.yml
		src/
			api_app.py
			config_loader.py
			db.py
			processor.py
			worker.py
		tests/
			test_processor.py

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

## How The Example Works

1. the API receives a job request through `POST /jobs`
2. the API validates the job type and stores a pending job in Postgres
3. the worker polls for pending jobs
4. the worker processes the job and updates the job status
5. the worker stores a result payload in the database

## How To Run Locally

Install dependencies:

```bash
python3 -m pip install -r requirements.txt
```

Run tests:

```bash
python3 -m unittest discover -s tests
```

To run the API locally:

```bash
export FLASK_APP=src/api_app.py
export POSTGRES_DB=jobs_lab
export POSTGRES_USER=jobs_user
export POSTGRES_PASSWORD=jobs_pass
export POSTGRES_HOST=localhost
export POSTGRES_PORT=5432
export APP_CONFIG_PATH=config/app_config.json

python3 src/api_app.py
```

To run the worker locally:

```bash
python3 src/worker.py
```

## How To Run With Docker Compose

From the project root:

```bash
docker compose -f docker/docker-compose.yml up --build
```

Submit the sample job:

```bash
curl -X POST http://localhost:8000/jobs \
	-H 'Content-Type: application/json' \
	-d @data/requests/sample_job.json
```

## Validation Ideas

- start all services successfully
- submit a job to the API
- observe worker processing through logs
- verify job result persistence in the database

Useful validation query:

```sql
SELECT job_id, status FROM jobs ORDER BY created_at;
```

```sql
SELECT job_id, result_payload FROM job_results ORDER BY created_at;
```

## What To Compare

When comparing this reference example with your own implementation, focus on:

- shared image with separate API and worker entrypoints
- separation of API and processing logic
- persistence model for job state and results
- Compose networking and service naming
- logging and polling simplicity versus future queueing needs

## Possible Improvements

- add a queue or broker later
- add retry handling
- add request validation
- add metrics or health endpoints