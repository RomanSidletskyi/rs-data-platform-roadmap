# MongoDB Queries

This file presents MongoDB query patterns through Python.

## Read all documents

```python
show(orders.find({}))
```

## Equality filter

```python
show(orders.find({"status": "paid"}))
```

## Range filter

```python
show(orders.find({"amount": {"$gt": 100}}))
```

## Combined filter

```python
show(orders.find({
    "status": "paid",
    "amount": {"$gte": 100}
}))
```

## OR filter

```python
show(orders.find({
    "$or": [
        {"status": "paid"},
        {"status": "shipped"}
    ]
}))
```

## Projection

```python
show(orders.find(
    {"status": "paid"},
    {"_id": 0, "order_id": 1, "amount": 1}
))
```

## Sort ascending

```python
show(orders.find({}).sort("amount", 1))
```

## Sort descending

```python
show(orders.find({}).sort("amount", -1))
```

## Limit

```python
show(orders.find({}).limit(5))
```

## Pagination

```python
show(orders.find({}).sort("order_id", 1).skip(10).limit(5))
```

## Count

```python
print(orders.count_documents({"status": "paid"}))
```

## Distinct

```python
print(orders.distinct("status"))
```

## IN

```python
show(orders.find({"status": {"$in": ["paid", "shipped"]}}))
```

## NOT IN

```python
show(orders.find({"status": {"$nin": ["failed", "cancelled"]}}))
```

## Field exists

```python
show(orders.find({"discount_code": {"$exists": True}}))
```

## Field missing

```python
show(orders.find({"discount_code": {"$exists": False}}))
```

## Regex / LIKE analogue

```python
show(orders.find({"customer_email": {"$regex": "gmail", "$options": "i"}}))
```

## Nested field

```python
show(orders.find({"customer.country": "UA"}))
```

## Array membership

```python
show(orders.find({"tags": "priority"}))
```

## Array all

```python
show(orders.find({"tags": {"$all": ["electronics", "priority"]}}))
```

## elemMatch

```python
show(orders.find({
    "items": {
        "$elemMatch": {
            "sku": "A1",
            "qty": {"$gte": 2}
        }
    }
}))
```

## Insert one

```python
orders.insert_one({
    "order_id": 101,
    "status": "paid",
    "amount": 250
})
```

## Insert many

```python
orders.insert_many([
    {"order_id": 102, "status": "new", "amount": 120},
    {"order_id": 103, "status": "paid", "amount": 300}
])
```

## Update one

```python
orders.update_one(
    {"order_id": 101},
    {"$set": {"status": "shipped"}}
)
```

## Update many

```python
orders.update_many(
    {"status": "new"},
    {"$set": {"status": "processing"}}
)
```

## Increment field

```python
orders.update_one(
    {"order_id": 101},
    {"$inc": {"retry_count": 1}}
)
```

## Rename field

```python
orders.update_many(
    {},
    {"$rename": {"amount": "total_amount"}}
)
```

## Unset field

```python
orders.update_many(
    {},
    {"$unset": {"temporary_field": ""}}
)
```

## Upsert

```python
orders.update_one(
    {"order_id": 999},
    {"$set": {"status": "new", "amount": 100}},
    upsert=True
)
```

## Delete one

```python
orders.delete_one({"order_id": 101})
```

## Delete many

```python
orders.delete_many({"status": "cancelled"})
```

## Common Mistakes

- using MongoDB like normalized SQL
- overusing lookup
- missing indexes on real filter fields
- storing unbounded arrays
- ignoring document growth
