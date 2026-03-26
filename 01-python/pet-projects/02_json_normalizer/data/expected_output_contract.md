# Expected Output Contract

The normalized first iteration should produce one flat row per order.

## Recommended Columns

- `order_id`
- `customer_id`
- `customer_name`
- `customer_city`
- `customer_country`
- `payment_method`
- `payment_status`
- `created_at`

## Edge Cases To Decide Explicitly

- missing nested keys such as `customer.address.city`
- records where `payment` is absent
- nested arrays that cannot be flattened without changing row grain