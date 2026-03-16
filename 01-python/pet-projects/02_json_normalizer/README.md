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
