# Airflow Logic Boundaries Practice

## Read Before

- `../architecture-examples/airflow-dag-vs-pipeline-logic.md`
- `../workflows/design-review-prep.md`

## Goal

Practice deciding how thin DAGs should stay and what logic belongs in reusable code.

## Tasks

1. Compare DAG-heavy and module-heavy design choices.
2. Evaluate testability, reuse, and retry semantics.
3. Choose one ownership model for orchestration versus domain logic.

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

Airflow DAGs are becoming large because pipeline-specific branching, data checks, and transformation rules are written directly in orchestration code.

Constraints:

- the team needs retry clarity
- code should stay testable outside Airflow
- some orchestration-specific decisions still belong in the DAG

### Option Comparison

Option 1:

Keep most logic in DAG files for local readability and faster iteration.

Option 2:

Keep DAGs thin and move domain logic into reusable modules, leaving orchestration concerns in Airflow.

### Trade-Off Review

Recovery and failure handling:

Option 2 is stronger because retry behavior and failure boundaries are easier to reason about when business logic is not mixed into orchestration wiring.

Contract stability:

Option 2 improves stability because reusable code can be tested and versioned independently from scheduler configuration.

Operational complexity:

Option 1 may feel simpler during early development, but large DAG files become hard to review, test, and refactor.

Team ownership and maintainability:

Option 2 gives a cleaner ownership model: Airflow expresses when and in what order tasks run, while modules implement what the pipeline does.

### Final Decision

Chosen option:

Option 2 with thin DAGs and reusable pipeline modules.

Why it wins:

It improves testability, reuse, and failure reasoning without removing Airflow's role as the orchestration layer.

Why the other option loses:

DAG-heavy design hides too much domain logic in a scheduler-specific format and becomes expensive to maintain.

### Open Risks

- where to draw the line for logic that is genuinely orchestration-specific
- how to prevent abstraction layers from becoming too fragmented for a small team

### Personal System Capture

Decision journal entry:

Keep orchestration code responsible for scheduling and dependency control, and move reusable business logic into regular code modules.

Mistake to log:

Early convenience in DAG files was overrated compared with the long-term cost of poor testability and scheduler-coupled logic.