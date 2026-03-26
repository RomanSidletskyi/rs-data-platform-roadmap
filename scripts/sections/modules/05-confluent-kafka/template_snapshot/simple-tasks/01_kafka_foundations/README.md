# Kafka Foundations Tasks

## Task 1 - Start A Local Kafka Lab

### Goal

Bring up a local Kafka environment and verify the broker is reachable.

### Requirements

- start Kafka locally with Docker Compose or equivalent
- create a topic named `lab.events`
- list topics and confirm it exists

## Task 2 - Inspect Core Concepts

### Goal

Connect commands to the log mental model.

### Requirements

- explain what a topic is
- explain what a partition is
- explain what an offset is
- explain why Kafka is not just a simple queue

## Task 3 - Compare Kafka Vs Polling

### Goal

Translate a small lab into architecture reasoning.

### Requirements

- describe one case where polling is enough
- describe one case where Kafka is the stronger fit
- explain what replay changes in that comparison