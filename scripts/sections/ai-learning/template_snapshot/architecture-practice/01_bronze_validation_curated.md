# Bronze, Validation, Curated Practice

## Read Before

- `../architecture-examples/bronze-validation-curated-boundaries.md`
- `../workflows/ai-for-project-design.md`

## Goal

Practice deciding where validation belongs in a multi-stage data flow.

## Tasks

1. Restate the scenario.
2. Compare direct raw-to-curated flow against explicit validation-stage flow.
3. Decide where contract trust should become stable.
4. Capture the chosen boundary in your own words.

## Worksheet

### Scenario Restatement

Problem:

Constraints:

### Option Comparison

Option 1: raw to curated directly

Option 2: validation before curated publish

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

The platform needs stable curated tables for analysts, but the team is small and does not want too many stages.

Constraints:

- Spark-first flow
- limited operations capacity
- schema drift is realistic

### Option Comparison

Option 1: raw to curated directly

- simpler to implement
- weakest failure isolation
- contract problems appear late

Option 2: validation before curated publish

- one extra stage to operate
- clearer trust boundary before publish
- easier replay diagnosis when schema or quality issues appear

### Trade-Off Review

Recovery and failure handling:

Option 2 wins because failures are isolated before publish and replay can restart from a cleaner boundary.

Contract stability:

Option 2 wins because curated outputs only receive validated records and schema changes become visible earlier.

Operational complexity:

Option 1 is simpler on paper, but it hides debugging cost inside transformation logic.

Team ownership and maintainability:

Option 2 clarifies that validation rules are owned before curated publishing rules.

### Final Decision

Chosen option:

Option 2 with an explicit validation boundary.

Why it wins:

It creates a cleaner trust boundary and reduces hidden replay and contract risk.

Why the other option loses:

The direct path is simpler initially but makes schema and data-quality failures harder to isolate and explain.

### Open Risks

- who owns validation rule changes over time
- when validation should warn instead of blocking publish

### Personal System Capture

Decision journal entry:

Use a dedicated validation boundary when downstream trust and replay diagnosis matter more than one less stage in the pipeline.

Mistake to log:

The direct flow looked attractive too early because the hidden debugging cost was not made explicit at first.