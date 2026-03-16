# Error Handling and Logging

This section focuses on making Python scripts safer and easier to debug.

---

## Task 1 — Add Try/Except to a File Script

### Goal
Protect a file-processing script from crashing unexpectedly.

### Input

Try opening:

    missing_file.csv

### Requirements

- catch missing file errors
- catch parsing errors
- show meaningful messages

### Expected Output

A readable message such as:

    File not found: missing_file.csv

### Extra Challenge

- log the error to a file
- handle multiple exception types differently

---

## Task 2 — Log Pipeline Start and Finish

### Goal
Introduce execution logging.

### Input

Any script that:
- reads data
- transforms data
- writes output

### Requirements

- log pipeline start time
- log pipeline finish time
- log success status

### Expected Output

A log file or console output with start and finish messages.

### Extra Challenge

- include execution duration
- include record count in logs

---

## Task 3 — Log Invalid Records Separately

### Goal
Track bad data.

### Input

    records = [
        {"id": 1, "name": "Alice", "email": "alice@example.com"},
        {"id": 2, "name": "Bob"},
        {"id": 3, "email": "charlie@example.com"}
    ]

### Requirements

- identify invalid records
- write them to a dedicated log or file
- count how many invalid rows were found

### Expected Output

A separate file or log section containing invalid records.

### Extra Challenge

- log which exact fields are missing
- create both `valid_records` and `invalid_records` outputs

---

## Task 4 — Save Errors to a Log File

### Goal
Persist operational information.

### Input

A script that may fail while reading files or calling an API.

### Requirements

- configure a log file
- write warnings and errors to disk
- include timestamps

### Expected Output

A file such as:

    logs/pipeline.log

### Extra Challenge

- log both to console and file
- use different log levels: INFO, WARNING, ERROR

---

## Task 5 — Build a Retry Wrapper

### Goal
Create reusable retry logic.

### Input

A function that randomly fails or an API call to an unstable endpoint.

### Requirements

- wrap a function with retry behavior
- retry only on expected exceptions
- fail after a configured limit

### Expected Output

Several attempts followed by success or final error.

### Extra Challenge

- add exponential backoff
- log each retry attempt

---

## Task 6 — Raise Custom Exceptions

### Goal
Model business or validation failures clearly.

### Input

    record = {"id": 1, "name": "Alice"}
    required_fields = ["id", "name", "email"]

### Requirements

- define at least one custom exception
- raise it when validation fails
- handle it in the main script

### Expected Output

A controlled validation failure with a readable message.

### Extra Challenge

- create separate exceptions for config errors and data errors
- include record details in the exception message

---

## Task 7 — Add Structured Logging Fields

### Goal
Make logs more useful.

### Input

Any pipeline with steps:
- read
- validate
- transform
- write

### Requirements

- include event names or step names
- include file names or record counts
- keep log messages consistent

### Expected Output

Structured logs like:

    INFO | step=read | records=100
    INFO | step=transform | valid=95 invalid=5

### Extra Challenge

- add run_id to every log line
- include execution date in log messages

---

## Task 8 — Print an Execution Summary

### Goal
Summarize what happened during the run.

### Input

Use a script that processes a dataset with valid and invalid rows.

### Requirements

- total records read
- valid records processed
- invalid records skipped
- output file location

### Expected Output

A clear execution summary at the end of the run.

### Extra Challenge

- save the summary as JSON
- include duration and error count
