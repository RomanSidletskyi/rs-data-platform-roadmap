# Flink

This module introduces Flink as a streaming compute engine for real-time data platforms.

The goal is to understand how stateful stream processing works and when Flink is a better fit than batch-oriented tools.

## Why It Matters

Kafka can transport events, but it does not replace a streaming compute engine.

Flink is used when systems need:

- low-latency processing
- stateful computations
- windowing
- event-time handling
- reliable recovery

## What You Will Learn

- Flink basics
- streams and transformations
- event time and watermarks
- stateful processing
- windowing
- Flink with Kafka
- checkpointing
- production streaming patterns

## Learning Structure

### Learning Materials

- Flink basics
- streams and transformations
- event time and watermarks
- stateful processing
- windowing
- Flink with Kafka
- production patterns

### Simple Tasks

- first stream job
- Kafka to Flink
- windows and aggregations
- event time intro
- stateful processing
- checkpointing basics

### Pet Projects

- real-time metrics pipeline
- clickstream sessionization
- fraud detection simulator
- Flink end-to-end project

## Related Modules

- 05-confluent-kafka
- 06-spark-pyspark
- 14-iceberg
- 16-observability

## Completion Criteria

By the end of this module, you should be able to:

- explain what Flink is used for
- describe stateful stream processing
- explain event time and windows
- explain checkpointing conceptually
- identify when Flink is useful and when it is overkill
