# Architecture - 01 Python Batch Job In Docker

## Components

- batch application
- input dataset
- output dataset or result file
- Docker image
- runtime container

## Current Example

The implemented example uses:

- one Python batch application
- one CSV input dataset
- one JSON config file
- one output directory containing summary artifacts

## Data Flow

1. input data is provided to the container
2. Python logic validates and transforms the data
3. the job aggregates totals by region and category
4. the container writes output to a mounted path

## Storage Model

- code lives inside the image
- input and output data should remain outside the image when possible
- configuration should be runtime-driven, not hardcoded into the artifact

## Configuration Model

- use environment variables for environment-specific values
- keep defaults simple for local learning

Current runtime variables:

- `INPUT_PATH`
- `OUTPUT_DIR`
- `CONFIG_PATH`

## Trade-Offs

- bind mounts are easy for local input and output
- image-contained sample data is simpler at first but less realistic
- minimal batch images are easy to reason about but may need more explicit setup

## Why This Example Is Useful

This is intentionally a one-container batch design because it teaches:

- how code becomes an image
- how runtime configuration stays outside the image
- how data should remain outside the image when possible
- how a repeatable batch workload differs from a long-running API or worker service

## What Would Change In Production

- externalized configuration
- stronger validation and logging
- object storage instead of local folders
- CI-driven image builds
- metrics and structured execution metadata