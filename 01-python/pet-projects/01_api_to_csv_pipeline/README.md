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
