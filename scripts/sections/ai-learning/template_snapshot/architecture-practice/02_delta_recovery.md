# Delta Recovery Practice

## Read Before

- `../architecture-examples/delta-vs-parquet-recovery.md`
- `../workflows/ai-for-research.md`

## Goal

Practice choosing a storage-layer direction through recovery and contract reasoning, not only implementation convenience.

## Tasks

1. Compare raw Parquet plus conventions against Delta-style table management.
2. Evaluate replay confidence, partial failure recovery, and downstream trust.
3. Choose one direction for a Spark-first learning platform.

## Worksheet

### Scenario Restatement

Problem:

Constraints:

### Option Comparison

Option 1: raw Parquet plus custom recovery logic

Option 2: Delta-style managed table layer

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

The team needs reliable replay and schema handling in a Spark-first learning platform without building fragile custom recovery rules everywhere.

Constraints:

- Spark-first now
- small team
- operational trust matters more than absolute minimalism

### Option Comparison

Option 1: raw Parquet plus custom recovery logic

- low apparent storage complexity
- more manual replay and consistency burden
- contract behavior depends on team discipline

Option 2: Delta-style managed table layer

- stronger recovery and merge model
- more platform conventions to understand
- clearer operational trust for repeated workloads

### Trade-Off Review

Recovery and failure handling:

Option 2 wins because partial-write and replay semantics are clearer and less dependent on ad hoc team conventions.

Contract stability:

Option 2 provides better support for repeatable merge and schema workflows, which improves downstream trust.

Operational complexity:

Option 1 looks simpler early, but pushes complexity into custom recovery logic.

Team ownership and maintainability:

Option 2 standardizes behavior better across future pipelines.

### Final Decision

Chosen option:

Option 2, Delta-style managed tables.

Why it wins:

Recovery confidence and repeated operational consistency matter more than the minimal simplicity of raw files.

Why the other option loses:

Raw Parquet keeps too much critical behavior in conventions that can drift across projects.

### Open Risks

- how the choice changes if multi-engine interoperability becomes urgent
- how much table-format complexity the current stage of learning should absorb immediately

### Personal System Capture

Decision journal entry:

Choose a richer table layer when recovery trust is a recurring requirement rather than an occasional edge case.

Mistake to log:

Raw file simplicity was overvalued before replay and partial-failure burden were compared explicitly.