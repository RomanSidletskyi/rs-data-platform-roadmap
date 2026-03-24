# Schema Evolution And Contracts

## Scenario

Upstream producers change event payloads over time.

Downstream analytics users expect curated tables to remain stable and understandable.

## Core Tension

How much schema flexibility should the platform allow automatically, and where should contract-breaking changes be stopped?

## Trade-Offs

- permissive evolution reduces short-term friction but can damage contract stability
- strict evolution protects consumers but can slow delivery if every change blocks publish
- a lightweight contract review gate often balances safety and throughput better than full manual approval for every change

## Failure Modes

- optional fields becoming operationally required without documentation
- breaking changes surfacing only in downstream dashboards
- schema drift accepted in bronze and accidentally normalized into curated outputs

## Code-Backed Discussion Point

```python
def validate_schema(event, required_fields):
    missing = [field for field in required_fields if field not in event]
    if missing:
        raise ValueError(f"Missing required fields: {missing}")
```

This helper checks a local rule.

The architecture question is who owns `required_fields`, how version changes are approved, and what happens when a field changes type instead of disappearing.

## Decision Signal

Schema evolution is safe only when contract ownership and publish behavior are explicit.

## Review Questions

- which schema changes are safe automatically and which require review
- who owns required-field definitions and compatibility rules
- where should breaking changes be blocked versus warned
- how do downstream consumers discover contract changes

## AI Prompt Pack

```text
Design a lightweight schema-evolution policy for a small data platform. Separate safe automatic changes from contract-breaking changes, and explain where publish should block versus warn.
```

```text
Review this schema-contract design and identify places where ownership, compatibility rules, or downstream communication are still vague.
```