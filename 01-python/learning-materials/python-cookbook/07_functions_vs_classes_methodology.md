# Functions Vs Classes Methodology

## Why This File Exists

One of the most common design questions in Python is:

- should this be a set of functions or a class

Many engineers overuse classes because they came from Java or C# habits.

Other engineers avoid classes too aggressively and keep forcing everything into loose functions.

Both extremes are weak.

The right choice depends on responsibility, state, and clarity.

## The Default Recommendation For This Roadmap

For most early data-engineering code, start `functions-first`.

Why:

- many transformations are stateless
- functions are easy to test
- data flow is easier to read
- beginners usually hide less complexity in plain functions than in premature classes

But do not turn `functions-first` into `functions-only`.

Classes become appropriate once the code has real shared state or object-shaped responsibilities.

## Methodology 1: Functions-First Design

Use a functions-first design when the work mainly looks like:

- load records
- validate records
- normalize records
- write outputs
- build summaries

These operations are often clearer as plain functions.

### Good Example

```python
def validate_user(record: dict) -> None:
    if record.get("id") is None:
        raise ValueError("Missing id")


def normalize_user(record: dict) -> dict:
    return {
        "id": record["id"],
        "email": record["email"].strip().lower(),
    }


def write_users_csv(records: list[dict], output_path: str) -> None:
    ...
```

Why good:

- each function has one responsibility
- input and output are obvious
- testing is straightforward

## When Functions-First Is Especially Strong

Functions-first is especially strong for:

- normalization logic
- validation logic
- parsing helpers
- file naming helpers
- row-level or record-level transformations

## Common Functions-First Mistakes

### Too Many Arguments Everywhere

If every function receives ten loosely related parameters, the design may be asking for better grouping.

### Hidden Shared Meaning

If many functions secretly depend on the same base URL, token, timeout, and retry settings, a class or config object may be a better home.

## Methodology 2: Class-Based Design

Use a class-based design when the code has real shared state or a responsibility that behaves like an object.

### Good Example: API Client

```python
class OrdersApiClient:
    def __init__(self, base_url: str, token: str, timeout: int = 30) -> None:
        self.base_url = base_url
        self.token = token
        self.timeout = timeout

    def fetch_orders(self, page: int) -> list[dict]:
        ...

    def fetch_order(self, order_id: int) -> dict:
        ...
```

Why good:

- base URL, token, and timeout are shared state
- the methods belong to one clear responsibility

### Good Example: State Tracker

```python
class ProcessedFilesState:
    def __init__(self, state_path: str) -> None:
        self.state_path = state_path

    def load(self) -> set[str]:
        ...

    def save(self, processed_files: set[str]) -> None:
        ...
```

Why good:

- state operations belong to one object with one concern

## When Classes Are Especially Strong

Classes are especially strong for:

- clients to external systems
- config objects
- state trackers
- service objects with stable configuration
- repositories and adapters in larger systems

## Common Class-Based Mistakes

### Making Classes Only To Group Random Helpers

```python
class CsvUtils:
    @staticmethod
    def clean_email(email: str) -> str:
        return email.strip().lower()
```

This usually adds ceremony without giving real value.

### Building Deep Inheritance Too Early

Inheritance often creates more confusion than value in small data projects.

Prefer composition and plain functions unless the object model is genuinely stable and shared.

### Hiding The Pipeline Inside One Giant Manager Class

```python
class PipelineManager:
    def do_everything(self) -> None:
        ...
```

This is often just procedural code hidden inside an object.

## A Practical Rule For Data Engineering Code

For small and medium Python data workflows:

- use plain functions for transformation logic
- use small classes for clients, config objects, and stateful services
- keep the entrypoint thin regardless of style

This hybrid model is often the most practical.

## Hybrid Design Example

```python
class UsersApiClient:
    def __init__(self, base_url: str, token: str) -> None:
        self.base_url = base_url
        self.token = token

    def fetch_users(self) -> list[dict]:
        ...


def validate_user(record: dict) -> None:
    ...


def normalize_user(record: dict) -> dict:
    ...


def write_users_csv(records: list[dict], output_path: str) -> None:
    ...
```

Why this is strong:

- network client keeps shared connection-related state
- transformation logic stays simple and testable

## Where Decorators Fit Into The Methodology

Decorators should usually remain outside the core decision of functions versus classes.

They are best treated as wrappers for cross-cutting behavior.

Examples:

- timing a function
- retrying a call
- logging duration

Do not use decorators as a substitute for clear architecture.

## Where Closures Fit Into The Methodology

Closures are useful between plain functions and classes.

They are a good middle ground when:

- you need a small configurable behavior
- a class would be too heavy
- one returned function is enough

## A Simple Decision Tree

Ask in this order:

1. Is the logic stateless and direct?
If yes, start with a plain function.

2. Do several operations share stable state or configuration?
If yes, consider a class.

3. Do I only need a tiny configurable function?
If yes, consider a closure.

4. Am I only trying to wrap logging, timing, retry, or another repeated concern?
If yes, consider a decorator.

## Practical Advice For You

If you feel weak in this area, use this rule aggressively at first:

- default to plain functions
- introduce classes only when you can name the shared state clearly
- introduce decorators only for cross-cutting concerns
- introduce closures only when the configurability is small and local

This avoids most beginner design mistakes.

## External Sources For Deeper Reading

For design thinking in Python, good next reads are:

- Python official tutorial on classes and functions
- Python official docs on `dataclasses` and `functools`
- Fluent Python by Luciano Ramalho
- Architecture Patterns with Python by Harry Percival and Bob Gregory
- Real Python articles on OOP, decorators, and closures

Useful starting pages:

- https://docs.python.org/3/tutorial/classes.html
- https://docs.python.org/3/library/dataclasses.html
- https://docs.python.org/3/library/functools.html

## Final Takeaway

Good Python design is not about proving you know OOP or proving you can avoid it.

It is about choosing the simplest structure that keeps responsibilities clear.

For most early data-engineering code, that usually means:

- functions first
- classes where state is real
- decorators for cross-cutting behavior
- closures for small configurable behavior