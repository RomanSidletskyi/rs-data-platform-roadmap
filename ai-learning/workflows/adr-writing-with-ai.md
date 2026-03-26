# ADR Writing With AI

## Goal

Use AI to improve architecture decision records by making trade-offs, assumptions, and rejected options more explicit.

## Scenario

You already have a real decision to document, but the reasoning is incomplete, the trade-offs are blurry, or the rejected options are underexplained.

## Workflow

1. Write the problem statement yourself.
2. List constraints and options.
3. Ask AI to highlight missing trade-offs or consequences.
4. Draft the ADR.
5. Ask AI to tighten clarity and reveal weak assumptions.
6. Keep final ownership of the decision logic yourself.

## Example Prompt

```text
Review this architecture decision record. Identify missing trade-offs, hidden assumptions, and places where the chosen option is described without enough comparison to rejected alternatives.
```

## Validation

Before finalizing the ADR, check:

- does it explain the context clearly
- are at least two real options compared
- are accepted trade-offs explicit
- is there a trigger that would justify revisiting the decision later

## Failure Modes

- letting AI write polished architecture prose before the decision exists
- documenting only the chosen option and not why others lost
- hiding uncertainty under cleaner writing

## Why This Works

ADR quality improves when AI is used to expose gaps in reasoning, not to fabricate the decision logic.

## Real Example

Decision:

Adopt Delta Lake as the standard table layer for Spark-first training projects instead of raw Parquet plus custom conventions.

Architecture-heavy comparison points:

- metadata and transaction behavior
- replay and recovery confidence
- schema evolution control
- portability trade-offs if multi-engine access becomes important later

Code-backed case:

```python
(
	spark.read.format("json")
	.load(raw_path)
	.write.format("delta")
	.mode("append")
	.save(bronze_path)
)
```

The code is not the ADR.

The ADR must explain why the table format and operational model were chosen, what cost was accepted, and what would make the choice worth revisiting.

## Failure Mode To Avoid

Do not let AI generate architecture prose before the decision itself is understood.