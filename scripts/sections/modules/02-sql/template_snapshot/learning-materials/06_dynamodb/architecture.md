# DynamoDB Architecture

## High-Level Flow

Client
-> API
-> partition key hashing
-> storage partitions

## Main Concepts

- partition key
- sort key
- throughput
- GSIs
- LSIs
- adaptive capacity

## Important Truth

DynamoDB is not designed for relational query flexibility.

It is designed for predictable, scalable key-based access.
