# Reference Example - Python Batch Job In Docker

This folder contains a ready implementation kept as a reference example.

Its purpose is:

- self-checking after attempting the guided project
- comparing folder structure and implementation decisions
- reusing this pattern when designing future pet modules

You should attempt the guided project first:

- `03-docker/pet-projects/01_python_batch_job_in_docker`

Only after that should you compare your implementation with this reference example.

---

# 01 Python Batch Job In Docker

## Project Goal

Package a small Python batch job into a Docker image and run it as a repeatable data-processing task.

## Scenario

You have a small Python script that reads input data, applies a simple transformation, and writes output artifacts. The project goal is to make this workflow portable and reproducible with Docker.

## What This Project Should Demonstrate

- a clean Dockerfile for a Python batch application
- separation of code, config, and data
- use of bind mounts or mounted input and output folders
- use of environment variables for runtime settings
- understanding of batch-job container behavior

## Implemented Example

This project now contains a working batch job that:

- reads a CSV file with sales-like records
- validates required columns
- aggregates totals by region and category
- writes machine-readable output as JSON
- writes grouped totals as CSV files

## Suggested Folder Roles

- `src/` for the batch logic
- `config/` for local configuration examples
- `data/` for sample input and output
- `docker/` for Docker-related support files
- `tests/` for basic validation tests

## Expected Deliverables

- a runnable Python batch script
- Dockerfile and `.dockerignore`
- sample input and output data
- short run instructions
- notes about what would change in a larger production system

## Project Structure

	01_python_batch_job_in_docker/
		.dockerignore
		.env.example
		config/
			job_config.json
		data/
			input/
				sales.csv
			output/
		docker/
			Dockerfile
		src/
			batch_job.py
			main.py
		tests/
			test_batch_job.py

## Validation Ideas

- build the image successfully
- run the container against sample input
- verify the output files are produced
- confirm the same image can run on another machine

## How To Run Locally

From the project root:

```bash
python3 -m unittest discover -s tests

export INPUT_PATH=data/input/sales.csv
export OUTPUT_DIR=data/output
export CONFIG_PATH=config/job_config.json

python3 src/main.py
```

Expected artifacts:

- `data/output/summary.json`
- `data/output/region_totals.csv`
- `data/output/category_totals.csv`

## How To Run In Docker

Build the image:

```bash
docker build -f docker/Dockerfile -t python-batch-job-demo .
```

Run the container with mounted input and output:

```bash
docker run --rm \
  -e INPUT_PATH=/workspace/data/input/sales.csv \
  -e OUTPUT_DIR=/workspace/data/output \
  -e CONFIG_PATH=/workspace/config/job_config.json \
  -v "$PWD/data:/workspace/data" \
  -v "$PWD/config:/workspace/config:ro" \
  python-batch-job-demo
```

## Validation Checklist

This project is working if:

- the image builds successfully
- the batch job reads the sample CSV file
- output files are generated in `data/output/`
- the tests pass
- the same image can be rerun without code changes

## Possible Improvements

- add structured logging
- add schema validation
- add CLI arguments
- add unit tests for transformations

## Optional Next Step

Run the same batch image later inside another environment such as a remote Linux host or the Raspberry Pi homelab.