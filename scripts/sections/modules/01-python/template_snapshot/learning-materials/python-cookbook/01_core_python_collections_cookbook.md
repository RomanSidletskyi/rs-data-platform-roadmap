# Core Python Collections Cookbook

## Why This File Exists

Before moving deeper into data engineering patterns, the learner should be fluent in the Python structures that appear in almost every script:

- dictionaries
- lists
- tuples
- sets
- strings

This file is intentionally practical.

It is not about theory first.

It is about:

- what the structure is good for
- which operations matter most in real work
- what parameters or options are important
- how it appears in realistic engineering code

## 1. Dictionaries

### What A Dictionary Is Good For

Use a dictionary when you need key-value access.

Common data engineering uses:

- one record loaded from JSON
- config objects
- lookup maps by ID
- counters and aggregations

### Important Operations

#### Access One Value

```python
record = {"id": 10, "name": "Alice", "city": "Warsaw"}

record["name"]
record.get("country")
record.get("country", "unknown")
```

Important details:

- `record["name"]` raises `KeyError` if the key is missing
- `record.get("country")` returns `None` if missing
- `record.get("country", "unknown")` lets you define a fallback

#### Add Or Update Values

```python
record["country"] = "PL"
record.update({"city": "Krakow", "active": True})
```

Important detail:

- `update()` merges multiple keys at once and overwrites existing values for matching keys

#### Iterate Through A Dictionary

```python
for key in record:
    print(key)

for value in record.values():
    print(value)

for key, value in record.items():
    print(key, value)
```

Important detail:

- `.items()` is the most common pattern when both key and value are needed

#### Remove Values

```python
status = record.pop("active", None)
```

Important detail:

- `pop(key, default)` avoids failure if the key may not exist

### Real Example - Lookup By ID

```python
users = [
    {"user_id": 10, "name": "Alice"},
    {"user_id": 11, "name": "Bob"},
]

users_by_id = {user["user_id"]: user for user in users}

print(users_by_id[10])
```

### Real Example - Counting Values

```python
events = ["login", "login", "purchase", "logout", "login"]

counts: dict[str, int] = {}
for event in events:
    counts[event] = counts.get(event, 0) + 1
```

### Common Mistakes With Dictionaries

- using `record["missing_key"]` when the key is optional
- mutating the same dictionary in many places without a clear contract
- storing too many unrelated meanings in one dictionary

## 2. Lists

### What A List Is Good For

Use a list when you need an ordered sequence.

Common uses:

- rows from a CSV file
- records returned by an API
- output rows before writing a file
- ordered processing steps

### Important Operations

#### Add Elements

```python
rows = []
rows.append({"id": 1, "name": "Alice"})
rows.extend([
    {"id": 2, "name": "Bob"},
    {"id": 3, "name": "Charlie"},
])
```

Important details:

- `append(x)` adds one element
- `extend(iterable)` adds many elements from another iterable

#### Read Or Slice Elements

```python
numbers = [10, 20, 30, 40, 50]

first = numbers[0]
last = numbers[-1]
subset = numbers[1:4]
every_second = numbers[::2]
```

Important detail:

- slicing creates a new list view by position range

#### Sort Lists

```python
amounts = [120, 45, 900, 12]
sorted_amounts = sorted(amounts)

records = [
    {"id": 1, "amount": 300},
    {"id": 2, "amount": 100},
]

records.sort(key=lambda record: record["amount"], reverse=True)
```

Important parameters:

- `key=` defines how to compare values
- `reverse=True` sorts descending

Important difference:

- `sorted(list_obj)` returns a new list
- `list_obj.sort()` changes the existing list in place

#### Filter And Transform

```python
records = [
    {"id": 1, "status": "paid", "amount": 120},
    {"id": 2, "status": "cancelled", "amount": 50},
]

paid_amounts = [record["amount"] for record in records if record["status"] == "paid"]
```

### Real Example - Build Output Rows

```python
processed_rows = []

for record in records:
    processed_rows.append(
        {
            "id": record["id"],
            "amount": record["amount"],
            "status": record["status"].upper(),
        }
    )
```

### Common Mistakes With Lists

- modifying a list while iterating over it without a clear reason
- using a list for key-based lookup where a dictionary is better
- assuming the first item exists without checking for emptiness

## 3. Tuples

### What A Tuple Is Good For

Use a tuple for a small fixed-size ordered value.

Common uses:

