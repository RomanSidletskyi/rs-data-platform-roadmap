# Typing And Data Contracts

## Why This File Exists

In data engineering, many bugs are really contract bugs.

Examples:

- one function expects a list of records but receives one record
- one record is missing a required key
- one field that should be numeric arrives as a string
- raw, validated, and processed layers use different shapes without naming them clearly

Typing does not solve all of this, but it helps make assumptions visible.

## 1. What Typing Is Good For

Typing is useful because it makes interfaces clearer.

It helps answer:

- what does this function accept
- what does it return
- what shape should this data have

## 2. Start With Function Type Hints

```python
def normalize_email(email: str) -> str:
    return email.strip().lower()
```

```python
def split_valid_and_invalid(records: list[dict]) -> tuple[list[dict], list[dict]]:
    ...
```

This is already better than untyped helpers.

## 3. Where Basic Type Hints Help Most

Use them early for:

- input function parameters
- return values
- collections such as `list[dict]`
- config-like dictionaries

## 4. `TypedDict` For Dictionary-Like Records

Many data workflows use dictionaries heavily.

`TypedDict` helps when you want to keep dict-style access but make the expected keys explicit.

Example:

```python
from typing import TypedDict


class RawUserRecord(TypedDict):
    id: int
    name: str
    email: str
```

Now function signatures can be clearer:

```python
def normalize_user(record: RawUserRecord) -> RawUserRecord:
    return {
        "id": record["id"],
        "name": record["name"].strip(),
        "email": record["email"].strip().lower(),
    }
```

## 5. Why `TypedDict` Is Useful In Data Work

It is especially useful when:

- records are still dictionaries
- keys matter a lot
- you want lighter structure than a full class

## 6. `dataclass` For Related Structured Values

`dataclass` is useful when values belong together and attribute access is clearer than loose dictionaries.

Example:

```python
from dataclasses import dataclass


@dataclass
class PipelinePaths:
    raw_dir: str
    processed_dir: str
    quarantine_dir: str
```

Why useful:

- small structured objects stay readable
- better than passing three unrelated path strings around

## 7. Data Contracts Across Pipeline Stages

One useful way to think is that each pipeline stage may have its own contract.

Example:

- `RawUserRecord`
- `ValidatedUserRecord`
- `ProcessedUserRow`

That helps the learner stop thinking of “record” as one vague concept.

## 8. Example Of Separate Shapes

```python
from typing import TypedDict


class RawUserRecord(TypedDict, total=False):
    id: int
    name: str
    email: str


class ProcessedUserRow(TypedDict):
    id: int
    email: str
```

This reflects a real pipeline fact:

- raw data may be incomplete
- processed data should usually be stricter

## 9. `pydantic` When Runtime Validation Matters

Type hints are mostly for clarity and tooling.

If the project needs stronger runtime validation, `pydantic` is often the next step.

Example:

```python
from pydantic import BaseModel, EmailStr


class UserModel(BaseModel):
    id: int
    name: str
    email: EmailStr
```

Why useful:

- validation errors are explicit
- schemas become easier to reason about

## 10. Do Not Over-Type Early Learning Code

Typing is helpful, but overusing it too early can make simple examples harder to read.

Good rule:

- add type hints where they clarify a boundary
- do not make every small exercise feel like a typing puzzle

## 11. Practical Methodology

For early Python data projects:

- start with function type hints
- introduce `TypedDict` when record keys matter
- introduce `dataclass` when structured grouped values matter
- introduce `pydantic` when runtime validation becomes important enough to justify the dependency

## 12. External Sources For Deeper Reading

Useful places to read more:

- https://docs.python.org/3/library/typing.html
- https://docs.python.org/3/library/dataclasses.html
- https://mypy.readthedocs.io/
- https://docs.pydantic.dev/

## Final Takeaway

Typing is most useful when it makes data shape and module boundaries easier to understand.

In data engineering, that often matters more than clever syntax.