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
