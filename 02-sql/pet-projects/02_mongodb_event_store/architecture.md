# Architecture

## Logical Flow

Application
-> MongoDB event collection
-> indexes
-> operational queries
-> aggregation pipelines
-> optional export to analytics platform

## Main Architectural Concerns

- write volume
- event granularity
- query latency
- index overhead
- retention strategy
- export strategy for analytics

## Common Architecture Decision

MongoDB is usually good for:

- operational event access
- recent activity queries
- session reconstruction
- application-side event browsing

For deeper large-scale analytics, events are often exported to:

- data lake
- Delta tables
- Spark / Databricks pipelines
