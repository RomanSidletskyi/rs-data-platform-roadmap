# Architecture

## Components

- input logs
- shell extraction helpers
- error summarization pipeline
- incident notes output

## Data Flow

1. inspect log volume
2. search important patterns
3. reduce to suspicious lines and counts
4. produce summary notes

## Trade-Offs

- line-oriented shell tools are fast
- deep semantic parsing may require Python later