#!/bin/bash

set -e

MODE="${1:-}"

if [[ "$MODE" != "--basic" && "$MODE" != "--with-examples" ]]; then
  echo "Usage:"
  echo "  ./scripts/fill_python_simple_tasks.sh --basic"
  echo "  ./scripts/fill_python_simple_tasks.sh --with-examples"
  exit 1
fi

ROOT="01-python/simple-tasks"

mkdir -p \
  "$ROOT/01_variables_conditions_loops" \
  "$ROOT/02_functions_modules" \
  "$ROOT/03_work_with_files_csv_json" \
  "$ROOT/04_requests_and_api" \
  "$ROOT/05_error_handling_logging" \
  "$ROOT/06_virtualenv_and_project_setup" \
  "$ROOT/07_pandas_basics" \
  "$ROOT/08_data_engineering_python_tasks"

if [[ "$MODE" == "--basic" ]]; then

cat << 'EOF' > "$ROOT/01_variables_conditions_loops/README.md"
# Variables, Conditions, and Loops

This section covers the Python basics required for later data engineering tasks.

The goal is to become comfortable with core programming logic before moving to file processing, APIs, ETL scripts, and pipeline development.

## Skills Covered

- variables
- data types
- conditions
- loops
- list and dictionary operations
- basic record processing
- simple transformation logic

---

## Task 1 — Print Formatted Records

### Goal
Work with a list of dictionaries and print formatted output.

### Input
Example records:

records = [
    {"id": 1, "name": "Alice", "city": "Warsaw"},
    {"id": 2, "name": "Bob", "city": "Krakow"}
]

### Requirements

- iterate through the list
- print each record in a readable format
- use f-strings

---

## Task 2 — Filter Even and Odd Numbers

### Goal
Practice conditions and loops.

### Requirements

- create a list of numbers
- separate even and odd values into two different lists
- print both lists

### Extra Challenge

Also calculate the sum of even and odd numbers separately.

---

## Task 3 — Find Duplicate Values

### Goal
Learn how to detect repeated values in a dataset.

### Requirements

- use a list of integers or strings
- identify which values appear more than once
- print only unique duplicates

### Extra Challenge

Count how many times each duplicate appears.

---

## Task 4 — Count Unique Words

### Goal
Practice loops, conditions, and dictionary usage.

### Requirements

- take a text string
- split it into words
- count occurrences of each word
- print the number of unique words

### Extra Challenge

Print the top 5 most frequent words.

---

## Task 5 — Transaction Classification

### Goal
Simulate a simple business rule.

### Requirements

- create a list of transaction amounts
- classify each amount as low, medium, or high

### Suggested Rules

- low: less than 100
- medium: 100 to 999
- high: 1000 or more

---

## Task 6 — Clean Raw Event Strings

### Goal
Practice turning unstructured input into structured output.

### Input

events = [
    "login|user_1|success",
    "purchase|user_2|failed",
    "logout|user_1|success"
]

### Requirements

- split each string
- convert it into a dictionary
- store results in a new list

### Expected Output

[
    {"event_type": "login", "user_id": "user_1", "status": "success"}
]

---

## Task 7 — Count Records by Status

### Goal
Build simple aggregation logic.

### Requirements

- use a list of dictionaries with a status field
- count how many records belong to each status
- print the summary

### Extra Challenge

Sort the result by frequency.

---

## Task 8 — Basic Data Quality Check

### Goal
Introduce validation logic early.

### Requirements

- use a list of records
- check whether required fields exist
- print invalid records separately

### Required Fields

- id
- name
- email

---

## Completion Criteria

You should be able to:

- write loops and conditions confidently
- process lists and dictionaries
- apply simple transformation logic
- create small validation checks
- think about records as data objects, not just Python variables
EOF

cat << 'EOF' > "$ROOT/02_functions_modules/README.md"
# Functions and Modules

This section introduces reusable code design for data engineering tasks.

The goal is to stop writing everything in one script and start organizing logic into functions and modules.

## Skills Covered

- defining functions
- using parameters and return values
- splitting code into modules
- organizing reusable helpers
- building cleaner scripts
- basic project modularity

---

## Task 1 — Create a Reusable Cleaning Function

### Goal
Write a function that standardizes strings.

### Requirements

- remove leading and trailing spaces
- convert text to lowercase
- replace empty strings with `None`

---

## Task 2 — Extract Repeated Logic Into Functions

### Goal
Refactor duplicated code.

### Requirements

- take a script with repeated logic
- extract reusable pieces into functions
- improve readability

---

## Task 3 — Build a Type Conversion Helper

### Goal
Safely convert values to `int`, `float`, or `str`.

### Requirements

- create a reusable function
- return a default value when conversion fails
- test with several input values

---

## Task 4 — Validate Required Fields

### Goal
Write a function that checks if required keys exist in a dictionary.

### Requirements

- accept a record and a list of required fields
- return `True` or `False`
- optionally return missing fields

---

## Task 5 — Create a Date Formatting Module

### Goal
Separate date utilities into a standalone module.

### Requirements

- create helper functions for current timestamp
- format date strings
- reuse the module in another script

---

## Task 6 — Split a Script Into Modules

