# Functions And Modules

This section introduces reusable code design for data engineering tasks.

The goal is not only to define helper functions.

The goal is to learn how to:

- isolate repeated logic
- keep helpers focused
- split code into meaningful modules
- decide when plain functions are enough
- recognize when a small class or decorator may be justified

## What Good Completion Looks Like

By the end of this block, you should be able to:

- write small reusable helpers
- move duplicate logic out of scripts
- split code across modules without confusion
- explain when a function is better than a class
- build one small decorator or closure without overengineering

## Task 1 — Create A Reusable Cleaning Function

### Goal

Write a function that standardizes strings.

### Input

```python
names = [" Alice ", "BOB", "charlie  ", ""]
```

### Requirements

Create a function:

`clean_name(value)`

- remove leading and trailing spaces
- convert text to lowercase
- return `None` for empty values

### Expected Output

```python
["alice", "bob", "charlie", None]
```

### Extra Challenge

- replace multiple internal spaces with a single space
- handle `None` input safely

## Task 2 — Extract Repeated Logic Into Functions

### Goal

Refactor duplicated code.

### Input

```python
cities = [" Warsaw ", "KRAKOW", " gdansk "]
countries = [" Poland ", "POLAND", " poland "]
```

### Requirements

- create one reusable function to clean text
- use it for both lists
- avoid duplicated logic

### Expected Output

```python
cleaned_cities = ["warsaw", "krakow", "gdansk"]
cleaned_countries = ["poland", "poland", "poland"]
```

### Extra Challenge

- move the helper into a separate module
- reuse it in another script

## Task 3 — Build A Type Conversion Helper

### Goal

Safely convert values to integers.

### Input

```python
values = ["10", "25", "invalid", "7"]
```

### Requirements

Create a function:

`safe_to_int(value)`

- return integer if conversion works
- return `None` if conversion fails

### Expected Output

```python
[10, 25, None, 7]
```

### Extra Challenge

- add support for float conversion
- allow passing a custom default value

## Task 4 — Validate Required Fields

### Goal

Write a function that checks required keys.

### Input

```python
record = {"id": 1, "name": "Alice"}
required = ["id", "name", "email"]
```

### Requirements

- accept a record and a list of required fields
- return missing fields
- treat `None` and empty strings as missing when appropriate

### Expected Output

```python
["email"]
```

### Extra Challenge

- return both validation status and missing fields
- validate a list of records, not just one

## Task 5 — Create A Date Formatting Module

### Goal

Separate date utilities into a reusable module.

### Input

```python
date_strings = ["2025-01-01", "2025-03-15", "2025-12-31"]
```

### Requirements

- create helper functions for current timestamp
- convert date strings into another format
- keep date helpers in a dedicated module

### Expected Output

Example:

```python
["01/01/2025", "15/03/2025", "31/12/2025"]
```

### Extra Challenge

- add a function for generating timestamped filenames
- support datetime strings with time

## Task 6 — Split A Script Into Modules

### Goal

Break one large script into multiple files.

### Input

Use any script that:

- reads data
- transforms it
- prints or writes output

### Requirements

- create `main.py`
- create at least one helper module
- import functions properly
- keep the entrypoint thin

### Expected Output

A working multi-file Python script.

### Extra Challenge

- split into `reader.py`, `processor.py`, and `writer.py`
- add a `config_loader.py` module

## Task 7 — Build A File Reader Utility

### Goal

Create reusable functions for reading files.

### Input

```python
csv_file = "users.csv"
json_file = "users.json"
```

### Requirements

- add a CSV reader function
- add a JSON reader function
- handle missing file errors intentionally

### Expected Output

Functions that return parsed file contents.

### Extra Challenge

- log file read operations
- add support for reading all files from a folder

## Task 8 — Create A Config Loader Function

### Goal

Build a reusable function for loading configuration.

### Input

Example JSON config:

```json
{
    "api_url": "https://example.com",
    "timeout": 30
}
```

### Requirements

- read JSON or YAML config
- return parsed content
- handle invalid config format

### Expected Output

A Python dictionary with config values.

### Extra Challenge

- support environment variable overrides
- validate required config keys

## Task 9 — Build A Small Decorator

### Goal

Understand decorators as reusable wrappers around function calls.

### Input

Any small function such as `normalize_email()` or `load_records()`.

### Requirements

- create one decorator that logs or times a function call
- use `functools.wraps`
- apply it to one function

### Expected Output

A decorated function that keeps its original behavior while adding cross-cutting behavior.

### Extra Challenge

- make the decorator configurable
- explain why this behavior belongs in a decorator and not inside the function body

## Task 10 — Build A Closure

### Goal

Understand small configurable behavior without introducing a class.

### Input

Example idea:

- a status normalizer with a configurable default value

### Requirements

- create an outer function that returns an inner function
- let the inner function remember one configuration value
- use the returned function in practice

### Expected Output

A small closure that keeps one useful value from its creation scope.

### Extra Challenge

- build a configurable field validator with a closure
- explain when a closure is simpler than a class

## Task 11 — Decide Between A Function And A Class

### Goal

Practice design judgment, not only syntax.

### Input

Two cases:

- normalize one email string
- call one API repeatedly using the same base URL, token, and timeout

### Requirements

- implement the email logic as a plain function
- implement the API logic either as a class or explain why it should be a class
- justify your choice briefly

### Expected Output

One stateless function and one stateful class-shaped design.

### Extra Challenge

- redesign an existing utility class into functions
- redesign an overloaded set of functions into one clearer class

## Task 12 — Use `*args` And `**kwargs` Intentionally

### Goal

Understand why `*args` and `**kwargs` appear so often in Python code.

### Input

Any small wrapper function such as a logger or timing helper.

### Requirements

- create one wrapper function that accepts `*args` and `**kwargs`
- forward them to an inner function
- explain why explicit parameters would be harder in this case

### Expected Output

A wrapper function that can call another function with flexible positional and keyword arguments.

### Extra Challenge

- combine this with a decorator
- print or log the received positional and keyword arguments before forwarding them

## Task 13 — Add A Small Data Contract

### Goal

Practice making record shapes more explicit.

### Input

Example record:

```python
{"id": 1, "name": "Alice", "email": "alice@example.com"}
```

### Requirements

- define either a `TypedDict` or a `dataclass` for one record or config shape
- update one helper function to use that type
- explain what became clearer after adding the type

### Expected Output

One typed record or config object plus one function signature that uses it.

### Extra Challenge

- define separate raw and processed record shapes
- explain why the two contracts are not identical
