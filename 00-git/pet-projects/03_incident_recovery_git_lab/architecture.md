# Architecture

## Components

- damaged local state
- reflog and commit history
- recovery branch or restored working tree

## Data Flow

1. inspect state
2. identify recovery target
3. recover safely
4. validate history and working tree

## Trade-Offs

- deeper Git power improves recovery
- careless mutation during recovery can worsen the incident