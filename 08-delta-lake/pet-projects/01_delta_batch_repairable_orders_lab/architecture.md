# Architecture

## Components

- raw order landing zone
- bronze Delta table
- silver normalized Delta table
- gold daily sales Delta output
- one repair or backfill path bounded by business date

## Data Flow

1. raw files are loaded into a bronze Delta table
2. silver enforces keys, dates, and basic quality rules
3. gold publishes daily store or country revenue output
4. repair logic can rebuild one affected date range without rewriting all history

## Trade-Offs

- append-only bronze is useful for traceability
- silver should support bounded correction safely
- gold should remain consumer-oriented rather than absorbing every engineering convenience
