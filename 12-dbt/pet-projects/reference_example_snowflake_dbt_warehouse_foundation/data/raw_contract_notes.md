# Raw Contract Notes

This reference example assumes three raw relations:

- `RAW.orders`
- `RAW.customers`
- `RAW.products`

Minimum order fields:

- `order_id`
- `customer_id`
- `product_id`
- `status`
- `amount`
- `updated_at`
- `ingested_at`

The marts assume `status` is one of:

- `created`
- `paid`
- `shipped`
- `cancelled`
