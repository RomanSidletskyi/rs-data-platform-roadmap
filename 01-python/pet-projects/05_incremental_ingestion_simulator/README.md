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
