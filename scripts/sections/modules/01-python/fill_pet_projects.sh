#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="01-python-fill-pet-projects"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "01-python")"

log "Creating pet projects ..."

cat <<'EOF' > "$MODULE/pet-projects/01_api_to_csv_pipeline/README.md"
# API to CSV Pipeline

A small Python data ingestion project that collects data from a public API, stores the raw response, transforms the data, and saves the processed output as CSV.

## Project Goal

The goal of this project is to simulate a basic real-world ingestion workflow:

1. retrieve data from an external API
2. store the raw response
3. transform the data into a structured format
4. save the processed dataset as CSV
5. log pipeline execution details

## Business Context

Many data platforms start by collecting data from external services such as public APIs, partner systems, or internal microservices.

Before building large-scale data pipelines, a Data Engineer should know how to:

- connect to an API
- extract useful fields
- preserve raw data
- transform records into tabular format
- save datasets for downstream usage
- make the process reproducible

## Architecture

API
↓
Python ingestion script
↓
Raw JSON
↓
Transformation step
↓
Processed CSV
↓
Logs

## Tech Stack

- Python
- requests
- csv
- json
- logging
- pathlib
- pyyaml
- python-dotenv

## Project Structure

01_api_to_csv_pipeline/
│
├── README.md
├── requirements.txt
├── .env.example
│
├── config/
│   └── config.yaml
│
├── src/
│   ├── main.py
│   ├── api_client.py
│   ├── processor.py
│   └── writer.py
│
├── data/
│   ├── raw/
│   └── processed/
│
├── logs/
│
└── tests/

## Input

The input source is a public API that returns JSON data.

## Output

This project produces:

- raw JSON files in `data/raw/`
- processed CSV files in `data/processed/`
- execution logs in `logs/`

## Pipeline Flow

1. read configuration
2. call the API
3. validate the response
4. save raw JSON
5. transform selected fields
6. save processed CSV
7. write execution logs

## Validation Rules

The pipeline should validate:

- the API response is not empty
- the response format is valid JSON
- required fields exist
- records can be transformed into tabular format

## Logging

The pipeline should log:

- pipeline start time
- API request status
- number of records received
- output file paths
- transformation success or failure
- pipeline finish status

## Error Handling

Basic error handling should cover:

- request failures
- timeout errors
- invalid JSON responses
- missing fields
- file writing errors

## Future Improvements

Possible next improvements:

- add retry logic
- support API pagination
- save processed data as Parquet
- add Docker support
- add unit tests
- add schema validation
- support multiple API endpoints
- make the pipeline fully config-driven

## What This Project Demonstrates

This project demonstrates that the repository author can:

- build a modular Python project
- ingest data from external systems
- preserve raw data
- transform JSON into tabular output
- structure a small pipeline clearly
- create a reproducible engineering workflow
EOF

cat <<'EOF' > "$MODULE/pet-projects/02_json_normalizer/README.md"
# JSON Normalizer

A Python project for transforming nested JSON files into flat, analysis-friendly tabular outputs.

## Project Goal

The goal of this project is to build a reusable JSON normalization tool that reads nested JSON files, extracts selected fields, flattens nested structures, and saves the result in a structured format.

## Business Context

Raw data often arrives in nested JSON format from APIs, logs, third-party systems, or event streams. Before analysts or downstream systems can use the data, it usually needs to be flattened and standardized.

This project simulates that common transformation step.

## Architecture

JSON files
↓
Python reader
↓
Normalization logic
↓
Flat structured records
↓
CSV output
↓
Logs

## Tech Stack

- Python
- json
- csv
- pathlib
- logging

## Project Structure

02_json_normalizer/
│
├── README.md
├── src/
│   ├── main.py
│   ├── reader.py
│   ├── normalizer.py
│   └── writer.py
│
├── data/
│   ├── input/
│   └── output/
│
├── logs/
│
└── tests/

## Input

A folder containing nested JSON files.

## Output

This project produces:

- flat structured CSV output
- logs describing processed and skipped files
- optional cleaned JSON output for debugging

## Pipeline Flow

1. read JSON files from input folder
2. validate file structure
3. flatten nested objects
4. extract selected fields
5. save normalized output
6. log processing results

## Validation Rules

The project should validate:

- input file is valid JSON
- required nested paths exist
- records can be flattened consistently

## Logging

The project should log:

- number of files processed
- invalid files
- records extracted
- output file location

## Error Handling

Basic error handling should cover:

- invalid JSON files
- missing keys
- inconsistent data structures
- file writing failures

## Future Improvements

Possible next improvements:

- support multiple normalization schemas
- output Parquet
- add config-driven mappings
- add unit tests
- support recursive flattening

## What This Project Demonstrates

This project demonstrates:

- nested JSON handling
- normalization logic
- reusable transformation patterns
- structured file-based processing
EOF

cat <<'EOF' > "$MODULE/pet-projects/03_log_parser_pipeline/README.md"
# Log Parser Pipeline

A Python project that parses raw application logs and turns them into structured datasets for analysis.

## Project Goal

The goal of this project is to transform raw log lines into structured records and generate useful summaries such as error counts, status distribution, and event trends.

## Business Context

Logs are a critical source of operational data. Data Engineers often need to parse application logs, transform them into structured datasets, and prepare them for analytics or monitoring systems.

This project simulates that workflow.

## Architecture

Log files
↓
Python parser
↓
Structured events
↓
Aggregated summaries
↓
CSV output
↓
Logs

