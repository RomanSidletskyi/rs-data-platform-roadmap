# Kafka Event Contract Boundaries

## Scenario

A platform uses Kafka events for ingestion between services and data pipelines.

Producers evolve payloads quickly, while consumers depend on stable semantics.

## Core Tension

How much contract ownership should stay with producers, and how much protection should be enforced at the consumer or platform boundary?

## Trade-Offs

- producer freedom accelerates change but increases downstream instability
- strict schemas and compatibility checks improve trust but add coordination cost
- platform-level validation can protect consumers, but only if ownership rules remain explicit

## Failure Modes

- optional fields becoming required without versioning
- event meaning changing while field names stay the same
- replay consuming mixed contract versions with ambiguous behavior

## Code-Backed Discussion Point

```json
{
  "event_id": "evt-1001",
  "event_type": "customer_created",
  "customer_id": "c-42",
  "created_at": "2026-03-24T10:15:00Z"
}
```

The payload looks simple.

The architecture question is who guarantees compatibility, what breaks replay, and where schema or semantic drift is detected before downstream tables are affected.

## Decision Signal

Kafka events should be treated as contracts with explicit compatibility rules, not just convenient transport payloads.

## Review Questions

- who owns compatibility rules for producer changes
- what schema or semantic changes are safe without coordination
- how does replay behave across mixed event versions
- where should contract drift be detected before it reaches downstream tables

## AI Prompt Pack

```text
Compare producer-driven event evolution against stronger platform-enforced event contracts for Kafka-based pipelines. Focus on replay safety, semantic drift, compatibility, and team coordination cost.
```

```text
Review this Kafka contract design like a platform architect. Identify where payload compatibility, semantic meaning, and replay guarantees are still underdefined.
```