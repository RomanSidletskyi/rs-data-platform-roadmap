# Streaming Architecture For Data Platforms Tasks

## Task 1 - Draw A Small Event Backbone

### Goal

Model Kafka inside a broader platform instead of as an isolated broker.

### Requirements

- choose a domain such as orders, clickstream, or IoT
- identify one producer, Kafka topic, two consumers, and one storage layer
- explain what each component owns

## Task 2 - Define Source Of Truth

### Goal

Avoid architectural ambiguity.

### Requirements

- say which system is source of truth for the domain
- explain whether Kafka is integration transport, history, snapshot, or all three

## Task 3 - Plan Replay Recovery

### Goal

Think like an architect about failure recovery.

### Requirements

- define one bug scenario that requires replay
- explain what has to be true in Kafka and downstream sinks for replay to be safe