### Goal
Break one large script into multiple files.

### Requirements

- create `main.py`
- create at least one helper module
- import functions properly

---

## Task 7 — Build a File Reader Utility

### Goal
Create reusable functions for reading files.

### Requirements

- add CSV reader function
- add JSON reader function
- handle missing file errors

---

## Task 8 — Create a Config Loader Function

### Goal
Build a reusable function for loading configuration.

### Requirements

- read JSON or YAML config
- return parsed content
- handle invalid config format

---

## Completion Criteria

You should be able to:

- write reusable functions
- organize code into modules
- reduce duplication
- structure scripts in a more maintainable way
EOF

cat << 'EOF' > "$ROOT/03_work_with_files_csv_json/README.md"
# Working with Files, CSV, and JSON

This section focuses on core file handling skills used in data pipelines.

The goal is to learn how to read, write, transform, and combine structured data files.

## Skills Covered

- reading text files
- reading and writing CSV
- reading and writing JSON
- combining files
- filtering invalid rows
- basic normalization

---

## Task 1 — Read a CSV File

### Goal
Read a CSV file and print selected columns.

### Requirements

- use Python standard library or pandas
- display only chosen fields
- handle missing file errors

---

## Task 2 — Convert CSV to JSON

### Goal
Transform tabular data into JSON format.

### Requirements

- read a CSV file
- convert rows into a list of dictionaries
- save the result as JSON

---

## Task 3 — Convert JSON to CSV

### Goal
Convert JSON records into a tabular file.

### Requirements

- read a JSON array of objects
- write a CSV file
- preserve field names as headers

---

## Task 4 — Merge Two CSV Files by Key

### Goal
Combine datasets using a shared identifier.

### Requirements

- read two CSV files
- merge records by key
- save the result as a new file

---

## Task 5 — Remove Invalid Rows

### Goal
Practice basic data cleaning.

### Requirements

- identify rows with missing required values
- exclude invalid rows
- save cleaned output

---

## Task 6 — Flatten Nested JSON

### Goal
Transform nested JSON into flat rows.

### Requirements

- use nested JSON objects
- extract selected nested fields
- create a flat output structure

---

## Task 7 — Combine Multiple JSON Files

### Goal
Build a mini ingestion workflow.

### Requirements

- read all JSON files from a folder
- combine them into one dataset
- save merged output

---

## Task 8 — Archive Processed Files

### Goal
Simulate file lifecycle management.

### Requirements

- move processed files into an archive folder
- avoid overwriting existing files
- log what was archived

---

## Completion Criteria

You should be able to:

- read and write CSV and JSON files
- transform files between formats
- clean invalid records
- combine multiple files into a single dataset
EOF

cat << 'EOF' > "$ROOT/04_requests_and_api/README.md"
# Requests and API Work

This section introduces API data collection, which is a core part of many ingestion pipelines.

The goal is to learn how to call APIs, process responses, and store results reliably.

## Skills Covered

- making HTTP requests
- working with JSON responses
- handling status codes
- using query parameters
- retrying failed calls
- working with paginated APIs

---

## Task 1 — Fetch Data From a Public API

### Goal
Call a public API and save the response.

### Requirements

- use the `requests` library
- retrieve JSON data
- save the response to a file

---

## Task 2 — Extract Selected Fields

### Goal
Process only the fields you need.

### Requirements

- retrieve API data
- keep selected attributes only
- save processed results

---

## Task 3 — Add Query Parameters

### Goal
Learn how to filter API responses.

### Requirements

- send query parameters in the request
- verify the response changes
- document what each parameter does

---

## Task 4 — Handle Request Failures

### Goal
Make API scripts more robust.

### Requirements

- catch timeout errors
- catch connection errors
- print or log failure details

---

## Task 5 — Add Retry Logic

### Goal
Retry unstable API calls automatically.

### Requirements

- retry failed requests
- add delay between attempts
- stop after a fixed number of retries

---

## Task 6 — Work With Pagination

### Goal
Collect data from multi-page APIs.

### Requirements

- request multiple pages
- combine all results
- save the final merged dataset

---

## Task 7 — Save Daily Snapshots

### Goal
Simulate historical data collection.

### Requirements

- save each API run with execution date in the filename
- keep previous outputs
- avoid overwriting past snapshots

---

## Task 8 — Compare API Responses

### Goal
Detect data changes between runs.

### Requirements

- load two API snapshots
- compare records
- identify added, removed, or changed entries

---

## Completion Criteria

You should be able to:

- collect data from APIs
- work with JSON responses
- handle failures
- add retry logic
- store repeatable outputs for downstream processing
EOF

cat << 'EOF' > "$ROOT/05_error_handling_logging/README.md"
# Error Handling and Logging

This section focuses on making Python scripts safer and easier to debug.

The goal is to treat failures as expected engineering scenarios and record useful operational information.

## Skills Covered

- try/except handling
- custom exceptions
- pipeline logs
- warning and error messages
- execution summaries
- safer file and API processing

---

## Task 1 — Add Try/Except to a File Script

### Goal
Protect a file-processing script from crashing unexpectedly.

### Requirements

- catch missing file errors
- catch parsing errors
- show meaningful messages

