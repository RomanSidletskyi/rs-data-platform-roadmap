# Solution

Good event example:

```json
{
  "event_id": "evt-1001",
  "event_type": "order_created",
  "event_time": "2026-03-24T10:15:00Z",
  "order_id": "ord-501",
  "customer_id": "cust-77",
  "amount": 149.90,
  "currency": "EUR"
}
```

Bad event example:

```json
{
  "type": "data",
  "id": "123",
  "payload": {"x": 1}
}
```

Evolution example:

- safer change: add optional `currency`
- dangerous change: turn numeric `amount` into a free-form string

Schema Registry helps by enforcing compatibility discipline instead of relying on memory and documentation alone.