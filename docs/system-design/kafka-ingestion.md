# Kafka Ingestion System Design

## Problem Statement

Design a near real-time ingestion system that receives events from producers, transports them through Kafka, and processes them downstream.

## Typical Architecture

    Producers -> Kafka Topics -> Consumers -> Storage / Serving

## Interview Questions

- Why use Kafka instead of polling?
- What is a consumer group?
- Why do partitions matter?
