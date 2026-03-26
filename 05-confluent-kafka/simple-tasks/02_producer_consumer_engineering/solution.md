# Solution

Example producer flow:

    order-1:{"event_type":"order_created"}
    order-1:{"event_type":"payment_authorized"}
    order-1:{"event_type":"payment_captured"}
    order-1:{"event_type":"shipment_dispatched"}

Key reasoning:

- `order_id` helps keep one order lifecycle in consistent partition-local order

Duplicate reasoning:

- if a consumer writes to a sink and crashes before offset commit, the event may be processed again
- common mitigation: dedup by `event_id` or idempotent upsert in the sink