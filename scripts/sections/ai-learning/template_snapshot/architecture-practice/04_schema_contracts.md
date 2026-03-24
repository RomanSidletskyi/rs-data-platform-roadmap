# Schema Contracts Practice

## Read Before

- `../architecture-examples/schema-evolution-contracts.md`
- `../workflows/adr-writing-with-ai.md`

## Goal

Practice choosing where schema evolution should stay flexible and where contract changes should be stopped.

## Tasks

1. Compare permissive evolution versus guarded contract control.
2. Decide where breaking changes should be blocked, warned, or accepted.
3. Write the decision as a short contract rule.

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

Upstream payloads evolve often, but curated tables are used by analysts who need stable semantics and predictable publish behavior.

Constraints:

- some additive schema changes should remain fast
- breaking changes must not silently reach consumers
- the team needs a lightweight governance model, not a bureaucracy-heavy process

### Option Comparison

Option 1:

Allow permissive schema evolution broadly and rely on downstream fixes when needed.

Option 2:

Block most schema changes unless they are manually approved before publish.

Option 3 if needed:

Allow safe additive evolution automatically, but gate contract-breaking changes at the curated publish boundary.

### Trade-Off Review

Recovery and failure handling:

Option 3 is strongest because it prevents silent downstream breakage while still allowing low-risk changes to move quickly.

Contract stability:

Option 1 is weakest because contract drift can normalize into curated outputs before anyone recognizes the semantic impact.

Operational complexity:

Option 2 is safest in theory, but it creates too much friction for routine non-breaking evolution.

Team ownership and maintainability:

Option 3 works best because contract ownership stays explicit without turning every schema change into a heavy review ceremony.

### Final Decision

Chosen option:

Option 3 with automatic handling for safe additive changes and explicit gating for contract-breaking changes.

Why it wins:

It gives consumers a clearer stability promise while preserving delivery speed for changes that do not alter downstream meaning.

Why the other option loses:

Pure permissiveness is unsafe, while universal manual review is too rigid for a growing platform.

### Open Risks

- who decides when a type or semantic change counts as contract-breaking
- how to communicate approved contract changes clearly to downstream users

### Personal System Capture

Decision journal entry:

Separate safe schema evolution from contract-breaking change, and enforce the real boundary at curated publish where downstream trust becomes visible.

Mistake to log:

At first the design focused too much on field presence and not enough on semantic stability for consumers.