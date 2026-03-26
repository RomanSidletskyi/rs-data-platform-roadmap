# 05-confluent-kafka Learning Materials

This learning block is designed as a full streaming foundation for the rest of the roadmap.

The goal is not only to learn Kafka commands.

The goal is to understand:

- why Kafka exists
- what guarantees Kafka provides and does not provide
- where Kafka belongs in a data platform
- how to reason about topics, partitions, offsets, schemas, retries, replay, and downstream processing

## Recommended Reading Path

1. 01_kafka_foundations/
2. 02_producer_consumer_engineering/
3. 03_event_design_and_schema_governance/
4. 04_kafka_platform_operations/
5. 05_kafka_ecosystem_and_integrations/
6. 06_streaming_architecture_for_data_platforms/
7. 07_kafka_cookbook/

## How To Use This Block

Recommended loop:

1. read one concept file
2. map it to a system boundary
3. run a small local example when the simple tasks are available
4. revisit the concept with production trade-offs in mind

## Core Learning Standard

Each section of this module should help the learner move through three levels:

- from zero: basic mental model and vocabulary
- to engineer: practical producer, consumer, and platform behavior
- to architect: trade-offs, boundaries, failure modes, and ownership

## First Block

The first block, 01_kafka_foundations, creates the base mental model used by everything that follows.

It should be read before jumping into delivery guarantees, retries, Schema Registry, or platform integrations.