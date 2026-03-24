# Orchestration Boundaries Practice

## Read Before

- `../architecture-examples/orchestration-boundaries.md`
- `../workflows/ai-for-project-design.md`

## Goal

Practice separating orchestration responsibilities from business and transformation logic.

## Tasks

1. Identify what should stay in the orchestrator.
2. Identify what should move into reusable modules.
3. Decide how testing and ownership should work across that boundary.

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

The orchestrator currently handles scheduling well, but more validation and transformation behavior is being embedded directly into orchestration tasks, making the pipeline harder to test and reuse.

Constraints:

- retry semantics must remain clear
- local testing should be possible without the orchestrator
- the team still needs enough orchestration metadata for visibility and control

### Option Comparison

Option 1:

Keep orchestration tasks as the main home for most pipeline behavior.

Option 2:

Use the orchestrator as a control plane and move reusable transformation logic into modules with clear interfaces.

### Trade-Off Review

Recovery and failure handling:

Option 2 is stronger because retry boundaries stay visible while transformation failures can be tested outside scheduling code.

Contract stability:

Option 2 improves stability because reusable modules can define cleaner interfaces than orchestration-specific task code.

Operational complexity:

Option 1 may look simpler when the project is small, but complexity accumulates inside orchestration code where reuse and debugging are weaker.

Team ownership and maintainability:

Option 2 creates a better split: orchestration owns dependencies and execution order, while pipeline modules own validation and transformation behavior.

### Final Decision

Chosen option:

Option 2 with the orchestrator as control plane, not the hidden transformation layer.

Why it wins:

It preserves orchestration strengths while keeping the core pipeline logic testable, reusable, and easier to evolve.

Why the other option loses:

When business logic lives mainly in orchestration code, retry behavior, local testing, and long-term maintainability all become harder.

### Open Risks

- how much thin wrapper code is still acceptable inside the orchestrator
- whether the team will over-abstract too early while extracting reusable modules

### Personal System Capture

Decision journal entry:

Use orchestrators to control execution and observability, and keep reusable transformation logic outside scheduler-specific code.

Mistake to log:

The first design assumption favored convenience inside orchestration tasks and underestimated the cost to testing and reuse.