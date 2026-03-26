# Design Review Prep

## Goal

Use AI to prepare for design reviews with stronger explanations, clearer trade-offs, and better follow-up questions.

## Scenario

You are going into a design review, architecture discussion, or technical alignment meeting.

The failure mode is arriving with only the polished story and none of the hard answers.

## Workflow

1. Write a short description of the design.
2. List the intended benefits and known trade-offs.
3. Ask AI to challenge the weak assumptions.
4. Ask AI to generate likely review questions.
5. Rehearse concise answers.
6. Enter the review with a clear list of open questions and decision boundaries.

## Example Prompt

```text
Act as a skeptical senior engineer reviewing this design. Ask the most likely questions about scalability, recovery, schema evolution, ownership boundaries, and operational complexity.
```

## Validation

Before the review, check:

- can you explain the design in two or three concise paragraphs
- can you defend the main trade-offs without reading notes verbatim
- do you know which assumptions are still open
- do you know what evidence supports the design choice

## Failure Modes

- preparing only polished explanations
- rehearsing answers without exposing weak assumptions
- entering the review with no explicit open questions

## Why This Works

Good review prep is not performance polish.

It is preloading the hard parts: assumptions, trade-offs, risks, and likely objections.

## Real Example

Design under review:

A bronze-validation-curated pipeline where schema changes are checked before publish.

Likely review questions AI should help surface:

- who owns the schema contract
- what blocks publish versus warns only
- how replay works after a partial failure
- what happens to downstream analysts when a breaking field change appears

Code-backed case:

```python
def validate_schema(event, expected_fields):
	missing = [field for field in expected_fields if field not in event]
	if missing:
		raise ValueError(f"Missing required fields: {missing}")
```

The review question is not whether this helper is syntactically fine.

The real question is where in the architecture this validation belongs and what consequences it has for publish reliability.

## Failure Mode To Avoid

Do not prepare only polished explanations.

Prepare for the hardest questions too.