# Variables, Conditions, and Loops

This section covers the Python basics required for later data engineering tasks.

---

## Task 1 — Print Formatted Records

### Goal
Practice iterating through structured records.

### Input

    records = [
        {"id": 1, "name": "Alice", "city": "Warsaw"},
        {"id": 2, "name": "Bob", "city": "Krakow"},
        {"id": 3, "name": "Charlie", "city": "Gdansk"}
    ]

### Requirements

- iterate through the list
- print each record using an f-string
- format output like `User 1: Alice from Warsaw`

### Expected Output

    User 1: Alice from Warsaw
    User 2: Bob from Krakow
    User 3: Charlie from Gdansk

### Extra Challenge

- sort the records by city before printing
- print the total number of records

---

## Task 2 — Filter Even and Odd Numbers

### Goal
Practice loops and conditional logic.

### Input

    numbers = [12, 7, 3, 20, 18, 5, 2, 9]

### Requirements

- create a list of even numbers
- create a list of odd numbers
- print both lists

### Expected Output

    even_numbers = [12, 20, 18, 2]
    odd_numbers = [7, 3, 5, 9]

### Extra Challenge

- calculate the sum of even numbers
- calculate the sum of odd numbers

---

## Task 3 — Find Duplicate Values

### Goal
Detect duplicate values in a dataset.

### Input

    ids = [101, 203, 101, 405, 203, 509, 600, 405]

### Requirements

- identify values that appear more than once
- print duplicates only once

### Expected Output

    [101, 203, 405]

### Extra Challenge

Return a dictionary with counts:

    {
        101: 2,
        203: 2,
        405: 2
    }

---

## Task 4 — Count Unique Words

### Goal
Practice string processing and dictionary counting.

### Input

    text = "data engineering pipelines process data pipelines transform data"

### Requirements

- split text into words
- count occurrences of each word
- store results in a dictionary

### Expected Output

    {
        "data": 3,
        "engineering": 1,
        "pipelines": 2,
        "process": 1,
        "transform": 1
    }

### Extra Challenge

- print the top 3 most frequent words
- sort the result alphabetically by word

---

## Task 5 — Transaction Classification

### Goal
Simulate simple business classification rules.

### Input

    transactions = [50, 120, 980, 1500, 300, 20, 75]

### Requirements

Classify each transaction as:

- low
- medium
- high

Rules:

- low < 100
- medium 100-999
- high >= 1000

### Expected Output

    [
        {"amount": 50, "category": "low"},
        {"amount": 120, "category": "medium"},
        {"amount": 980, "category": "medium"},
        {"amount": 1500, "category": "high"},
        {"amount": 300, "category": "medium"},
        {"amount": 20, "category": "low"},
        {"amount": 75, "category": "low"}
    ]

### Extra Challenge

- count how many transactions belong to each category
- calculate the total amount by category

---

## Task 6 — Clean Raw Event Strings

### Goal
Transform unstructured strings into structured data.

### Input

    events = [
        "login|user_1|success",
        "purchase|user_2|failed",
        "logout|user_1|success",
        "login|user_3|success"
    ]

### Requirements

- split each string using "|"
- convert it into a dictionary
- store the result in a list

### Expected Output

    [
        {"event_type": "login", "user_id": "user_1", "status": "success"},
        {"event_type": "purchase", "user_id": "user_2", "status": "failed"},
        {"event_type": "logout", "user_id": "user_1", "status": "success"},
        {"event_type": "login", "user_id": "user_3", "status": "success"}
    ]

### Extra Challenge

- count how many events each user generated
- count how many successful and failed events exist

---

## Task 7 — Count Records by Status

### Goal
Build simple aggregation logic.

### Input

    records = [
        {"id": 1, "status": "success"},
        {"id": 2, "status": "failed"},
        {"id": 3, "status": "success"},
        {"id": 4, "status": "pending"},
        {"id": 5, "status": "failed"},
        {"id": 6, "status": "success"}
    ]

### Requirements

- count how many records belong to each status
- store results in a dictionary

### Expected Output

    {
        "success": 3,
        "failed": 2,
        "pending": 1
    }

### Extra Challenge

- sort the result by frequency
- print the most common status
- calculate the total number of records

---

## Task 8 — Basic Data Quality Check

### Goal
Introduce validation logic.

### Input

    records = [
        {"id": 1, "name": "Alice", "email": "alice@example.com"},
        {"id": 2, "name": "Bob"},
        {"id": 3, "email": "charlie@example.com"},
        {"name": "David", "email": "david@example.com"}
    ]

### Requirements

Required fields:

- id
- name
- email

- separate valid and invalid records

### Expected Output

Valid records:

    [
        {"id": 1, "name": "Alice", "email": "alice@example.com"}
    ]

Invalid records:

    [
        {"id": 2, "name": "Bob"},
        {"id": 3, "email": "charlie@example.com"},
        {"name": "David", "email": "david@example.com"}
    ]

### Extra Challenge

- print which fields are missing for each invalid record
- count valid and invalid records
