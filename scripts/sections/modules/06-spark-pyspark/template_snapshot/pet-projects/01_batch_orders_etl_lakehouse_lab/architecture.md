# Architecture Note

## Target Flow

1. raw order events land in object storage
2. Spark reads one bounded processing window
3. invalid records are identified before they pollute curated outputs
4. cleaned records are normalized into a conformed layer
5. a daily gold-style summary is published for analytics

## Core Design Questions

- what is the final grain of the gold dataset?
- which fields belong in raw versus conformed versus curated layers?
- how should invalid records be isolated?
- how will late corrections or replay windows be handled?

## Architectural Risk To Watch

The main risk is collapsing all logic into one script without preserving clear boundaries between source-near handling, conformed cleanup, and consumer-facing output.