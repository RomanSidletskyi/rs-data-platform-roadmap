# Kafka Event Contracts Practice

## Read Before

- `../architecture-examples/kafka-event-contract-boundaries.md`
- `../workflows/ai-for-research.md`

## Goal

Practice deciding how event contracts should evolve and where compatibility should be enforced.

## Tasks

1. Compare producer freedom against stronger compatibility rules.
2. Identify where replay or semantic drift becomes dangerous.
3. Choose one contract-governance direction.

## Worksheet

### Scenario Restatement

Problem:

Constraints:

### Option Comparison

Option 1:

Option 2:

Option 3 if needed:

### Trade-Off Review

Recovery and failure handling:

Contract stability:

Operational complexity:

Team ownership and maintainability:

### Final Decision

Chosen option:

Why it wins:

Why the other option loses:

### Open Risks

- risk 1:
- risk 2:

### Personal System Capture

Decision journal entry:

Mistake to log:

### Scorecard

- option quality: __/5
- trade-off clarity: __/5
- decision defensibility: __/5
- risk visibility: __/5
- ownership of reasoning: __/5

Lowest score and why:

Evidence for the score:

## Filled Example

### Scenario Restatement

Problem:

Kafka producers evolve event payloads quickly, but downstream data consumers need stable semantics and safe replay behavior.

Constraints:

- several producers may change independently
- downstream analytics depends on consistent meaning
- coordination cost cannot be infinite

### Option Comparison

Option 1:

Producer-driven evolution with minimal central compatibility control.

Option 2:

Platform-enforced compatibility rules with explicit contract ownership.

Option 3 if needed:

Lightweight platform checks plus stricter rules only for downstream-facing event families.

### Trade-Off Review

Recovery and failure handling:

Option 3 is strongest because it adds compatibility protection where replay and downstream trust matter most without enforcing heavy rules everywhere.

Contract stability:

Option 1 is weakest because semantic drift can reach consumers too easily.

Operational complexity:

Option 2 is safer but may create more coordination cost than a small platform can sustain for every event.

Team ownership and maintainability:

Option 3 gives a clearer split between platform standards and producer ownership.

### Final Decision

Chosen option:

Option 3 with lightweight platform checks and stricter controls for consumer-facing event contracts.

Why it wins:

It balances downstream safety with realistic coordination cost.

Why the other option loses:

Pure producer freedom creates too much contract drift, while universal heavy governance is more expensive than needed.

### Open Risks

- who classifies an event family as consumer-facing
- how semantic changes are documented when schemas remain technically compatible

### Personal System Capture

Decision journal entry:

Use stronger contract governance at the event boundaries that feed shared downstream consumers, not necessarily on every internal event.

Mistake to log:

Schema compatibility was initially treated as enough, while semantic compatibility and replay guarantees were underweighted.