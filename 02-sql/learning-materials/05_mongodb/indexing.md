# MongoDB Indexing

## Simple index

```javascript
db.orders.createIndex({ customer_id: 1 })
```

## Compound index

```javascript
db.orders.createIndex({ customer_id: 1, order_date: -1 })
```

## Nested field index

```javascript
db.orders.createIndex({ "customer.country": 1 })
```

## Array field index

```javascript
db.orders.createIndex({ "items.sku": 1 })
```

## Text index

```javascript
db.products.createIndex({ description: "text" })
```

## Design Rules

- index frequent filters
- align compound index order with query patterns
- keep write overhead in mind
- validate with explain plans
