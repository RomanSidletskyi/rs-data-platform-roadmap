# Architecture

## Components

- local target directory
- shell entrypoint
- disk inspection helpers
- log inspection helpers
- process inspection helpers

## Data Flow

1. operator passes a target path
2. scripts inspect files and runtime signals
3. toolkit prints summarized outputs

## Trade-Offs

- shell gives fast inspection but weak structured modeling
- keep the toolkit operational, not business-logic heavy