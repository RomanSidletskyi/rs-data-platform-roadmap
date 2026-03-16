# Data Engineering Python Tasks

This section connects Python fundamentals with real data engineering workflows.

---

## Task 1 — Build a Mini ETL Script

### Goal
Create a simple extract-transform-load flow.

### Input

    raw_users = [
        {"id": 1, "name": " Alice ", "email": "alice@example.com"},
        {"id": 2, "name": "Bob", "email": "bob@example.com"},
        {"id": 3, "name": " Charlie ", "email": "charlie@example.com"}
    ]

### Requirements

- read input data
- clean the `name` field
- save processed output
- log what happened

### Expected Output

    [
        {"id": 1, "name": "Alice", "email": "alice@example.com"},
        {"id": 2, "name": "Bob", "email": "bob@example.com"},
        {"id": 3, "name": "Charlie", "email": "charlie@example.com"}
    ]

### Extra Challenge

- save both raw and processed versions
- add execution timestamp to output filename

---

## Task 2 — Validate JSON Schema

### Goal
Check incoming data structure before processing.

### Input

    records = [
        {"id": 1, "name": "Alice", "email": "alice@example.com"},
        {"id": 2, "name": "Bob"},
        {"id": 3, "email": "charlie@example.com"}
    ]

Required keys:

- id
- name
- email

### Requirements

- validate each record
- separate valid and invalid data

### Expected Output

Two lists:
- valid records
- invalid records

### Extra Challenge

- store invalid records in a quarantine file
- report missing fields per record

---

## Task 3 — Create Raw and Processed Folders

### Goal
Introduce data zone thinking.

### Input

Any small dataset, for example:

    [
        {"id": 1, "name": "Alice"},
        {"id": 2, "name": "Bob"}
    ]

### Requirements

- store original data in `raw`
- store cleaned data in `processed`
- keep both outputs after the run

### Expected Output

Files written to:

    data/raw/
    data/processed/

### Extra Challenge

- add `quarantine/` folder
- save execution metadata in a side file

---

## Task 4 — Process Only New Files

### Goal
Simulate incremental ingestion.

### Input

Folder:

    input/
      users_day_1.json
      users_day_2.json
      users_day_3.json

Processed files tracker:

    state/processed_files.json

### Requirements

- read files from an input folder
- skip files already processed
- keep track of processed file names

### Expected Output

Only new files are processed.

### Extra Challenge

- allow resetting the state file
- print which files were skipped vs processed

---

## Task 5 — Add Execution Metadata

### Goal
Improve observability of outputs.

### Input

Any processed dataset.

### Requirements

- include execution date
- include source file or run id
- save metadata in output or side file

### Expected Output

A metadata JSON file or metadata columns.

### Extra Challenge

- include record count
- include pipeline duration

---

## Task 6 — Build a Pipeline Run Report

### Goal
Summarize execution results.

### Input

Any pipeline processing multiple records or files.

### Requirements

- total input files
- total records
- valid records
- invalid records
- output locations

### Expected Output

A run summary printed to console or saved to JSON.

### Extra Challenge

- save the report to `reports/run_summary.json`
- include warning and error counts

---

## Task 7 — Save Bad Records to Quarantine

### Goal
Handle data quality issues safely.

### Input

    records = [
        {"id": 1, "name": "Alice", "email": "alice@example.com"},
        {"id": 2, "name": "Bob"},
        {"id": 3, "email": "charlie@example.com"}
    ]

### Requirements

- identify invalid rows
- write them to a separate file
- keep the main output clean

### Expected Output

Two outputs:
- processed valid data
- quarantined invalid data

### Extra Challenge

- include validation reason in quarantined output
- create a quarantine summary report

---

## Task 8 — Make Processing Idempotent

### Goal
Avoid duplicate output from repeated runs.

### Input

Run the same input dataset twice.

### Requirements

- rerun the same pipeline safely
- do not duplicate already processed results
- document how idempotency is enforced

### Expected Output

Second run does not create duplicate records.

### Extra Challenge

- use record hashes or file state tracking
- compare output before and after rerun
