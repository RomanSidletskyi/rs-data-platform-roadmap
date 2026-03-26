# Producer And Consumer Engineering Tasks

## Task 1 - Publish Ordered Events

### Goal

Produce a small sequence of related events and reason about ordering.

### Requirements

- publish at least 4 events for one entity lifecycle
- use a meaningful key such as `order_id`
- explain why that key helps ordering

## Task 2 - Consume And Track Progress

### Goal

Observe consumer progress and offset movement.

### Requirements

- consume the events from the beginning
- identify offsets shown by your tooling
- explain what changes after the consumer has already progressed

## Task 3 - Explain Duplicate Risk

### Goal

Connect retries to downstream correctness.

### Requirements

- describe one scenario that can create duplicate processing
- explain one idempotency technique that would reduce the risk