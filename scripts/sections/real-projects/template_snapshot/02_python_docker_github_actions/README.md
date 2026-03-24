# Real Project 02: Python Plus Docker Plus GitHub Actions

## Goal

Take a Python data workflow and make it reproducible, containerized, and validated through CI.

This project should introduce delivery discipline without losing architectural simplicity.

Current reference solution status:

- runnable locally
- runnable in Docker
- validated with `unittest`
- validated in GitHub Actions through a dedicated workflow
- includes bundled valid and invalid sample source data for self-practice

## Suggested Stack

- Python
- Docker
- GitHub Actions

## Architecture Focus

- reproducible execution
- packaging boundaries
- CI validation versus local-only workflows
- environment consistency

## Suggested Deliverables

- containerized project runtime
- GitHub Actions workflow for validation
- lint or test step
- documented local and CI run flow

## Current Repository Structure

```text
02_python_docker_github_actions/
	README.md
	architecture-notes.md
	adr.md
	implementation-plan.md
	requirements.txt
	.dockerignore
	config/
		settings.json
	data/
		quality/
		raw/
		source/
			orders.csv
			orders_invalid.csv
		warehouse/
			warehouse.db
	docker/
		Dockerfile
		README.md
	src/
		python_docker_github_actions/
			config_loader.py
			database.py
			io_utils.py
			pipeline.py
			quality.py
	tests/
		test_pipeline.py
	run_pipeline.py
```

## What This Project Adds Compared With Project 01

Compared with `01_python_sql_etl`, this project adds:

- reproducible container runtime
- explicit Docker build and run flow
- GitHub Actions validation workflow
- stronger delivery discipline around the same ETL idea

## Pipeline Behavior

The ETL flow stays intentionally simple:

1. read source CSV
2. write a timestamped raw snapshot
3. run data quality checks and write a JSON quality report
4. load raw rows into SQLite
5. build `curated_daily_sales`

## Local Run Commands

From the project directory:

Full run:

```bash
/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/.venv/bin/python run_pipeline.py --run-mode full
```

Extract only:

```bash
/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/.venv/bin/python run_pipeline.py --run-mode extract
```

Load only:

```bash
/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/.venv/bin/python run_pipeline.py --run-mode load
```

Transform only:

```bash
/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/.venv/bin/python run_pipeline.py --run-mode transform
```

Run tests:

```bash
/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/.venv/bin/python -m unittest tests/test_pipeline.py
```

## Docker Run Commands

Build image:

```bash
docker build -f docker/Dockerfile -t python-docker-github-actions:local .
```

Run the default full pipeline:

```bash
docker run --rm python-docker-github-actions:local
```

Run another mode:

```bash
docker run --rm python-docker-github-actions:local python run_pipeline.py --run-mode extract
```

## GitHub Actions Workflow

Workflow file:

- `../../.github/workflows/real-project-02-python-docker-github-actions.yml`

The workflow validates:

- Python source compilation
- smoke tests
- Docker image build

## Included Local Assets

You do not need to download anything externally to start this project.

Bundled already:

- `data/source/orders.csv`
- `data/source/orders_invalid.csv`
- SQLite target path in `data/warehouse/warehouse.db`
- Dockerfile
- GitHub Actions workflow

## Step-By-Step Self-Study Path

If you want to build the project yourself and then compare with the ready solution, use this order:

1. read `architecture-notes.md`
2. read `adr.md`
3. read `implementation-plan.md`
4. create the Python ETL exactly as in project 01
5. add bundled source data and validation tests
6. add `.dockerignore`
7. add `docker/Dockerfile`
8. run the project locally
9. run the tests locally
10. build and run the Docker image
11. add the GitHub Actions workflow
12. compare your result with this reference implementation

## What The Final State Should Be

By the end, you should have:

- runnable local ETL pipeline
- raw snapshots in `data/raw/`
- quality reports in `data/quality/`
- SQLite database in `data/warehouse/warehouse.db`
- passing `unittest` smoke tests
- successful Docker image build
- a GitHub Actions workflow that validates Python and Docker changes

## What To Compare Against The Ready Solution

When you compare your own version to this reference, focus on:

- whether your local and container runs behave the same way
- whether your workflow actually tests meaningful behavior
- whether your Docker image contains only what the project needs
- whether the README explains how to build and validate the project clearly

## Review Questions

- what delivery problem is Docker solving here
- what does CI validate before changes are accepted
- where could tooling overhead become heavier than the project need

## Read With

- `../../docs/architecture/reviews/real-project-review-exercises.md`
- `../../docs/architecture/reviews/system-shape-review-checklist.md`
- `../../docs/architecture/adr/template.md`