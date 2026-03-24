# Data Engineering Python Tasks

This section connects Python fundamentals with real data engineering workflows.

The goal is to stop writing exercises that only manipulate data in memory and start practicing workflow-shaped tasks.

That means these tasks should reinforce habits such as:

- preserving raw input
- validating before publish
- separating valid and invalid outputs
- tracking state explicitly
- writing run metadata
- keeping reruns safe

## What Good Completion Looks Like

By the end of this block, you should be able to build a small local pipeline that:

- keeps raw and processed data separate
- validates records before writing final outputs
- quarantines invalid data instead of hiding it
- emits summary metadata
- handles reruns in a controlled way

## Task 1 — Build A Mini ETL Script

### Goal

Create a simple extract-transform-load flow with a clear runtime shape.

### Input

```python
raw_users = [
    {"id": 1, "name": " Alice ", "email": "alice@example.com"},
    {"id": 2, "name": "Bob", "email": "bob@example.com"},
    {"id": 3, "name": " Charlie ", "email": "charlie@example.com"},
]
```

### Requirements

- preserve the raw input
- clean the `name` field
- normalize the `email` field
- save processed output
- log or print what happened

### Expected Output

```python
[
    {"id": 1, "name": "Alice", "email": "alice@example.com"},
    {"id": 2, "name": "Bob", "email": "bob@example.com"},
    {"id": 3, "name": "Charlie", "email": "charlie@example.com"},
]
```

### Extra Challenge

- save both raw and processed versions
- add execution timestamp to output filename

## Task 2 — Validate JSON Schema

### Goal

Check incoming data structure before processing.

### Input

```python
records = [
    {"id": 1, "name": "Alice", "email": "alice@example.com"},
    {"id": 2, "name": "Bob"},
    {"id": 3, "email": "charlie@example.com"},
]
```

Required keys:

- `id`
- `name`
- `email`

### Requirements

- validate each record
- separate valid and invalid data
- capture which fields are missing

### Expected Output

Two lists:

- valid records
- invalid records with validation context

### Extra Challenge

- store invalid records in a quarantine file
- return a validation summary with counts

## Task 3 — Create Raw, Processed, And Quarantine Folders

### Goal

Introduce data zone thinking.

### Input

Any small dataset, for example:

```python
[
    {"id": 1, "name": "Alice"},
    {"id": 2, "name": "Bob"},
]
```

### Requirements

- store original data in `data/raw/`
- store cleaned data in `data/processed/`
- store invalid data in `data/quarantine/` when needed
- keep all outputs after the run

### Expected Output

Files written to clearly separated folders.

### Extra Challenge

- save execution metadata in a side JSON file
- create missing folders automatically

## Task 4 — Process Only New Files

### Goal

Simulate incremental ingestion.

### Input

Folder:

```text
input/
  users_day_1.json
  users_day_2.json
  users_day_3.json
```

Processed files tracker:

```text
state/processed_files.json
```

### Requirements

- read files from an input folder
- skip files already processed
- keep track of processed file names
- update state only after successful processing

### Expected Output

Only new files are processed.

### Extra Challenge

- allow resetting the state file
- print which files were skipped vs processed

## Task 5 — Add Execution Metadata

### Goal

Improve observability of outputs.

### Input

Any processed dataset.

### Requirements

- include execution timestamp
- include source file or run id
- include output path
- save metadata in a side file or metadata columns

### Expected Output

A metadata JSON file or metadata-enriched output.

### Extra Challenge

- include record count
- include pipeline duration

## Task 6 — Build A Pipeline Run Report

### Goal

Summarize execution results clearly.

### Input

Any pipeline processing multiple records or files.

### Requirements

- report total input files
- report total records
- report valid records
- report invalid records
- report output locations
- report whether the run completed successfully

### Expected Output

A run summary printed to console or saved to JSON.

### Extra Challenge

- save the report to `reports/run_summary.json`
- include warning and error counts

## Task 7 — Save Bad Records To Quarantine

### Goal

Handle data quality issues safely.

### Input

```python
records = [
    {"id": 1, "name": "Alice", "email": "alice@example.com"},
    {"id": 2, "name": "Bob"},
    {"id": 3, "email": "charlie@example.com"},
]
```

### Requirements

- identify invalid rows
- attach a validation reason
- write them to a separate file
- keep the main output clean

### Expected Output

Two outputs:

- processed valid data
- quarantined invalid data with reasons

### Extra Challenge

- create a quarantine summary report
- write quarantine output as JSON Lines or CSV

## Task 8 — Make Processing Idempotent

### Goal

Avoid duplicate output from repeated runs.

### Input

Run the same input dataset twice.

### Requirements

- rerun the same pipeline safely
- do not duplicate already processed results
- document how idempotency is enforced
- compare output before and after rerun

### Expected Output

Second run does not create duplicate records or duplicate files unexpectedly.

### Extra Challenge

- use record hashes or file state tracking
- implement deterministic output paths for one logical input

## Task 9 — Stream Records Instead Of Loading Everything At Once

### Goal

Practice generator-based processing.

### Input

Any dataset that can be represented as many records or many file lines.

### Requirements

- create one generator that yields records one by one
- pass the generator into one validation or normalization step
- explain what is processed lazily

### Expected Output

A small pipeline shape that uses `yield` and avoids building all intermediate results eagerly.

### Extra Challenge

- read a JSON Lines file one record at a time
- compare generator output with list-based output

## Task 10 — Add Typed Record Contracts To A Pipeline Stage

### Goal

Make pipeline shapes more explicit.

### Input

Any small pipeline from this section.

### Requirements

- define one typed raw record shape and one processed record shape
- update one validator or normalizer to use those contracts
- explain how the raw and processed layers differ

### Expected Output

One pipeline step with clearer data contracts.

### Extra Challenge

- use `TypedDict` for raw data and `dataclass` for processed config or metadata
- identify one place where runtime validation is still needed despite type hints

## Key Learning Rule

The purpose of this block is not only to “process some records”.

The purpose is to start thinking like a pipeline engineer:

- what is raw
- what is processed
- what is invalid
- what state is remembered
- what makes the run safe to repeat
