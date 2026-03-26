# Replay And Idempotency Practice

## Read Before

- `../architecture-examples/replay-and-idempotency.md`
- `../workflows/ai-for-debugging.md`

## Goal

Practice deciding where idempotency should be enforced and how replay guarantees should be described.

## Tasks

1. Identify the replay invariant.
2. Compare enforcing idempotency at ingestion, validation, and publish boundaries.
3. Choose the clearest ownership point.

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

The pipeline supports replay after upstream fixes, but duplicate records still appear because different stages appear to apply idempotency differently.

Constraints:

- replay must be safe and explainable
- upstream quality issues should not be hidden too early
- the team needs one clear ownership point for replay guarantees

### Option Comparison

Option 1:

Enforce idempotency at ingestion as early as possible.

Option 2:

Enforce idempotency at the publish or merge boundary where authoritative state is clearer.

Option 3 if needed:

Use early duplicate detection for visibility, but make publish the authoritative idempotent boundary.

### Trade-Off Review

Recovery and failure handling:

Option 3 is strongest because replay safety depends on one authoritative boundary, while earlier detection can still surface upstream issues.

Contract stability:

Option 2 and 3 are stronger than Option 1 because downstream guarantees depend on the final published state, not only what first entered the platform.

Operational complexity:

Option 1 looks simple, but it can hide duplicate causes and create false confidence if replay later uses different state or rules.

Team ownership and maintainability:

Option 3 creates the clearest model: early stages observe and annotate, while publish owns the final replay invariant.

### Final Decision

Chosen option:

Option 3 with publish as the authoritative idempotency boundary.

Why it wins:

It balances debugging visibility with a single dependable replay guarantee.

Why the other option loses:

Purely early idempotency can hide quality problems and still fail if replay and first-pass processing do not share the same authoritative state.

### Open Risks

- how to guarantee the publish boundary always reads authoritative deduplication state
- how to document replay semantics so teams do not assume ingestion-level deduplication is enough

### Personal System Capture

Decision journal entry:

Define idempotency at the boundary that owns the final published contract, and use earlier duplicate checks for observability rather than the core guarantee.

Mistake to log:

The first instinct treated any deduplication as enough, without asking whether replay and first pass shared the same authoritative invariant.