---

## Task 2 — Log Pipeline Start and Finish

### Goal
Introduce execution logging.

### Requirements

- log pipeline start time
- log pipeline finish time
- log success status

---

## Task 3 — Log Invalid Records Separately

### Goal
Track bad data.

### Requirements

- identify invalid records
- write them to a dedicated log or file
- count how many invalid rows were found

---

## Task 4 — Save Errors to a Log File

### Goal
Persist operational information.

### Requirements

- configure a log file
- write warnings and errors to disk
- include timestamps

---

## Task 5 — Build a Retry Wrapper

### Goal
Create reusable retry logic.

### Requirements

- wrap a function with retry behavior
- retry only on expected exceptions
- fail after a configured limit

---

## Task 6 — Raise Custom Exceptions

### Goal
Model business or validation failures clearly.

### Requirements

- define at least one custom exception
- raise it when validation fails
- handle it in the main script

---

## Task 7 — Add Structured Logging Fields

### Goal
Make logs more useful.

### Requirements

- include event names or step names
- include file names or record counts
- keep log messages consistent

---

## Task 8 — Print an Execution Summary

### Goal
Summarize what happened during the run.

### Requirements

- total records read
- valid records processed
- invalid records skipped
- output file location

---

## Completion Criteria

You should be able to:

- write safer scripts
- log execution details clearly
- separate failures from normal flow
- diagnose issues faster
EOF

cat << 'EOF' > "$ROOT/06_virtualenv_and_project_setup/README.md"
# Virtual Environment and Project Setup

This section introduces clean Python project setup for reproducible development.

The goal is to structure projects in a way that is easy to run, share, and maintain.

## Skills Covered

- virtual environments
- dependency files
- project layout
- `.gitignore`
- environment variables
- setup instructions

---

## Task 1 — Create a Virtual Environment

### Goal
Prepare an isolated Python environment.

### Requirements

- create `.venv`
- activate it
- verify installed packages are local to the environment

---

## Task 2 — Create `requirements.txt`

### Goal
Track dependencies properly.

### Requirements

- install at least two packages
- export them to `requirements.txt`
- document installation steps

---

## Task 3 — Add `.gitignore`

### Goal
Keep repository clean.

### Requirements

- ignore `.venv`
- ignore cache files
- ignore local secrets and temporary outputs

---

## Task 4 — Organize a Small Project

### Goal
Use a cleaner folder structure.

### Requirements

- create `src/`, `data/`, and `tests/`
- move logic into `src/`
- keep data files outside source code

---

## Task 5 — Move Hardcoded Values Into Config

### Goal
Improve flexibility.

### Requirements

- remove hardcoded paths or URLs
- store them in config
- load them in the script

---

## Task 6 — Add Environment Variables

### Goal
Prepare for secrets and environment-specific settings.

### Requirements

- create `.env.example`
- read variables from `.env`
- document required environment values

---

## Task 7 — Add Setup Instructions to README

### Goal
Make the project easy to run.

### Requirements

- describe environment creation
- describe dependency installation
- describe how to run the script

---

## Task 8 — Create a CLI Entry Script

### Goal
Make project execution clearer.

### Requirements

- create `main.py`
- run the project from one entry point
- pass simple arguments if possible

---

## Completion Criteria

You should be able to:

- create reproducible Python setups
- structure a small project cleanly
- manage dependencies and config
- document how to run your work
EOF

cat << 'EOF' > "$ROOT/07_pandas_basics/README.md"
# Pandas Basics

This section focuses on pandas as a practical tool for small and medium data transformations.

The goal is to learn the operations most often used before moving to larger-scale tools like Spark.

## Skills Covered

- loading datasets
- filtering rows
- selecting columns
- handling nulls
- aggregating data
- joining datasets
- date processing
- deduplication

---

## Task 1 — Load CSV Into a DataFrame

### Goal
Read tabular data with pandas.

### Requirements

- load a CSV file
- inspect columns and row count
- print sample records

---

## Task 2 — Filter Rows and Select Columns

### Goal
Practice slicing data.

### Requirements

- filter rows based on a condition
- keep only selected columns
- save the result

---

## Task 3 — Handle Null Values

### Goal
Work with incomplete data.

### Requirements

- identify nulls
- fill or remove missing values
- explain why you chose that approach

---

## Task 4 — Group and Aggregate

### Goal
Build simple summaries.

### Requirements

- group data by a category
- calculate count, sum, or average
- sort results

---

## Task 5 — Join Two DataFrames

### Goal
Combine related datasets.

### Requirements

- join two tables by key
- use left or inner join
- inspect unmatched rows

---

## Task 6 — Parse Date Columns

### Goal
Prepare time-based data.

### Requirements

- convert strings to datetime
- extract year, month, or day
- filter by date range

---

## Task 7 — Remove Duplicates

### Goal
Practice data quality basics.

### Requirements

- identify duplicate rows
- remove duplicates
- compare row counts before and after

---

## Task 8 — Build a Small Summary Report

### Goal
Create a useful processed output.

### Requirements

- combine filtering, aggregation, and sorting
- generate a compact summary dataset
- save final results to CSV

