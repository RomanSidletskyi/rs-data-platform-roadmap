# 04 NoSQL Modeling Solution

These are reference modeling directions, not the only valid answers. The important part is whether the model follows the stated access patterns and trade-offs.

## Task 1 — SQL to MongoDB Order Model

Recommended approach: keep the order as the main document boundary.

Example document:

```json
{
  "order_id": 101,
  "customer_id": 10,
  "order_status": "paid",
  "order_date": "2025-01-01T10:00:00Z",
  "currency": "EUR",
  "items": [
    {
      "product_id": 501,
      "product_name": "Laptop Sleeve",
      "qty": 2,
      "item_price": 25
    }
  ],
  "totals": {
    "gross_amount": 50,
    "discount_amount": 0,
    "net_amount": 50
  },
  "shipping": {
    "country": "PL",
    "city": "Warsaw"
  }
}
```

Guidance:

- Embed line items because they are usually read with the order.
- Reference large product metadata if it changes independently and does not belong to order history.
- Watch for document growth if orders can contain very large item arrays.

## Task 2 — SQL to DynamoDB Order Access Pattern Model

Recommended table design:

- `PK = CUSTOMER#{customer_id}`
- `SK = ORDER#{order_timestamp}#{order_id}`
- `GSI1PK = PRODUCT#{product_id}`
- `GSI1SK = ORDER#{order_timestamp}#{order_id}`

Example item:

```json
{
  "PK": "CUSTOMER#10",
  "SK": "ORDER#2025-01-01T10:00:00Z#101",
  "entity_type": "order",
  "order_id": 101,
  "customer_id": 10,
  "order_status": "paid",
  "total_amount": 250,
  "GSI1PK": "PRODUCT#501",
  "GSI1SK": "ORDER#2025-01-01T10:00:00Z#101"
}
```

Guidance:

- Customer-centric reads become efficient by partition.
- Latest orders come naturally from reverse sort or descending client logic.
- Hot partitions appear if a very small number of customers generate extreme write volume; shard keys may be needed.

## Task 3 — SQL to CosmosDB Order Model

Recommended partition key: `/customer_id` for customer-centric operational reads.

Example document:

```json
{
  "id": "order-101",
  "customer_id": "10",
  "order_id": 101,
  "order_status": "paid",
  "order_date": "2025-01-01T10:00:00Z",
  "items": [
    { "product_id": 501, "qty": 2, "item_price": 25 }
  ],
  "total_amount": 50
}
```

Guidance:

- `/customer_id` works well for “get all orders for customer”.
- `/order_id` helps point lookups but weakens grouped customer queries.
- Cross-partition analytics are possible but more expensive.

## Task 4 — Session Event Modeling Across Systems

MongoDB model:

- One event document per event.
- Optional session summary collection for read-heavy session views.

DynamoDB model:

- `PK = USER#{user_id}#SESSION#{session_id}`
- `SK = EVENT#{event_time}#{event_id}`
- good for sequential session reads.

CosmosDB model:

- partition by `/session_id` when session-local access is primary.
- partition by `/user_id` when user history is primary.

Trade-off summary:

- MongoDB gives flexible event payloads and easy nested JSON.
- DynamoDB is strongest when access paths are fixed in advance.
- CosmosDB balances document flexibility with globally distributed operational patterns, but partition-key choice is critical.

## Task 5 — Product Catalog with Flexible Attributes

SQL model:

- `products` base table
- optional `product_attributes` EAV-style table for flexible attributes

MongoDB model:

```json
{
  "product_id": 700,
  "product_type": "laptop",
  "name": "Notebook Pro 14",
  "attributes": {
    "cpu": "M3",
    "ram_gb": 16,
    "storage_gb": 512
  }
}
```

CosmosDB model:

- similar JSON document shape
- partition key could be `/product_type` or `/category_id` depending on catalog navigation patterns

Index guidance:

- index stable filter fields such as `product_type`, `category_id`, `brand`, and frequently queried attribute paths.
- avoid indexing every possible flexible field because write cost and storage will grow without clear benefit.

## Notes

- In NoSQL modeling, start with access patterns, not with a relational diagram rewrite.
- Embedding is good when data is read together and update boundaries align.
- Referencing is safer when sub-entities grow independently or are reused broadly.
