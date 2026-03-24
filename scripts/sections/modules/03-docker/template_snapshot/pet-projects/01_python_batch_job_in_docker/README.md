# 01 Python Batch Job In Docker

## Project Goal

Build a small Python batch job, package it into a Docker image, and run it as a repeatable data-processing task.

## Scenario

You have a small CSV dataset with sales-like records. Your task is to build a batch job that reads the input, validates the data, creates summary outputs, and runs the workflow in Docker.

## What This Project Should Demonstrate

- a clean Dockerfile for a Python batch application
- separation of code, config, and data
- use of bind mounts or mounted input and output folders
- use of environment variables for runtime settings
- understanding of batch-job container behavior

## Project Type

This folder is a guided project, not a ready solution.

You are expected to build the implementation yourself by following the instructions in this README and the target architecture in [architecture.md](architecture.md).

If you later want to compare your result with a ready implementation, use the separate reference example in:

- `03-docker/pet-projects/reference_example_python_batch_job_in_docker`

## Starter Assets You Already Have

This guided project already includes:

- sample input data in `data/input/`
- example runtime variables in `.env.example`
- a starter config file in `config/`
- starter notes in `src/`, `docker/`, and `tests/`

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

## What You Must Build

Implement a batch job that:

- reads `data/input/sales.csv`
- validates that required columns are present
- computes total rows and total amount
- computes totals by region
- computes totals by category
- writes a summary JSON artifact
- writes at least two CSV output artifacts
- runs locally and in Docker

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
			README.md
		src/
			README.md
		tests/
			README.md

## Recommended Implementation Plan

### Step 1

Read [architecture.md](architecture.md) and understand:

- the target components
- the expected data flow
- the storage model
- the runtime configuration model

### Step 2

Inspect the provided starter assets:

- `.env.example`
- `config/job_config.json`
- `data/input/sales.csv`

### Step 3

Implement Python code in `src/`:

- one entry point such as `main.py`
- one module for batch logic or helpers
- input validation
- aggregation logic
- output writing

### Step 4

Add tests in `tests/`:

- at least one logic test
- at least one validation test
- optionally one artifact-generation test

### Step 5

Create Docker assets in `docker/`:

- Dockerfile
- optional run notes or helper commands

### Step 6

Run the batch job locally and in Docker.

### Step 7

Write a short note in this README describing:

- what you implemented
- what assumptions you made
- what you would improve next

## Implementation Requirements

- use environment variables for `INPUT_PATH`, `OUTPUT_DIR`, and `CONFIG_PATH`
- keep data outside the image at runtime by using mounts
- keep the Python solution simple and readable
- do not hardcode machine-specific paths
- make the Docker image focused on runtime behavior only

## Validation Ideas

- build the image successfully
- run the container against sample input
- verify the output files are produced
- confirm the same image can run on another machine

## Definition Of Done

This project is complete if:

- you implemented the batch logic in `src/`
- you added tests in `tests/`
- you created a Dockerfile in `docker/`
- the job runs successfully against `data/input/sales.csv`
- output artifacts are generated in `data/output/`
- the same workflow can run via Docker using mounted `data/` and `config/`

## Suggested Self-Check

After implementation, compare your result with the reference example only after you have attempted the project yourself.

## Possible Improvements

- add structured logging
- add schema validation
- add CLI arguments
- add unit tests for transformations

## Optional Next Step

Run the same batch image later inside another environment such as a remote Linux host or the Raspberry Pi homelab.