---

## Completion Criteria

You should be able to:

- work comfortably with DataFrames
- transform tabular datasets
- build simple analytical summaries
- prepare cleaned outputs for later pipeline stages
EOF

cat << 'EOF' > "$ROOT/08_data_engineering_python_tasks/README.md"
# Data Engineering Python Tasks

This section connects Python fundamentals with real data engineering workflows.

The goal is to practice small pipeline patterns used in ingestion, validation, and batch processing.

## Skills Covered

- ETL flow design
- schema validation
- raw and processed zones
- incremental processing
- pipeline metadata
- idempotent behavior
- quarantine handling

---

## Task 1 — Build a Mini ETL Script

### Goal
Create a simple extract-transform-load flow.

### Requirements

- read input data
- transform records
- save processed output
- log what happened

---

## Task 2 — Validate JSON Schema

### Goal
Check incoming data structure before processing.

### Requirements

- define required keys
- validate each record
- separate valid and invalid data

---

## Task 3 — Create Raw and Processed Folders

### Goal
Introduce data zone thinking.

### Requirements

- store original data in `raw`
- store cleaned data in `processed`
- keep both outputs after the run

---

## Task 4 — Process Only New Files

### Goal
Simulate incremental ingestion.

### Requirements

- read files from an input folder
- skip files already processed
- keep track of processed file names

---

## Task 5 — Add Execution Metadata

### Goal
Improve observability of outputs.

### Requirements

- include execution date
- include source file or run id
- save metadata in output or side file

---

## Task 6 — Build a Pipeline Run Report

### Goal
Summarize execution results.

### Requirements

- total input files
- total records
- valid records
- invalid records
- output locations

---

## Task 7 — Save Bad Records to Quarantine

### Goal
Handle data quality issues safely.

### Requirements

- identify invalid rows
- write them to a separate file
- keep the main output clean

---

## Task 8 — Make Processing Idempotent

### Goal
Avoid duplicate output from repeated runs.

### Requirements

- rerun the same pipeline safely
- do not duplicate already processed results
- document how idempotency is enforced

---

## Completion Criteria

You should be able to:

- build simple ETL-style Python scripts
- validate and separate data properly
- think in terms of raw, processed, and quarantine zones
- implement small but realistic pipeline behaviors
EOF

echo "Python simple tasks created successfully in basic mode."
exit 0
fi

cat << 'EOF' > "$ROOT/01_variables_conditions_loops/README.md"
# Variables, Conditions, and Loops

This section covers the Python basics required for later data engineering tasks.

---

## Task 1 — Print Formatted Records

### Goal
Practice iterating through structured records.

### Input

    records = [
        {"id": 1, "name": "Alice", "city": "Warsaw"},
        {"id": 2, "name": "Bob", "city": "Krakow"},
        {"id": 3, "name": "Charlie", "city": "Gdansk"}
    ]

### Requirements

- iterate through the list
- print each record using an f-string
- format output like `User 1: Alice from Warsaw`

### Expected Output

    User 1: Alice from Warsaw
    User 2: Bob from Krakow
    User 3: Charlie from Gdansk

### Extra Challenge

- sort the records by city before printing
- print the total number of records

---

## Task 2 — Filter Even and Odd Numbers

### Goal
Practice loops and conditional logic.

### Input

    numbers = [12, 7, 3, 20, 18, 5, 2, 9]

### Requirements

- create a list of even numbers
- create a list of odd numbers
- print both lists

### Expected Output

    even_numbers = [12, 20, 18, 2]
    odd_numbers = [7, 3, 5, 9]

### Extra Challenge

- calculate the sum of even numbers
- calculate the sum of odd numbers

---

## Task 3 — Find Duplicate Values

### Goal
Detect duplicate values in a dataset.

### Input

    ids = [101, 203, 101, 405, 203, 509, 600, 405]

### Requirements

- identify values that appear more than once
- print duplicates only once

### Expected Output

    [101, 203, 405]

### Extra Challenge

Return a dictionary with counts:

    {
        101: 2,
        203: 2,
        405: 2
    }

---

## Task 4 — Count Unique Words

### Goal
Practice string processing and dictionary counting.

### Input

    text = "data engineering pipelines process data pipelines transform data"

### Requirements

- split text into words
- count occurrences of each word
- store results in a dictionary

### Expected Output

    {
        "data": 3,
        "engineering": 1,
        "pipelines": 2,
        "process": 1,
        "transform": 1
    }

### Extra Challenge

- print the top 3 most frequent words
- sort the result alphabetically by word

---

## Task 5 — Transaction Classification

### Goal
Simulate simple business classification rules.

### Input

    transactions = [50, 120, 980, 1500, 300, 20, 75]

### Requirements

Classify each transaction as:

- low
- medium
- high

Rules:

- low < 100
- medium 100-999
- high >= 1000

### Expected Output

    [
        {"amount": 50, "category": "low"},
        {"amount": 120, "category": "medium"},
        {"amount": 980, "category": "medium"},
        {"amount": 1500, "category": "high"},
        {"amount": 300, "category": "medium"},
        {"amount": 20, "category": "low"},
        {"amount": 75, "category": "low"}
    ]

