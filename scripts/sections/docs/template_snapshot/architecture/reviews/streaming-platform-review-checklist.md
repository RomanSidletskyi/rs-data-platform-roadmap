# Streaming Platform Review Checklist

## Purpose

Use this checklist when reviewing Kafka-based or continuous event-processing architectures.

## Justification

- what business value depends on low latency
- why batch would not be sufficient
- which consumers need independent access to the stream

## Correctness

- how are duplicates handled
- what ordering assumptions exist and where
- what source of truth exists outside the stream

## Recovery

- how does replay work
- are sinks idempotent enough for realistic recovery
- how are poison records isolated

## Ownership And Contracts

- who owns event schemas and semantics
- what happens when schema evolution occurs
- are transport concerns separated from business-serving concerns

## Operational Review

- which lag signals matter most
- where is stateful logic located
- what part of the system is likely to bottleneck first