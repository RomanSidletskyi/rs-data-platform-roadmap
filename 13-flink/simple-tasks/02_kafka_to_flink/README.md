# Kafka to Flink

## Goal

Understand how Flink consumes data from Kafka.

## Input

Kafka topic:

- user_events

Event schema:

- user_id
- event_type
- timestamp

## Requirements

- describe Kafka as source
- define a Flink pipeline that reads the topic
- transform events
- send output to a sink

## Expected Output

A conceptual Kafka -> Flink pipeline.

## Extra Challenge

- add invalid-event handling conceptually
- explain offset/checkpoint relationship
