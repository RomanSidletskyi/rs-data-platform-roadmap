# 03 Working With Files, CSV, And JSON - Solution

This file gives reference solution shapes for the core file-processing patterns.

## Pattern 1 - Read CSV With DictReader

```python
import csv


with open("users.csv", newline="", encoding="utf-8") as file:
    reader = csv.DictReader(file)
    rows = list(reader)

for row in rows:
    print(f"{row['name']} - {row['city']}")
```

## Pattern 2 - Convert CSV To JSON

```python
import csv
import json


with open("users.csv", newline="", encoding="utf-8") as file:
    rows = list(csv.DictReader(file))

for row in rows:
    row["id"] = int(row["id"])

with open("users.json", "w", encoding="utf-8") as file:
    json.dump(rows, file, indent=2)
```

## Pattern 3 - Convert JSON To CSV

```python
import csv
import json


with open("users.json", encoding="utf-8") as file:
    records = json.load(file)

fieldnames = ["id", "name"]

with open("users.csv", "w", newline="", encoding="utf-8") as file:
    writer = csv.DictWriter(file, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(records)
```

## Pattern 4 - Merge Two CSV Files By Key

```python
users_by_id = {row["id"]: row for row in users_rows}
cities_by_id = {row["id"]: row for row in city_rows}

merged_rows = []
for user_id, user_row in users_by_id.items():
    merged_rows.append(
        {
            "id": user_id,
            "name": user_row["name"],
            "city": cities_by_id.get(user_id, {}).get("city"),
        }
    )
```

## Pattern 5 - Flatten Nested JSON

```python
flat_records = []
for record in records:
    address = record.get("address", {})
    flat_records.append(
        {
            "id": record["id"],
            "name": record["name"],
            "city": address.get("city"),
            "zip": address.get("zip"),
        }
    )
```

## Key Point

The important engineering habit here is to think explicitly about:

- input shape
- output shape
- invalid rows
- raw vs processed outputs