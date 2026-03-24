# Architecture

## Components

- local SSH client
- remote Linux host
- audit command set
- optional report artifact

## Data Flow

1. connect using SSH alias or full command
2. inspect host identity, disk, users, permissions, ports
3. capture outputs into an audit summary

## Trade-Offs

- shell is fast for auditing
- audit should remain read-heavy and avoid accidental mutation