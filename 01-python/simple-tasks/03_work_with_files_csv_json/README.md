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