### Extra Challenge

- count how many transactions belong to each category
- calculate the total amount by category

---

## Task 6 — Clean Raw Event Strings

### Goal
Transform unstructured strings into structured data.

### Input

    events = [
        "login|user_1|success",
        "purchase|user_2|failed",
        "logout|user_1|success",
        "login|user_3|success"
    ]

### Requirements

- split each string using "|"
- convert it into a dictionary
- store the result in a list

### Expected Output

    [
        {"event_type": "login", "user_id": "user_1", "status": "success"},
        {"event_type": "purchase", "user_id": "user_2", "status": "failed"},
        {"event_type": "logout", "user_id": "user_1", "status": "success"},
        {"event_type": "login", "user_id": "user_3", "status": "success"}
    ]

### Extra Challenge

- count how many events each user generated
- count how many successful and failed events exist

---

## Task 7 — Count Records by Status

### Goal
Build simple aggregation logic.

### Input

    records = [
        {"id": 1, "status": "success"},
        {"id": 2, "status": "failed"},
        {"id": 3, "status": "success"},
        {"id": 4, "status": "pending"},
        {"id": 5, "status": "failed"},
        {"id": 6, "status": "success"}
    ]

### Requirements

- count how many records belong to each status
- store results in a dictionary

### Expected Output

    {
        "success": 3,
        "failed": 2,
        "pending": 1
    }

### Extra Challenge

- sort the result by frequency
- print the most common status
- calculate the total number of records

---

## Task 8 — Basic Data Quality Check

### Goal
Introduce validation logic.

### Input

    records = [
        {"id": 1, "name": "Alice", "email": "alice@example.com"},
        {"id": 2, "name": "Bob"},
        {"id": 3, "email": "charlie@example.com"},
        {"name": "David", "email": "david@example.com"}
    ]

### Requirements

Required fields:

- id
- name
- email

- separate valid and invalid records

### Expected Output

Valid records:

    [
        {"id": 1, "name": "Alice", "email": "alice@example.com"}
    ]

Invalid records:

    [
        {"id": 2, "name": "Bob"},
        {"id": 3, "email": "charlie@example.com"},
        {"name": "David", "email": "david@example.com"}
    ]

### Extra Challenge

- print which fields are missing for each invalid record
- count valid and invalid records
EOF

cat << 'EOF' > "$ROOT/02_functions_modules/README.md"
# Functions and Modules

This section introduces reusable code design for data engineering tasks.

---

## Task 1 — Create a Reusable Cleaning Function

### Goal
Write a function that standardizes strings.

### Input

    names = [" Alice ", "BOB", "charlie  ", ""]

### Requirements

Create a function:

    clean_name(value)

- remove leading and trailing spaces
- convert text to lowercase
- return `None` for empty values

### Expected Output

    ["alice", "bob", "charlie", None]

### Extra Challenge

- also replace multiple internal spaces with a single space
- handle `None` input safely

---

## Task 2 — Extract Repeated Logic Into Functions

### Goal
Refactor duplicated code.

### Input

    cities = [" Warsaw ", "KRAKOW", " gdansk "]
    countries = [" Poland ", "POLAND", " poland "]

### Requirements

- create one reusable function to clean text
- use it for both lists
- avoid duplicated logic

### Expected Output

    cleaned_cities = ["warsaw", "krakow", "gdansk"]
    cleaned_countries = ["poland", "poland", "poland"]

### Extra Challenge

- move the helper into a separate module
- reuse it in another script

---

## Task 3 — Build a Type Conversion Helper

### Goal
Safely convert values to integers.

### Input

    values = ["10", "25", "invalid", "7"]

### Requirements

Create a function:

    safe_to_int(value)

- return integer if conversion works
- return `None` if conversion fails

### Expected Output

    [10, 25, None, 7]

### Extra Challenge

- add support for float conversion
- allow passing a custom default value

---

## Task 4 — Validate Required Fields

### Goal
Write a function that checks required keys.

### Input

    record = {"id": 1, "name": "Alice"}
    required = ["id", "name", "email"]

### Requirements

- accept a record and a list of required fields
- return missing fields

### Expected Output

    ["email"]

### Extra Challenge

- return both validation status and missing fields
- validate a list of records, not just one

---

## Task 5 — Create a Date Formatting Module

### Goal
Separate date utilities into a reusable module.

### Input

    date_strings = ["2025-01-01", "2025-03-15", "2025-12-31"]

### Requirements

- create helper functions for current timestamp
- convert date strings into another format

### Expected Output

Example:

    ["01/01/2025", "15/03/2025", "31/12/2025"]

### Extra Challenge

- add a function for generating timestamped filenames
- support datetime strings with time

---

## Task 6 — Split a Script Into Modules

### Goal
Break one large script into multiple files.

### Input

Use any script that:
- reads data
- transforms it
- prints output

### Requirements

- create `main.py`
- create at least one helper module
- import functions properly

### Expected Output

A working multi-file Python script.

### Extra Challenge

- split into `reader.py`, `processor.py`, and `writer.py`
- add a config loader module

---

## Task 7 — Build a File Reader Utility

### Goal
Create reusable functions for reading files.

