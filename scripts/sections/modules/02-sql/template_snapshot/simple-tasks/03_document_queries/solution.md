# 03 Document Queries Solution

These reference solutions use MongoDB shell syntax. The same logic can be translated to `pymongo` or another client.

## Task 1 — Read All Documents

```javascript
db.orders.find({})
db.orders.find({}).limit(10)
```

## Task 2 — Equality Filter

```javascript
db.orders.find({ status: "paid" })
db.orders.find({ status: "paid", customer_id: 10 })
```

## Task 3 — Range Filter

```javascript
db.orders.find({ amount: { $gt: 100 } })
db.orders.find({ amount: { $gte: 100, $lte: 500 } })
```

## Task 4 — Combined Filter

```javascript
db.orders.find({
  status: "paid",
  amount: { $gte: 100, $lte: 500 }
})

db.orders.find({
  status: "paid",
  amount: { $gte: 100, $lte: 500 },
  "customer.country": "PL"
})
```

## Task 5 — Projection

```javascript
db.orders.find(
  {},
  {
    _id: 0,
    order_id: 1,
    customer_id: 1,
    amount: 1,
    status: 1
  }
)
```

## Task 6 — Sorting

```javascript
db.orders.find({}).sort({ amount: -1 })
db.orders.find({}).sort({ status: 1, amount: -1 })
```

## Task 7 — Pagination

```javascript
db.orders.find({})
  .sort({ order_id: 1 })
  .skip(20)
  .limit(10)
```

Key point: skip-based pagination is simple but degrades on large collections because the database still has to walk past skipped documents.

## Task 8 — Count Paid Orders

```javascript
db.orders.countDocuments({ status: "paid" })

db.orders.aggregate([
  { $group: { _id: "$status", order_count: { $sum: 1 } } }
])
```

## Task 9 — Distinct Statuses

```javascript
db.orders.distinct("status")
db.orders.distinct("customer.country")
```

## Task 10 — Nested Field Query

```javascript
db.orders.find({ "customer.country": "PL" })
db.orders.find({ "customer.country": "PL", status: "paid" })
```

## Task 11 — Array Membership

```javascript
db.orders.find({ tags: "priority" })
db.orders.find({ tags: { $all: ["priority", "electronics"] } })
```

## Task 12 — elemMatch

```javascript
db.orders.find({
  items: {
    $elemMatch: {
      sku: "A1",
      qty: { $gte: 2 }
    }
  }
})

db.orders.find({
  amount: { $gt: 100 },
  items: {
    $elemMatch: {
      sku: "A1",
      qty: { $gte: 2 }
    }
  }
})
```

Key point: `elemMatch` is required when multiple predicates must apply to the same array element.

## Task 13 — Aggregation by Status

```javascript
db.orders.aggregate([
  {
    $group: {
      _id: "$status",
      order_count: { $sum: 1 },
      total_amount: { $sum: "$amount" }
    }
  },
  { $sort: { total_amount: -1 } }
])
```

## Task 14 — Aggregation by Customer

```javascript
db.orders.aggregate([
  { $match: { status: "paid" } },
  {
    $group: {
      _id: "$customer_id",
      total_amount: { $sum: "$amount" }
    }
  },
  { $sort: { total_amount: -1 } },
  { $limit: 10 }
])
```

## Notes

- Design indexes around the filters and sorts you actually use.
- Document databases are still query-driven; flexible schema is not a license for unbounded structure.
- Prefer aggregation pipelines when you need grouped analytical output, not plain `find()` queries.
