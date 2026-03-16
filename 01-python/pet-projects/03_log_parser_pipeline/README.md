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
