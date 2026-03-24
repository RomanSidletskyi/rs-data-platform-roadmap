# Solutions: Batch And Stream Processing Patterns

## Task 1

Batch means processing a bounded slice of data with a defined input window. Stream processing means handling an unbounded flow incrementally over time. The difference is really about boundedness and continuity, not only about schedule frequency.

## Task 2

Justified case:

- Kafka order events need near-real-time parsing and incremental lakehouse publication

Possibly unnecessary case:

- one small daily warehouse-resident aggregate with no strict freshness requirement

## Task 3

Watermarks reflect how long the platform is willing to wait for late data before treating a result as final enough. That is a correctness-versus-latency decision, not only a technical setting.

## Task 4

- bronze: source-near raw or lightly parsed data
- silver: cleaned and conformed business-aligned data
- gold: consumer-facing curated outputs and KPIs

The value of the pattern is separation of responsibilities and easier recovery.