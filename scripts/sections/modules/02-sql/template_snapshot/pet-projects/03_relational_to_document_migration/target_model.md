# Target Model

## Example Order Document

```json
{
  "order_id": 101,
  "user_id": 10,
  "order_date": "2025-01-10T12:00:00Z",
  "status": "paid",
  "amount": 450,
  "items": [
    {
      "product_id": 1001,
      "product_name": "Laptop",
      "quantity": 1,
      "item_price": 400
    }
  ],
  "payment": {
    "method": "card",
    "status": "captured"
  }
}
```

## Main Design Choices

- embed order items
- embed small payment summary
- duplicate selected product or customer attributes where read value is high
- reference huge reusable entities only when independence matters

## Main Benefits

- fewer joins
- natural order-level reads
- application-friendly response shape

## Main Risks

- duplicated data
- update fan-out
- document growth if model is not bounded