### Input

    csv_file = "users.csv"
    json_file = "users.json"

### Requirements

- add a CSV reader function
- add a JSON reader function
- handle missing file errors

### Expected Output

Functions that return parsed file contents.

### Extra Challenge

- log file read operations
- add support for reading all files from a folder

---

## Task 8 — Create a Config Loader Function

### Goal
Build a reusable function for loading configuration.

### Input

Example JSON config:

    {
        "api_url": "https://example.com",
        "timeout": 30
    }

### Requirements

- read JSON or YAML config
- return parsed content
- handle invalid config format

### Expected Output

A Python dictionary with config values.

### Extra Challenge

- support environment variable overrides
- validate required config keys
EOF

cat << 'EOF' > "$ROOT/03_work_with_files_csv_json/README.md"
# Working with Files, CSV, and JSON

This section focuses on core file handling skills used in data pipelines.

---

## Task 1 — Read a CSV File

### Goal
Read a CSV file and print selected columns.

### Input

    users.csv

    id,name,city
    1,Alice,Warsaw
    2,Bob,Krakow
    3,Charlie,Gdansk

### Requirements

- read the CSV file
- print only `name` and `city`

### Expected Output

    Alice - Warsaw
    Bob - Krakow
    Charlie - Gdansk

### Extra Challenge

- skip the header manually
- count total rows

---

## Task 2 — Convert CSV to JSON

### Goal
Transform tabular data into JSON format.

### Input

    users.csv

    id,name,city
    1,Alice,Warsaw
    2,Bob,Krakow
    3,Charlie,Gdansk

### Requirements

- read a CSV file
- convert rows into a list of dictionaries
- save the result as JSON

### Expected Output

    [
        {"id": "1", "name": "Alice", "city": "Warsaw"},
        {"id": "2", "name": "Bob", "city": "Krakow"},
        {"id": "3", "name": "Charlie", "city": "Gdansk"}
    ]

### Extra Challenge

- convert `id` to integer
- pretty-print JSON with indentation

---

## Task 3 — Convert JSON to CSV

### Goal
Convert JSON records into a tabular file.

### Input

    [
        {"id": 1, "name": "Alice"},
        {"id": 2, "name": "Bob"}
    ]

### Requirements

- read a JSON array of objects
- write a CSV file
- preserve field names as headers

### Expected Output

    id,name
    1,Alice
    2,Bob

### Extra Challenge

- add support for missing fields
- choose the output field order manually

---

## Task 4 — Merge Two CSV Files by Key

### Goal
Combine datasets using a shared identifier.

### Input

    users.csv
    id,name
    1,Alice
    2,Bob
    3,Charlie

    cities.csv
    id,city
    1,Warsaw
    2,Krakow
    3,Gdansk

### Requirements

- read both CSV files
- merge records by `id`
- save the result

### Expected Output

    [
        {"id": "1", "name": "Alice", "city": "Warsaw"},
        {"id": "2", "name": "Bob", "city": "Krakow"},
        {"id": "3", "name": "Charlie", "city": "Gdansk"}
    ]

### Extra Challenge

- handle rows that exist in one file but not the other
- write unmatched rows to a separate file

---

## Task 5 — Remove Invalid Rows

### Goal
Practice basic data cleaning.

### Input

    users.csv
    id,name,email
    1,Alice,alice@example.com
    2,Bob,
    3,,charlie@example.com
    4,David,david@example.com

### Requirements

- identify rows with missing required values
- exclude invalid rows
- save cleaned output

### Expected Output

Valid rows:

    [
        {"id": "1", "name": "Alice", "email": "alice@example.com"},
        {"id": "4", "name": "David", "email": "david@example.com"}
    ]

### Extra Challenge

- save invalid rows to a separate file
- count how many rows were removed

---

## Task 6 — Flatten Nested JSON

### Goal
Transform nested JSON into flat rows.

### Input

    [
        {
            "id": 1,
            "name": "Alice",
            "address": {"city": "Warsaw", "zip": "00-001"}
        },
        {
            "id": 2,
            "name": "Bob",
            "address": {"city": "Krakow", "zip": "30-001"}
        }
    ]

### Requirements

- extract selected nested fields
- create a flat output structure

### Expected Output

    [
        {"id": 1, "name": "Alice", "city": "Warsaw", "zip": "00-001"},
        {"id": 2, "name": "Bob", "city": "Krakow", "zip": "30-001"}
    ]

### Extra Challenge

- support nested objects with missing keys
- flatten one more nested level

---

## Task 7 — Combine Multiple JSON Files

### Goal
Build a mini ingestion workflow.

### Input

Folder contains:

    file_1.json
    file_2.json
    file_3.json

Each file contains:

    [
        {"id": 1, "name": "Alice"}
    ]

### Requirements

- read all JSON files from a folder
- combine them into one dataset
- save merged output

### Expected Output

One merged JSON or CSV file with all records.

### Extra Challenge

- skip invalid JSON files
- log processed file names

---

## Task 8 — Archive Processed Files

### Goal
Simulate file lifecycle management.

### Input

Folder:

    input/
    archive/

### Requirements

- move processed files into an archive folder
- avoid overwriting existing files
- log what was archived

