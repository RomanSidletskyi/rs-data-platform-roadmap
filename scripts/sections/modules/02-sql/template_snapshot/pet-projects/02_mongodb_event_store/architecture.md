# Architecture - 02 MongoDB Event Store

## Components

- application event producer
- MongoDB event collection
- query and aggregation layer
- index strategy
- retention and export policy

## Target Project Shape

The intended implementation should include:

- one operational event model
- clear query patterns for user, session, and event-type reads
- aggregation examples for light analytical use
- lifecycle thinking for old-event management

## Data Flow

1. application writes event documents into MongoDB
2. indexes support operational read patterns
3. aggregation pipelines answer light analytical questions
4. old events are expired, archived, or exported based on retention policy

## Modeling Rules

- write shape and read shape should remain compatible
- documents should not grow without limit
- aggregation use is fine, but MongoDB is not the main warehouse layer here

## Trade-Offs

- event-per-document is simpler and safer for high write rates
- session-level embedding can help reads but creates growth risk
- extra indexes improve reads but increase write cost

## What Would Change In Production

- real volume testing for index selectivity
- archival into object storage or a lakehouse
- stricter TTL or retention controls
- monitoring for collection growth and hot queries