- function return values with multiple parts
- coordinates or start/end boundaries
- immutable grouping of related values

### Important Operations

```python
point = (10, 20)
x, y = point

time_window = ("2026-03-01", "2026-03-02")
start_date, end_date = time_window
```

Important details:

- tuples are ordered like lists
- tuples are immutable, which helps signal “fixed grouped value”

### Real Example - Return Data And Error Count

```python
def split_valid_and_invalid(records: list[dict]) -> tuple[list[dict], list[dict]]:
    valid_records = []
    invalid_records = []

    for record in records:
        if record.get("id") is None:
            invalid_records.append(record)
        else:
            valid_records.append(record)

    return valid_records, invalid_records
```

## 4. Sets

### What A Set Is Good For

Use a set for uniqueness and fast membership checks.

Common uses:

- deduplication
- tracking already processed files
- checking whether a status is allowed

### Important Operations

```python
allowed_statuses = {"paid", "cancelled", "pending"}

"paid" in allowed_statuses

statuses = ["paid", "paid", "pending", "cancelled"]
unique_statuses = set(statuses)
```

#### Add And Remove

```python
processed_files = set()
processed_files.add("orders_2026_03_01.json")
processed_files.discard("missing_file.json")
```

Important detail:

- `discard()` does not fail if the value is absent

### Real Example - Find Duplicates

```python
seen_ids = set()
duplicate_ids = set()

for record in records:
    record_id = record["id"]
    if record_id in seen_ids:
        duplicate_ids.add(record_id)
    else:
        seen_ids.add(record_id)
```

## 5. Strings

### Why Strings Matter In Data Work

Much early data engineering work is string work:

- status fields
- IDs
- timestamps before parsing
- filenames
- API endpoints

### Important Operations

```python
name = "  Alice Smith  "

clean_name = name.strip()
lower_name = clean_name.lower()
upper_name = clean_name.upper()
parts = clean_name.split()
joined = "_".join(parts)
```

Important details:

- `strip()` removes whitespace at both ends
- `split(sep)` breaks a string into a list
- `join(iterable)` combines strings with a separator

#### Replace And Search

```python
file_name = "orders-2026-03-01.csv"

normalized_name = file_name.replace("-", "_")
is_csv = file_name.endswith(".csv")
has_orders = "orders" in file_name
```

### Real Example - Normalize Status Values

```python
raw_statuses = [" Paid ", "pending", "CANCELLED", " paid"]
normalized_statuses = [status.strip().lower() for status in raw_statuses]
```

## 6. Useful Built-In Functions

### `len()`

```python
len(records)
len(record)
len(unique_statuses)
```

### `enumerate()`

```python
for index, record in enumerate(records, start=1):
    print(index, record)
```

Important parameter:

- `start=` lets you choose the initial index value

### `zip()`

```python
ids = [1, 2, 3]
names = ["Alice", "Bob", "Charlie"]

for user_id, name in zip(ids, names, strict=False):
    print(user_id, name)
```

Important detail:

- `strict=` is useful when you want mismatched lengths to fail explicitly in modern Python

### `sorted()`

```python
sorted(records, key=lambda record: record["amount"], reverse=True)
```

### `any()` And `all()`

```python
records_have_null_amount = any(record.get("amount") is None for record in records)
all_have_ids = all(record.get("id") is not None for record in records)
```

## 7. Common Real Patterns In Data Scripts

### Pattern 1 - Safe Nested Access

```python
city = record.get("address", {}).get("city")
```

### Pattern 2 - Build A Lookup Map

```python
products_by_id = {product["product_id"]: product for product in products}
```

### Pattern 3 - Split Valid And Invalid Records

```python
valid_records = []
invalid_records = []

for record in records:
    if record.get("id") is None or record.get("email") is None:
        invalid_records.append(record)
    else:
        valid_records.append(record)
```

### Pattern 4 - Default Counters

```python
counts: dict[str, int] = {}
for record in records:
    status = record.get("status", "unknown")
    counts[status] = counts.get(status, 0) + 1
```

## 8. Quick Structure Selection Guide

Use:

- `dict` when you need access by key
- `list` when you need order and repeated values
- `tuple` when you need a small fixed grouped value
- `set` when you need uniqueness or membership checks

## Final Takeaway

These structures are not just syntax details.

They are the material from which small data pipelines are built.

If the learner becomes fluent with them here, the later data engineering files become easier to read, reason about, and implement.