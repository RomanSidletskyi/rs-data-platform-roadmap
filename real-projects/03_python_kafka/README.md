# Real Project 03: Python Plus Kafka

## Goal

Build an event-driven ingestion project with Python producers and consumers using Kafka.

The project should demonstrate when streaming adds real value over scheduled batch movement.

## Suggested Stack

- Python
- Kafka
- local or containerized development runtime

## Architecture Focus

- streaming justification
- producer and consumer boundaries
- replay and offset recovery
- idempotent sink behavior

## Suggested Deliverables

- producer application
- consumer application
- topic design notes
- sink or storage output
- operational notes for replay or recovery

## Review Questions

- what business need justifies Kafka here
- what happens if the consumer processes the same message twice
- what source of truth exists outside the stream

## Read With

- `../../docs/architecture/reviews/real-project-review-exercises.md`
- `../../docs/architecture/reviews/streaming-platform-review-checklist.md`
- `../../docs/architecture/adr/template.md`