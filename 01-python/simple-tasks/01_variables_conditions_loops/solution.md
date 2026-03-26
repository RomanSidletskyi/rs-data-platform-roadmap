# 01 Variables, Conditions, And Loops - Solution

This file gives reference solution shapes for the topic.

The goal is not only to get the right output, but to make iteration and classification logic readable.

## Pattern 1 - Iterate Structured Records

```python
records = [
    {"id": 1, "name": "Alice", "city": "Warsaw"},
    {"id": 2, "name": "Bob", "city": "Krakow"},
    {"id": 3, "name": "Charlie", "city": "Gdansk"},
]

for record in records:
    print(f"User {record['id']}: {record['name']} from {record['city']}")
```

## Pattern 2 - Split Values By Condition

```python
numbers = [12, 7, 3, 20, 18, 5, 2, 9]

even_numbers = [number for number in numbers if number % 2 == 0]
odd_numbers = [number for number in numbers if number % 2 != 0]
```

## Pattern 3 - Count Duplicates

```python
ids = [101, 203, 101, 405, 203, 509, 600, 405]

counts: dict[int, int] = {}
for value in ids:
    counts[value] = counts.get(value, 0) + 1

duplicates = [value for value, count in counts.items() if count > 1]
```

## Pattern 4 - Word Counting

```python
text = "data engineering pipelines process data pipelines transform data"

word_counts: dict[str, int] = {}
for word in text.split():
    word_counts[word] = word_counts.get(word, 0) + 1
```

## Pattern 5 - Business Classification

```python
def classify_transaction(amount: int) -> str:
    if amount < 100:
        return "low"
    if amount < 1000:
        return "medium"
    return "high"


transactions = [50, 120, 980, 1500, 300, 20, 75]
classified = [
    {"amount": amount, "category": classify_transaction(amount)}
    for amount in transactions
]
```

## Pattern 6 - Parse Event Strings

```python
events = [
    "login|user_1|success",
    "purchase|user_2|failed",
    "logout|user_1|success",
    "login|user_3|success",
]

parsed_events = []
for raw_event in events:
    event_type, user_id, status = raw_event.split("|")
    parsed_events.append(
        {
            "event_type": event_type,
            "user_id": user_id,
            "status": status,
        }
    )
```

## Key Point

In this topic, readability matters more than clever one-liners.

The learner should leave the section able to iterate through records, count values, and apply simple business rules clearly.