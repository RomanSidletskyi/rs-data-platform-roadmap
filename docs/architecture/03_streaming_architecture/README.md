# Streaming Architecture

## What Problem Does It Solve

Streaming architecture is used when data must be processed continuously with low latency.

## Why It Matters

Modern platforms often require near real-time event processing and decoupled system communication.

## Typical Architecture

    Producers -> Kafka -> Stream Processing -> Storage / Serving -> Consumers

## When To Use It

- near real-time analytics
- event-driven systems
- clickstream analysis
- operational monitoring

## When Not To Use It

- daily reporting
- simple one-time sync jobs
- low-frequency workloads

## Interview Questions

- When would you choose Kafka?
- What is the purpose of a consumer group?
- What are offsets?
- What is the difference between at-least-once and exactly-once?

## Related Courses

See:

    resources.md

## Completion Checklist

- [ ] I understand why streaming exists
- [ ] I can explain topics, partitions, and offsets
- [ ] I understand consumer groups
- [ ] I can explain when not to use streaming
