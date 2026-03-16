# Scaling and Throttling

## Core Issues

DynamoDB performance depends on partition distribution and throughput behavior.

## Typical Problems

- hot partitions
- throttling spikes
- uneven traffic
- write bursts on one key

## Design Responses

- improve partition key distribution
- use sharding strategies
- cache hot reads
- precompute aggregates
- use adaptive scaling features appropriately