### Expected Output

Files moved from `input/` to `archive/`.

### Extra Challenge

- append timestamp to archived filenames
- archive only files older than a chosen threshold
EOF

cat << 'EOF' > "$ROOT/04_requests_and_api/README.md"
# Requests and API Work

This section introduces API data collection for ingestion pipelines.

---

## Task 1 — Fetch Data From a Public API

### Goal
Call a public API and save the response.

### Input

    https://jsonplaceholder.typicode.com/users

### Requirements

- use the `requests` library
- retrieve JSON data
- save the response to a file

### Expected Output

A JSON file containing user records.

### Extra Challenge

- print the number of records returned
- save the response with a timestamped filename

---

## Task 2 — Extract Selected Fields

### Goal
Process only the fields you need.

### Input

Use this API:

    https://jsonplaceholder.typicode.com/users

Keep fields:

- id
- name
- email

### Requirements

- retrieve API data
- keep selected attributes only
- save processed results

### Expected Output

    [
        {"id": 1, "name": "Leanne Graham", "email": "Sincere@april.biz"}
    ]

### Extra Challenge

- extract nested field `address.city`
- convert output to CSV

---

## Task 3 — Add Query Parameters

### Goal
Learn how to filter API responses.

### Input

    https://jsonplaceholder.typicode.com/comments?postId=1

### Requirements

- send query parameters in the request
- verify that the response changes
- document what each parameter does

### Expected Output

A filtered API response for one post.

### Extra Challenge

- make query parameters configurable
- compare results for two different parameter values

---

## Task 4 — Handle Request Failures

### Goal
Make API scripts more robust.

### Input

Use:
- one valid API URL
- one invalid API URL

### Requirements

- catch timeout errors
- catch connection errors
- print or log failure details

### Expected Output

Readable error messages without crashing unexpectedly.

### Extra Challenge

- handle non-200 status codes separately
- write failures to a log file

---

## Task 5 — Add Retry Logic

### Goal
Retry unstable API calls automatically.

### Input

Use any API URL and simulate failure with:
- wrong domain
- short timeout

### Requirements

- retry failed requests
- add delay between attempts
- stop after a fixed number of retries

### Expected Output

Several retry attempts followed by success or final failure message.

### Extra Challenge

- make retries configurable
- log attempt number and wait time

---

## Task 6 — Work With Pagination

### Goal
Collect data from multi-page APIs.

### Input

Use an API that supports pagination, or simulate pages with multiple URLs.

### Requirements

- request multiple pages
- combine all results
- save the final merged dataset

### Expected Output

A single combined output file.

### Extra Challenge

- stop automatically when no more pages exist
- count total records across all pages

---

## Task 7 — Save Daily Snapshots

### Goal
Simulate historical data collection.

### Input

Any public API response saved daily.

### Requirements

- save each API run with execution date in the filename
- keep previous outputs
- avoid overwriting past snapshots

### Expected Output

Files like:

    users_2025-03-11.json
    users_2025-03-12.json

### Extra Challenge

- store snapshots in date-based folders
- compare today's file with the previous snapshot

---

## Task 8 — Compare API Responses

### Goal
Detect data changes between runs.

### Input

Two JSON files:

    users_day_1.json
    users_day_2.json

### Requirements

- load two API snapshots
- compare records
- identify added, removed, or changed entries

### Expected Output

A summary of differences between the two files.

### Extra Challenge

- output the diff as JSON
- compare only selected fields
EOF

cat << 'EOF' > "$ROOT/05_error_handling_logging/README.md"
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
EOF

cat << 'EOF' > "$ROOT/06_virtualenv_and_project_setup/README.md"
# Virtual Environment and Project Setup

This section introduces clean Python project setup.

---

## Task 1 — Create a Virtual Environment

### Goal
Prepare an isolated Python environment.

### Input

Use the current project folder.

### Requirements

- create `.venv`
- activate it
- verify installed packages are local to the environment

### Expected Output

A working local virtual environment.

### Extra Challenge

- document activation steps for different shells
- add `.venv` to `.gitignore`

---

## Task 2 — Create `requirements.txt`

### Goal
Track dependencies properly.

### Input

Install at least:

- requests
- pyyaml

### Requirements

- install packages
- export them to `requirements.txt`
- document installation steps

### Expected Output

A `requirements.txt` file with project dependencies.

### Extra Challenge

- pin package versions
- add comments in README explaining each dependency

---

## Task 3 — Add `.gitignore`

### Goal
Keep repository clean.

### Input

A Python project with:
- `.venv`
- `__pycache__`
- `.env`
- log files

### Requirements

- ignore `.venv`
- ignore cache files
- ignore local secrets and temporary outputs

### Expected Output

A clean `.gitignore` file.

### Extra Challenge

- add ignores for OS-specific files
- add ignores for notebook checkpoints

---

## Task 4 — Organize a Small Project

### Goal
Use a cleaner folder structure.

### Input

A single-file script.

### Requirements

- create `src/`, `data/`, and `tests/`
- move logic into `src/`
- keep data files outside source code

### Expected Output

A project with a cleaner engineering-friendly layout.

### Extra Challenge

