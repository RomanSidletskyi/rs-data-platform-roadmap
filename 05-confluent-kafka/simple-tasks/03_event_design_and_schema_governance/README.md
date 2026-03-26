# Event Design And Schema Governance Tasks

## Task 1 - Design A Good Event Contract

### Goal

Create one clear business event and one weak event for comparison.

### Requirements

- write one good JSON event with `event_id`, `event_type`, `event_time`, and entity ID
- write one weak JSON event with vague fields
- explain why the good version is safer for consumers

## Task 2 - Choose A Partition Key

### Goal

Connect event design to partition strategy.

### Requirements

- choose a key for your event type
- explain why it is better than a low-cardinality field such as status or country

## Task 3 - Plan Schema Evolution

### Goal

Think about contract change before it becomes a production problem.

### Requirements

- add one safe new field to your event
- describe one breaking field change you should avoid
- explain where Schema Registry would help