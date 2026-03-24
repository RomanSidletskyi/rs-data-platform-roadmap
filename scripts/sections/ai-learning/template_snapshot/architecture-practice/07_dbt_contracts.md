# dbt Contracts Practice

## Read Before

- `../architecture-examples/dbt-model-contracts.md`
- `../workflows/adr-writing-with-ai.md`

## Goal

Practice distinguishing internal dbt transformations from contract-bearing analytic models.

## Tasks

1. Identify which models are internal and which are consumer-facing.
2. Compare flexible evolution versus stronger contract rules.
3. Write one grain and semantics rule for a downstream-facing model.

## Worksheet

### Scenario Restatement

Problem:

Constraints:

### Option Comparison

Option 1:

Option 2:

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

The dbt project is growing, and teams want freedom to refactor internals, but dashboards and analysts need a smaller set of models with stable grain and semantics.

Constraints:

- not every model is equally important to consumers
- refactoring internal logic should stay possible
- downstream-facing metrics must remain understandable

### Option Comparison

Option 1:

Treat most dbt models as flexible and allow consumer teams to adapt as they go.

Option 2:

Separate internal models from contract-bearing analytic models and enforce stronger rules only on the downstream-facing layer.

### Trade-Off Review

Recovery and failure handling:

Option 2 is safer because contract-bearing models can be validated more explicitly and incident impact is easier to trace.

Contract stability:

Option 2 wins because grain, column meaning, and semantic expectations become explicit for the models that matter most.

Operational complexity:

Option 1 is simpler administratively, but it spreads ambiguity into dashboard logic and analyst workarounds.

Team ownership and maintainability:

Option 2 keeps transformation freedom inside the project while clarifying which models require tighter stewardship.

### Final Decision

Chosen option:

Option 2 with a clear split between internal models and contract-bearing downstream models.

Why it wins:

It preserves refactoring speed where flexibility is useful and adds stronger control only where business-facing trust is required.

Why the other option loses:

If every model stays equally flexible, consumer-facing semantics drift too easily and documentation never catches up.

### Open Risks

- who decides when an internal model becomes consumer-facing
- how to keep contract-bearing model documentation current during rapid delivery

### Personal System Capture

Decision journal entry:

Use stronger contract rules on dbt outputs that serve downstream business decisions, not uniformly across all transformation layers.

Mistake to log:

The first instinct was to govern every model the same way, which ignored the difference between internal changeability and consumer-facing trust.