## Tech Stack

- Python
- regex
- csv
- pathlib
- logging

## Project Structure

03_log_parser_pipeline/
│
├── README.md
├── src/
│   ├── main.py
│   ├── parser.py
│   ├── transformer.py
│   └── writer.py
│
├── data/
│   ├── raw_logs/
│   └── processed/
│
├── logs/
│
└── tests/

## Input

Raw application log files stored in a local folder.

## Output

This project produces:

- structured log datasets
- summary CSV reports
- execution logs

## Pipeline Flow

1. read raw log files
2. parse log lines
3. classify log events
4. generate structured records
5. create summary outputs
6. store results and logs

## Validation Rules

The project should validate:

- each log line matches expected format
- timestamps are parseable
- severity levels are recognized

## Logging

The project should log:

- files processed
- lines parsed
- invalid log lines
- output file paths

## Error Handling

Basic error handling should cover:

- unreadable files
- malformed log lines
- parsing failures
- output write errors

## Future Improvements

Possible next improvements:

- support multiple log formats
- generate daily partitions
- add alert thresholds
- output Parquet
- add tests for parser logic

## What This Project Demonstrates

This project demonstrates:

- text parsing
- log processing
- building structured operational datasets
- transforming unstructured input into analytics-ready outputs
EOF

cat <<'EOF' > "$MODULE/pet-projects/04_data_quality_checker/README.md"
# Data Quality Checker

A Python project for validating datasets and generating data quality reports.

## Project Goal

The goal of this project is to create a reusable validation tool that checks records for missing values, invalid types, duplicates, and schema mismatches.

## Business Context

Data quality checks are a core part of production pipelines. Engineers need to validate incoming data before loading it into downstream systems to prevent reporting issues, broken transformations, and bad analytics.

This project simulates a small but realistic validation layer.

## Architecture

Input dataset
↓
Validation engine
↓
Valid records
↓
Invalid records
↓
Quality report
↓
Logs

## Tech Stack

- Python
- pandas
- json
- csv
- logging
- pathlib

## Project Structure

04_data_quality_checker/
│
├── README.md
├── src/
│   ├── main.py
│   ├── validator.py
│   ├── rules.py
│   └── reporter.py
│
├── data/
│   ├── input/
│   ├── valid/
│   └── invalid/
│
├── reports/
├── logs/
└── tests/

## Input

Structured datasets such as CSV or JSON files.

## Output

This project produces:

- valid cleaned datasets
- invalid or quarantined records
- data quality summary reports
- execution logs

## Pipeline Flow

1. read input dataset
2. apply validation rules
3. separate valid and invalid records
4. generate quality metrics
5. save outputs and report results

## Validation Rules

The project should validate:

- required fields
- null values
- data type consistency
- duplicate records
- optional business rules

## Logging

The project should log:

- files processed
- records checked
- validation failures
- report location

## Error Handling

Basic error handling should cover:

- unreadable files
- malformed records
- schema mismatches
- output write errors

## Future Improvements

Possible next improvements:

- config-driven validation rules
- HTML or Markdown reports
- warning and failure thresholds
- schema version support
- unit tests for rule sets

## What This Project Demonstrates

This project demonstrates:

- reusable validation design
- data quality thinking
- quarantine patterns
- report generation for operational workflows
EOF

cat <<'EOF' > "$MODULE/pet-projects/05_incremental_ingestion_simulator/README.md"
# Incremental Ingestion Simulator

A Python project that simulates daily file ingestion while processing only new data.

## Project Goal

The goal of this project is to simulate incremental ingestion behavior by processing only new files, tracking already processed inputs, and avoiding duplicate work across runs.

## Business Context

Most real pipelines do not reprocess everything from scratch every time. They use incremental logic to reduce compute cost, improve efficiency, and avoid duplicate output.

This project simulates that pattern in a local file-based workflow.

## Architecture

Input folder
↓
Python ingestion script
↓
Processed file tracker
↓
New files only
↓
Processed output
↓
Logs

## Tech Stack

- Python
- json
- csv
- pathlib
- logging

## Project Structure

05_incremental_ingestion_simulator/
│
├── README.md
├── src/
│   ├── main.py
│   ├── scanner.py
│   ├── tracker.py
│   └── processor.py
│
├── data/
│   ├── incoming/
│   ├── processed/
│   └── state/
│
├── logs/
│
└── tests/

## Input

A folder containing incoming files that simulate daily data arrivals.

## Output

This project produces:

- processed output files
- state files tracking processed inputs
- logs showing which files were skipped or processed

## Pipeline Flow

1. scan incoming folder
2. identify new files
3. skip already processed files
4. transform new inputs
5. save processed output
6. update processing state
7. log execution summary

## Validation Rules

The project should validate:

- input files are readable
- input format is supported
- each file is processed only once unless explicitly reset

## Logging

The project should log:

- files discovered
- files skipped
- files processed
- output locations
- final processing counts

## Error Handling

Basic error handling should cover:

- unreadable files
- invalid file format
- state file corruption
- output write errors

## Future Improvements

Possible next improvements:

- checkpoint versioning
- late-arriving file handling
- quarantine for bad files
- config-driven rules
- scheduled execution
- tests for state tracking logic

## What This Project Demonstrates

This project demonstrates:

- incremental processing patterns
- state tracking
- idempotent workflow thinking
- realistic batch ingestion behavior
EOF

log "Pet projects created."