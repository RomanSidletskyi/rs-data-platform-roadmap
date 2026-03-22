
cat <<'EOF' > "$MODULE/learning-materials/05_mongodb/aggregation.md" <<'EOF'
# MongoDB Aggregation

Aggregation pipeline is the main analytical mechanism in MongoDB.

## Group by status

```python
pipeline = [
    {
        "$group": {
            "_id": "$status",
            "total_amount": {"$sum": "$amount"},
            "count": {"$sum": 1}
        }
    }
]

show(orders.aggregate(pipeline))
```

## Match then group

```python
pipeline = [
    {"$match": {"status": "paid"}},
    {
        "$group": {
            "_id": "$customer_id",
            "total_amount": {"$sum": "$amount"}
        }
    }
]

show(orders.aggregate(pipeline))
```

## Project

```python
pipeline = [
    {
        "$project": {
            "_id": 0,
            "order_id": 1,
            "amount": 1,
            "amount_with_tax": {"$multiply": ["$amount", 1.2]}
        }
    }
]

show(orders.aggregate(pipeline))
```

## Sort and limit

```python
pipeline = [
    {"$sort": {"amount": -1}},
    {"$limit": 5}
]

show(orders.aggregate(pipeline))
```

## Lookup

```python
pipeline = [
    {
        "$lookup": {
            "from": "customers",
            "localField": "customer_id",
            "foreignField": "customer_id",
            "as": "customer_info"
        }
    }
]

show(orders.aggregate(pipeline))
```

## Notes

MongoDB can do lookup, but the preferred model still avoids join-heavy designs when possible.
