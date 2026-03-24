# Learning Resources - Scalability and Reliability

## How To Use These Resources

Use these resources to understand failure behavior, not only peak throughput.

After each resource, write down:

- what failure mode it is trying to control
- whether the strategy protects correctness, throughput, or both
- what operational signal would show the problem first

## What To Search For

- idempotent pipeline design
- checkpointing concepts
- retry and backoff strategies
- distributed processing bottlenecks
- replay and recovery architecture

## Best Resource Types

- postmortems
- runbook-oriented engineering articles
- reliability talks for Kafka, Spark, Airflow, or lakehouse platforms

## Real Examples To Pair With Reading

- consumer lag incident
- failed batch rerun with duplicate risk
- checkpoint recovery after streaming interruption
- sink bottleneck that looked like a messaging problem at first

## Books

- Designing Data-Intensive Applications
- Fundamentals of Data Engineering
