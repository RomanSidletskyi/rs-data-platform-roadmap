# How To Think Like A Data Platform Architect With AI

This guide connects the entire `ai-learning/` section into one progression model for architecture-minded growth.

The target is not prompt fluency.

The target is stronger judgment about boundaries, contracts, failure modes, recovery, cost, and long-term maintainability.

## What Changes Between Builder And Architect Thinking

Builder thinking often asks:

- how do I implement this
- which tool is faster
- what code should I write next

Architect thinking asks:

- where should this responsibility live
- what assumptions are becoming contracts
- what breaks during replay, recovery, or partial failure
- which trade-off is acceptable now and dangerous later
- what design stays understandable for other engineers

## How AI Should Help At This Level

AI is useful here when it helps you:

- compare several designs before coding
- make trade-offs explicit
- challenge hidden assumptions
- convert scattered research into structured decisions
- prepare stronger architecture notes and review discussions

AI is harmful here when it:

- creates elegant prose without real constraints
- hides missing ownership boundaries
- makes complex systems sound simpler than they are

## Progression Model

### Stage 1: Clarify The Scenario

Start with:

- `workflows/ai-for-project-design.md`
- `workflows/ai-for-research.md`

Questions to ask:

- what problem is actually being solved
- what are the real constraints and non-goals
- which failures matter most

### Stage 2: Compare Options Deliberately

Read:

- `comparisons/ai-tools-by-task.md`
- `comparisons/best-stacks-by-scenario.md`

Then use:

- `architecture-examples/README.md`
- `architecture-practice/README.md`

Your goal is not one answer.

Your goal is a defendable comparison.

### Stage 3: Inspect Architecture Cases

Use the examples layer to study recurring platform tensions:

- pipeline boundaries
- recovery and replay
- schema contracts
- orchestration boundaries
- serving semantics

Files to start with:

- `architecture-examples/bronze-validation-curated-boundaries.md`
- `architecture-examples/delta-vs-parquet-recovery.md`
- `architecture-examples/replay-and-idempotency.md`

### Stage 4: Turn Thinking Into Decisions

Use:

- `personal-operating-model/decision-journal.md`
- `personal-operating-model/mistakes-log.md`
- `developer-communication/architecture-notes.md`
- `workflows/adr-writing-with-ai.md`

At this stage, AI should help expose gaps in reasoning, not write the reasoning for you.

### Stage 5: Pressure-Test The Decision

Use:

- `workflows/design-review-prep.md`
- `developer-communication/design-review-communication.md`
- `anti-patterns/common-ai-failures.md`

Ask:

- what would a skeptical reviewer challenge here
- which contract or ownership line is still blurry
- where is the recovery story still weak

## Architecture Heuristics To Practice

- separate implementation detail from contract
- distinguish recovery logic from happy-path logic
- ask where validation belongs, not only how validation works
- treat replay as a design case, not an afterthought
- decide what should be stable for downstream consumers
- keep orchestration as control flow, not business logic

## Code-Backed Thinking Example

```python
def validate_and_publish(events, required_fields):
    valid = []
    for event in events:
        missing = [field for field in required_fields if field not in event]
        if missing:
            raise ValueError(f"Missing fields: {missing}")
        valid.append(normalize(event))
    write_table("curated.customer_events", valid)
```

A builder may ask:

- is this function clean enough

An architect should ask:

- should validation and publish be in the same step
- who owns `required_fields`
- what happens to replay after a partial failure
- what downstream contract becomes stable here

## Recommended Route

1. `workflows/ai-for-project-design.md`
2. `workflows/ai-for-research.md`
3. `comparisons/best-stacks-by-scenario.md`
4. `architecture-examples/README.md`
5. `architecture-practice/README.md`
6. `personal-operating-model/decision-journal.md`
7. `personal-operating-model/mistakes-log.md`
8. `workflows/design-review-prep.md`
9. `developer-communication/design-review-communication.md`
10. `practical-exercises/03_ai_pipeline_design/README.md`

## Rule

You are thinking more architecturally when you can explain not only the chosen design, but also the rejected alternatives, accepted trade-offs, open risks, and contract boundaries.