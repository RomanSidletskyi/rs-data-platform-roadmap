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
