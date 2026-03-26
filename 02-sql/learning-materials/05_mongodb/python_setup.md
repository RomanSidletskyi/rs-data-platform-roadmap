# Python Setup

## Local Setup

```python
from pymongo import MongoClient
from pprint import pprint

client = MongoClient("mongodb://localhost:27017/")
db = client["learning_db"]
orders = db["orders"]

def show(cursor):
    for doc in cursor:
        pprint(doc)
```

## Atlas Setup

```python
from pymongo import MongoClient

client = MongoClient("mongodb+srv://<username>:<password>@cluster.mongodb.net/")
db = client["learning_db"]
orders = db["orders"]
```

## Why Python First

Using MongoDB through Python is closer to real application and data engineering workflows than using shell-only examples.
