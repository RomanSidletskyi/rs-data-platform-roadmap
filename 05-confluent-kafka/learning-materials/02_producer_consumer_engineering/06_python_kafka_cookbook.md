# Python Kafka Cookbook

## Why This Topic Matters

This module is not Python-only, but Python is one of the easiest ways to make Kafka behavior concrete for data engineers.

The examples below are intentionally small.

Their purpose is to connect theory to real execution shape.

## Example 1: Very Simple Producer Shape

```python
from confluent_kafka import Producer
import json

producer = Producer({"bootstrap.servers": "localhost:9092"})

event = {
    "event_id": "evt-1001",
    "order_id": "ord-501",
    "event_type": "order_created",
    "amount": 149.90,
}

producer.produce(
    topic="sales.order_events",
    key=event["order_id"],
    value=json.dumps(event).encode("utf-8"),
)
producer.flush()
```

What this example teaches:

- topic choice
- key choice
- payload serialization
- explicit flush behavior

## Example 2: Delivery Callback

```python
from confluent_kafka import Producer
import json

def delivery_report(error, message):
    if error is not None:
        print(f"Delivery failed: {error}")
    else:
        print(
            f"Delivered to {message.topic()} "
            f"partition={message.partition()} offset={message.offset()}"
        )

producer = Producer({"bootstrap.servers": "localhost:9092"})

event = {"event_id": "evt-1002", "payment_id": "pay-7", "status": "captured"}

producer.produce(
    "payments.payment_events",
    key=event["payment_id"],
    value=json.dumps(event).encode("utf-8"),
    callback=delivery_report,
)
producer.flush()
```

What this example teaches:

- delivery visibility
- partition and offset feedback
- producer behavior is observable, not magical

## Example 3: Very Simple Consumer Loop

```python
from confluent_kafka import Consumer

consumer = Consumer(
    {
        "bootstrap.servers": "localhost:9092",
        "group.id": "example-reader",
        "auto.offset.reset": "earliest",
    }
)

consumer.subscribe(["sales.order_events"])

try:
    while True:
        msg = consumer.poll(1.0)
        if msg is None:
            continue
        if msg.error():
            print(f"Consumer error: {msg.error()}")
            continue

        print(
            msg.key().decode("utf-8"),
            msg.value().decode("utf-8"),
            msg.partition(),
            msg.offset(),
        )
finally:
    consumer.close()
```

What this example teaches:

- subscription
- poll loop
- message inspection
- partition and offset visibility

## Example 4: Consumer With Basic Validation

```python
import json
from confluent_kafka import Consumer

consumer = Consumer(
    {
        "bootstrap.servers": "localhost:9092",
        "group.id": "validated-reader",
        "auto.offset.reset": "earliest",
    }
)

consumer.subscribe(["sales.order_events"])

try:
    while True:
        msg = consumer.poll(1.0)
        if msg is None:
            continue
        if msg.error():
            continue

        payload = json.loads(msg.value().decode("utf-8"))
        required = ["event_id", "order_id", "event_type"]

        missing = [field for field in required if field not in payload]
        if missing:
            print(f"Send to DLQ: missing fields={missing}")
            continue

        print(f"Safe enough to process order event {payload['event_id']}")
finally:
    consumer.close()
```

What this example teaches:

- validation belongs close to ingestion behavior
- broken records should be classified explicitly
- consumer logic should separate healthy and unhealthy paths

## Example 5: Idempotent Sink Thinking

Pseudo-flow:

```python
event_id = payload["event_id"]

if already_processed(event_id):
    return

write_to_storage(payload)
mark_processed(event_id)
```

This is not a full implementation, but it teaches the right correctness shape.

## Architecture Notes For All Examples

These examples are intentionally small.

They do not by themselves solve:

- production retry strategy
- secure secrets handling
- batching optimization
- Schema Registry integration
- complex rebalance handling
- real observability

But they do give the correct engineering skeleton for later production designs.

## Key Architectural Takeaway

Small Python examples are valuable when they illuminate transport behavior, offset behavior, key choice, validation, and idempotency thinking.