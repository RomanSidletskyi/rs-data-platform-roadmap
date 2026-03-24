# Kafka Ingestion System Design

## Problem Statement

Design a near real-time ingestion system that receives events from producers, transports them through Kafka, and processes them downstream.

## Typical Use Cases

- clickstream ingestion
- operational event backbones
- IoT telemetry pipelines
- multi-consumer service event flows

## Typical Architecture

    Producers -> Kafka Topics -> Consumers -> Storage / Serving

## Core Components

- producers
- topics and partitions
- consumer groups
- sink or serving storage
- DLQ or bad-record handling path

## Why Each Component Exists

### Topics And Partitions

Provide scalable event transport with partition-local ordering.

### Consumer Groups

Allow independent downstream use cases and horizontal scaling.

### DLQ Path

Prevents one poison record from blocking the whole pipeline indefinitely.

## When To Use It

- several consumers need the same facts independently
- replay matters
- reaction time matters more than in scheduled batch
- systems should be decoupled in time

## When Not To Use It

- low-frequency scheduled sync jobs
- one simple producer and one simple consumer with no replay need
- synchronous business flows that require immediate answers

## Failure Points

- poor partition keys create skew or ordering problems
- sink logic is not idempotent
- lag grows because downstream throughput is weaker than expected
- ownership is unclear and topic semantics degrade

## Observability

Watch:

- consumer lag
- rebalance frequency
- DLQ volume
- sink latency

## Interview Questions

- Why use Kafka instead of polling?
- What is a consumer group?
- Why do partitions matter?

## Read With

- `README.md`
- `../trade-offs/kafka-vs-batch-ingestion.md`
- `../case-studies/02_streaming_event_backbone_for_ecommerce.md`

## Interview Questions

- Why use Kafka instead of polling?
- What is a consumer group?
- Why do partitions matter?
