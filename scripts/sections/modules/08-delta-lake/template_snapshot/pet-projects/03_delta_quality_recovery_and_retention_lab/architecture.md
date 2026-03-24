# Architecture

## Components

- source input with possible invalid rows
- silver Delta table with one blocking quality rule
- repair path using bounded rewrite or restore review
- retention policy aligned to recovery expectations

## Data Flow

1. source records arrive for a shared silver table
2. invalid rows are blocked or quarantined deliberately
3. bad writes can be inspected through time travel and repaired with bounded scope when possible
4. retention settings preserve enough historical safety for real operating needs

## Trade-Offs

- stronger quality checks reduce silent corruption but can increase visible failures
- restore is powerful but not always safer than narrow repair
- short retention saves storage but can weaken recovery guarantees