- add `config/` and `logs/` folders
- split one script into multiple modules

---

## Task 5 — Move Hardcoded Values Into Config

### Goal
Improve flexibility.

### Input

A script with hardcoded:
- file paths
- API URL
- timeout value

### Requirements

- remove hardcoded paths or URLs
- store them in config
- load them in the script

### Expected Output

Config-driven values used by the script.

### Extra Challenge

- support both YAML and JSON config
- validate config keys on startup

---

## Task 6 — Add Environment Variables

### Goal
Prepare for secrets and environment-specific settings.

### Input

Variables such as:

- ENV=dev
- API_TOKEN=sample_token
- LOG_LEVEL=INFO

### Requirements

- create `.env.example`
- read variables from `.env`
- document required environment values

### Expected Output

A script that loads environment-based settings.

### Extra Challenge

- use environment variables to override config values
- fail early if required variables are missing

---

## Task 7 — Add Setup Instructions to README

### Goal
Make the project easy to run.

### Input

Any small Python project.

### Requirements

- describe environment creation
- describe dependency installation
- describe how to run the script

### Expected Output

A clear README setup section.

### Extra Challenge

- add troubleshooting notes
- add example command output

---

## Task 8 — Create a CLI Entry Script

### Goal
Make project execution clearer.

### Input

Any project with multiple helper modules.

### Requirements

- create `main.py`
- run the project from one entry point
- pass simple arguments if possible

### Expected Output

A single script that starts the application.

### Extra Challenge

- add `--input` and `--output` arguments
- validate CLI parameters before execution
EOF

cat << 'EOF' > "$ROOT/07_pandas_basics/README.md"
# Pandas Basics

This section focuses on pandas for small and medium data transformations.

---

## Task 1 — Load CSV Into a DataFrame

### Goal
Read tabular data with pandas.

### Input

    sales.csv

    id,amount,category
    1,100,A
    2,200,B
    3,150,A
    4,300,C

### Requirements

- load the CSV file
- inspect columns and row count
- print sample records

### Expected Output

A DataFrame with 4 rows and 3 columns.

### Extra Challenge

- print data types
- print summary statistics

---

## Task 2 — Filter Rows and Select Columns

### Goal
Practice slicing data.

### Input

Use the same `sales.csv`.

### Requirements

- filter rows where `amount > 150`
- keep only `id` and `amount`

### Expected Output

Rows for ids 2 and 4 with selected columns.

### Extra Challenge

- save filtered output to CSV
- sort by amount descending

---

## Task 3 — Handle Null Values

### Goal
Work with incomplete data.

### Input

    users.csv

    id,name,email
    1,Alice,alice@example.com
    2,Bob,
    3,,charlie@example.com
    4,David,david@example.com

### Requirements

- identify nulls
- fill or remove missing values
- explain your approach

### Expected Output

A cleaned DataFrame with null handling applied.

### Extra Challenge

- create one version with dropped nulls
- create another version with filled nulls

---

## Task 4 — Group and Aggregate

### Goal
Build simple summaries.

### Input

    sales.csv

    id,amount,category
    1,100,A
    2,200,B
    3,150,A
    4,300,C
    5,120,A

### Requirements

- group by `category`
- calculate count and sum of `amount`
- sort results

### Expected Output

A grouped summary by category.

### Extra Challenge

- add average amount per category
- rename output columns clearly

---

## Task 5 — Join Two DataFrames

### Goal
Combine related datasets.

### Input

    users.csv
    id,name
    1,Alice
    2,Bob
    3,Charlie

    cities.csv
    id,city
    1,Warsaw
    2,Krakow
    4,Gdynia

### Requirements

- join two tables by `id`
- use left or inner join
- inspect unmatched rows

### Expected Output

A merged DataFrame.

### Extra Challenge

- show rows that did not match
- compare left join vs inner join results

---

## Task 6 — Parse Date Columns

### Goal
Prepare time-based data.

### Input

    events.csv

    id,event_date
    1,2025-01-01
    2,2025-02-15
    3,2025-03-10

### Requirements

- convert strings to datetime
- extract year and month
- filter by date range

### Expected Output

A DataFrame with parsed date columns.

### Extra Challenge

- add day of week
- group by month

---

## Task 7 — Remove Duplicates

### Goal
Practice data quality basics.

### Input

    users.csv

    id,name
    1,Alice
    2,Bob
    2,Bob
    3,Charlie
    3,Charlie

### Requirements

- identify duplicate rows
- remove duplicates
- compare row counts before and after

### Expected Output

A deduplicated DataFrame.

### Extra Challenge

- keep only the first duplicate
- report how many duplicates were removed

---

## Task 8 — Build a Small Summary Report

### Goal
Create a useful processed output.

### Input

Use any of the previous datasets.

### Requirements

- combine filtering, aggregation, and sorting
- generate a compact summary dataset
- save final results to CSV

### Expected Output

A CSV summary report.

### Extra Challenge

- save the report with a timestamped filename
- create two summary views from the same dataset
EOF

cat << 'EOF' > "$ROOT/08_data_engineering_python_tasks/README.md"
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
EOF

echo "Python simple tasks created successfully in with-examples mode."