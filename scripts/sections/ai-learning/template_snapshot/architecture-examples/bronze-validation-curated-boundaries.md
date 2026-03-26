# Bronze, Validation, And Curated Boundaries

## Scenario

A small team ingests raw customer events and publishes curated analytics tables.

They need stable downstream contracts, but they also need low operational overhead.

## Core Tension

Should the system stay simple with a direct raw-to-curated path, or should it introduce an explicit validation boundary before curated publish?

## Design Options

### Option 1

Raw to curated directly.

### Option 2

Bronze plus curated, with limited checks in transformation.

### Option 3

Bronze plus validation plus curated, with explicit schema and contract checks.

## Trade-Offs

- Option 1 is simplest to implement, but weakest for replay diagnosis and contract visibility.
- Option 2 is an improvement, but validation rules remain mixed into transformation logic.
- Option 3 adds operational steps, but makes ownership, failure isolation, and publish trust clearer.

## Failure Modes

- schema breakages discovered too late
- mixed validation and transformation responsibilities
- downstream consumers losing trust in curated outputs

## Code-Backed Discussion Point

```python
def publish_curated(validated_rows):
    shaped_rows = [normalize(row) for row in validated_rows]
    write_table("curated.customer_events", shaped_rows)
```

The function is simple.

The architecture question is what guarantees `validated_rows` must satisfy before this publish step becomes trustworthy.

## Decision Signal

Choose the explicit validation boundary when failure isolation, replay safety, and downstream contracts matter more than one less stage in the diagram.

## Review Questions

- where should schema validation stop the flow versus only warn
- which layer owns replay safety
- at what point do downstream consumers gain contract trust
- what debugging cost is hidden by the simpler direct path

## AI Prompt Pack

```text
Compare a direct raw-to-curated pipeline against a bronze-validation-curated flow for a small team. Focus on failure isolation, replay safety, contract stability, and operational overhead. Explain one context where the simpler option still wins.
```

```text
Review this pipeline boundary decision like a skeptical senior data platform engineer. Identify missing ownership lines, hidden failure modes, and where validation responsibilities are still unclear.
```