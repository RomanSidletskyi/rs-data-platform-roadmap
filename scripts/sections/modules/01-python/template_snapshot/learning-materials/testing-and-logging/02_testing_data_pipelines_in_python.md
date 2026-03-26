# Testing Data Pipelines In Python

## Why This Topic Matters

Many Python data projects avoid tests because the code touches files or APIs.

That is a weak habit.

The correct move is usually to design the code so the important logic can be tested separately.

## What To Test First

Start with pure logic:

- field normalization
- validation rules
- flattening logic
- filename generation
- state-tracking helpers

## Good Strategy

- keep transform helpers pure when possible
- test expected and invalid inputs
- verify quarantine or rejection logic explicitly

## Bad Strategy

- say “it is just a script”
- make every helper depend on real files or real network calls

## Why Bad Is Bad

- regressions appear silently
- refactoring becomes risky

## Libraries Worth Knowing Here

### `pytest` Should Be The Default Choice

Worth using because:

- tests are concise
- assertion output is readable
- fixtures and parametrization scale well

Example:

```python
import pytest


@pytest.mark.parametrize(
    ("value", "expected"),
    [
        (" Alice@Example.COM ", "alice@example.com"),
        ("BOB@EXAMPLE.COM", "bob@example.com"),
    ],
)
def test_normalize_email(value: str, expected: str) -> None:
    assert normalize_email(value) == expected
```

### Add `responses` Or `pytest-httpx` When Testing HTTP Clients

Worth using when:

- API client functions should be tested without real network calls

Why useful:

- cleaner mocks for HTTP behavior
- easier testing of retries, error codes, and payload shapes

### Add `freezegun` When Time Affects Outputs

Worth using when:

- filenames, partitions, or summaries depend on current time

Why useful:

- deterministic tests for timestamped logic

## Cookbook Example

```python
def test_normalize_user() -> None:
    record = {"id": 1, "name": " Alice ", "email": "A@EXAMPLE.COM"}
    assert normalize_user(record) == {
        "id": 1,
        "name": "Alice",
        "email": "a@example.com",
    }
```

## Key Architectural Takeaway

Testing is also a design signal: if the code is impossible to test, the project boundaries are probably weak.