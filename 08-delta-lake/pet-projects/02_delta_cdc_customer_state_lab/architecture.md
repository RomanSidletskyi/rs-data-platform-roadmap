# Architecture

## Components

- customer CDC landing input
- staged cleaned CDC dataset
- Delta latest-state customer table
- optional history-preserving view or table

## Data Flow

1. raw CDC records arrive with change timestamps
2. duplicates and malformed records are handled in a staging step
3. latest-state Delta table is updated with explicit winner logic
4. history needs are evaluated separately rather than assumed automatically

## Trade-Offs

- latest-state tables are simpler for many consumers
- history-preserving outputs may still be required for audit or business analysis
- replay safety depends on key quality and duplicate handling
