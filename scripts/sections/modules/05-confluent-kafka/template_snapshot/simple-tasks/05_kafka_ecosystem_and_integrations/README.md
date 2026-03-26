# Kafka Ecosystem And Integrations Tasks

## Task 1 - Choose Connect Vs Custom Code

### Goal

Decide when standard connector tooling is enough.

### Requirements

- describe one case where Kafka Connect is a good fit
- describe one case where a custom consumer or service is more appropriate

## Task 2 - Compare CDC And Business Events

### Goal

Avoid confusing raw row changes with domain contracts.

### Requirements

- describe one CDC topic example
- describe one curated business event topic example
- explain why they should not automatically be treated as the same thing

## Task 3 - Place Kafka In A Larger Stack

### Goal

Connect Kafka to Spark, Flink, and lakehouse thinking.

### Requirements

- explain Kafka's role in a pipeline with Flink or Spark
- explain Kafka's role in a pipeline that lands data into a lakehouse or warehouse