# Decorators, Closures, And Classes

## Why This File Exists

Many engineers do not write only plain top-level functions.

Real Python code often includes:

- functions inside functions
- closures
- decorators
- classes
- methods and stateful objects

These tools are useful, but they are also easy to misuse.

The goal of this file is to make them feel less mystical and more practical.

## 1. Functions Inside Functions

Python allows one function to define another.

This is useful when a helper is only relevant inside one outer function.

Example:

```python
def normalize_records(records: list[dict]) -> list[dict]:
    def normalize_email(email: str) -> str:
        return email.strip().lower()

    normalized = []
    for record in records:
        normalized.append(
            {
                "id": record["id"],
                "email": normalize_email(record["email"]),
            }
        )
    return normalized
```

Why this can be good:

- the helper stays close to its only usage
- the module namespace stays cleaner

Why this can be bad:

- if the inner helper becomes reusable, hiding it inside another function makes reuse harder

## 2. What A Closure Is

A closure is a function that remembers values from the scope where it was created.

Example:

```python
def build_status_normalizer(default_status: str):
    def normalize(value: str | None) -> str:
        if value is None:
            return default_status
        cleaned = value.strip().lower()
        return cleaned or default_status

    return normalize


normalize_status = build_status_normalizer("unknown")
print(normalize_status(" ACTIVE "))
print(normalize_status(None))
```

The inner function remembers `default_status`.

## 3. When Closures Are Useful

Closures are useful when you want a small configurable behavior without introducing a full class.

Examples:

- build a normalizer with one default value
- build a validator configured by a required field list
- build a filter function with one threshold

## 4. When Closures Are Not The Best Tool

Closures become harder to read when:

- too much state is hidden inside them
- many behaviors are combined
- debugging requires understanding several nested scopes

If the logic needs many moving parts, a plain function or class is often clearer.

## 5. What A Decorator Is

A decorator is a function that takes another function and returns a modified function.

In practice, decorators are usually used to wrap behavior around a function call.

Examples:

- logging before and after a call
- timing execution
- retrying a function
- validating input

## 6. A Simple Decorator Example

```python
from functools import wraps


def log_call(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        print(f"Calling {func.__name__}")
        result = func(*args, **kwargs)
        print(f"Finished {func.__name__}")
        return result

    return wrapper


@log_call
def normalize_email(email: str) -> str:
    return email.strip().lower()
```

## 7. Why `functools.wraps` Matters

Without `@wraps`, the wrapped function loses useful metadata like:

- original function name
- docstring

That hurts debugging and tooling.

## 8. Practical Decorator Use Cases

### Logging

```python
from functools import wraps
import time


def log_duration(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        started_at = time.perf_counter()
        result = func(*args, **kwargs)
        duration = time.perf_counter() - started_at
        print(f"{func.__name__} finished in {duration:.3f}s")
        return result

    return wrapper
```

### Retry

You can build retry behavior with decorators, although in real projects a library like `tenacity` is often cleaner.

### Validation Or Preconditions

Decorators can enforce simple preconditions, but they should not hide too much business logic.

## 9. When Decorators Help

Decorators help when the same cross-cutting behavior appears around many functions.

Examples:

- timing
- logging
- retry wrappers
- permission checks in other domains

This is useful because it removes repetition.

## 10. When Decorators Hurt

Decorators hurt when they hide behavior that is too important to stay invisible.

Examples:

- a decorator that mutates business data unexpectedly
- several stacked decorators that make execution order hard to understand
- decorators that catch and suppress errors silently

Rule of thumb:

- use decorators for cross-cutting behavior
- do not hide core business rules inside them

## 11. What A Class Is Good For

A class is useful when data and behavior belong together around one responsibility.

Examples:

- API client with base URL, token, and timeout
- config object with parsed settings
- state tracker for processed files
- record model with validation methods

## 12. A Good Class Example

```python
import requests


class UsersApiClient:
    def __init__(self, base_url: str, token: str, timeout: int = 30) -> None:
        self.base_url = base_url
        self.token = token
        self.timeout = timeout

    def fetch_users(self) -> list[dict]:
        response = requests.get(
            f"{self.base_url}/users",
            headers={"Authorization": f"Bearer {self.token}"},
            timeout=self.timeout,
        )
        response.raise_for_status()
        return response.json()
```

Why this class makes sense:

- the object has stable shared state
- several methods may logically belong to the same client

## 13. A Weak Class Example

```python
class StringUtils:
    def lowercase(self, value: str) -> str:
        return value.lower()
```

Why weak:

- there is no meaningful object state
- a plain function is simpler and clearer

## 14. Stateful Classes Versus Pure Functions

Pure functions are usually better for:

- normalization
- validation
- mapping one shape to another
- small reusable transformations

Classes are usually better for:

- API clients
- configuration objects
- repositories or service objects
- workflow coordinators with stable state

## 15. Data Classes

Not every class should be a heavy OOP structure.

Sometimes a data-focused object is enough.

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

- lightweight container for related values
- clearer than passing many loose strings around

## 16. Class Methods And Static Methods

These often confuse beginners.

### Instance Method

Uses `self` and object state.

```python
class ApiClient:
    def fetch_users(self) -> list[dict]:
        ...
```

### Class Method

Uses `cls` and is often used for alternative constructors.

```python
class ApiConfig:
    @classmethod
    def from_env(cls):
        ...
```

### Static Method

Does not use `self` or `cls`.

```python
class RecordValidator:
    @staticmethod
    def has_required_id(record: dict) -> bool:
        return record.get("id") is not None
```

Important caution:

- if many methods are `@staticmethod`, that is often a sign plain functions may be better

## 17. A Simple Methodology For Choosing The Tool

Ask these questions:

### Use A Plain Function When

- the logic is stateless
- one input becomes one output
- the behavior is easy to name directly
- reuse does not require shared configuration or object state

### Use A Closure When

- you need one small configurable behavior
- introducing a full class would be too heavy

### Use A Decorator When

- the behavior is cross-cutting
- it wraps many functions in the same way
- the wrapped behavior should stay separate from the core business logic

### Use A Class When

- multiple methods need shared state
- the object models a real responsibility
- configuration and behavior belong together

## 18. External Sources For Deeper Reading

Good sources to read more deeply:

- Python official tutorial: classes and functions
- Python official docs: `functools`, `dataclasses`, `typing`
- PEP 8 for style guidance
- PEP 20 for Python philosophy
- Hynek Schlawack's writing on Python design and classes
- Real Python articles on decorators, closures, and OOP in Python
- Fluent Python by Luciano Ramalho for a much deeper treatment of functions, closures, decorators, and Python object model

Useful starting pages:

- https://docs.python.org/3/tutorial/classes.html
- https://docs.python.org/3/tutorial/controlflow.html#defining-functions
- https://docs.python.org/3/library/functools.html
- https://docs.python.org/3/library/dataclasses.html
- https://docs.python.org/3/library/typing.html

## Final Takeaway

Decorators, closures, and classes are not signs of advanced code by themselves.

They are useful only when they make responsibilities clearer.

If they make the code harder to reason about, a simpler function-based design is usually better.