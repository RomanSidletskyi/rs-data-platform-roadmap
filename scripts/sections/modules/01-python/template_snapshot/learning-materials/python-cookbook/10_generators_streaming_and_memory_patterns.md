# Generators, Streaming, And Memory Patterns

## Why This File Exists

Many beginner Python scripts read everything into memory at once.

That is often fine for tiny examples, but it becomes a weak habit if the learner never sees streaming patterns.

This file introduces the idea that not all data must be loaded eagerly.

## 1. What A Generator Is

A generator produces values one at a time instead of building the entire result immediately.

Example:

```python
def generate_ids(limit: int):
    for value in range(limit):
        yield value
```

## 2. Why Generators Matter

Generators help when:

- input is large
- records can be processed one by one
- memory use should stay lower
- the pipeline naturally fits a stream-like shape

## 3. `yield` Versus `return`

`return` finishes the function and sends back one result.

`yield` pauses the function and produces one value at a time.

## 4. Simple Record Streaming Example

```python
def iter_records(records: list[dict]):
    for record in records:
        if record.get("id") is not None:
            yield record
```

## 5. Generator Expressions

Generator expressions are like list comprehensions, but lazy.

```python
emails = (record["email"].strip().lower() for record in records if record.get("email"))
```

Why useful:

- avoids building an intermediate list when not needed

## 6. Reading Large Files Line By Line

One of the simplest streaming patterns is reading a file line by line.

```python
from pathlib import Path


with Path("application.log").open("r", encoding="utf-8") as file:
    for line in file:
        print(line.rstrip())
```

Why useful:

- the whole file does not need to be loaded into memory at once

## 7. JSON Lines And Streaming-Friendly Formats

JSON arrays often encourage loading everything at once.

JSON Lines (`.jsonl`) is often friendlier for streaming because each line is one JSON record.

Example:

```python
import json
from pathlib import Path


def iter_jsonl(file_path: Path):
    with file_path.open("r", encoding="utf-8") as file:
        for line in file:
            yield json.loads(line)
```

## 8. Pipeline Shape With Generators

Generators fit well into stage-based pipelines.

Example:

```python
def read_jsonl(file_path):
    ...


def validate_records(records):
    for record in records:
        if record.get("id") is not None:
            yield record


def normalize_records(records):
    for record in records:
        yield {
            "id": record["id"],
            "email": record["email"].strip().lower(),
        }
```

This shape is useful because each stage can process records lazily.

## 9. Chunk Processing

Sometimes the pipeline should not process one record at a time or all records at once.

Chunking is a middle ground.

Example:

```python
def chunked(records: list[dict], chunk_size: int):
    for start in range(0, len(records), chunk_size):
        yield records[start:start + chunk_size]
```

Why useful:

- batch APIs
- chunked writes
- controlled memory use

## 10. When Streaming Helps Most

Streaming helps most when:

- files are large
- processing is sequential
- not every record must be kept in memory
- output can be written progressively

## 11. When Streaming Is Not Automatically Better

Streaming is not always the best choice.

Sometimes a full in-memory list is simpler and perfectly fine.

Examples:

- tiny datasets
- logic that genuinely needs the full dataset at once
- teaching examples where readability matters more than optimization

## 12. Practical Methodology

Good rule:

- start simple for small examples
- introduce generators when data size or workflow shape makes lazy processing useful

Do not force streaming everywhere.

But do not ignore it forever either.

## 13. External Sources For Deeper Reading

Useful places to read more:

- https://docs.python.org/3/tutorial/classes.html
- https://docs.python.org/3/tutorial/classes.html#generators
- https://docs.python.org/3/library/itertools.html
- Fluent Python by Luciano Ramalho

## Final Takeaway

Generators are useful because they teach the learner that Python workflows do not always need to load everything eagerly.

That is an important mental step toward more realistic data processing.