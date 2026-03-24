# AI For Project Design

## Goal

Use AI to sharpen project scope and architecture before implementation expands.

## Scenario

You need to design a project, pipeline, or service boundary.

The risk is not only choosing the wrong component.

The risk is choosing an architecture that hides trade-offs, recovery cost, ownership confusion, or contract instability.

## Workflow

1. Write the scenario and intended outcome yourself.
2. Ask AI to propose architecture options.
3. Ask AI to compare them by trade-offs, operational complexity, and failure recovery.
4. Choose one direction and restate it in your own words.
5. Convert it into project structure, interfaces, and milestones.

## Example Prompt

```text
Design 3 options for a small data platform flow that ingests raw files, validates schema drift, and publishes curated tables for analytics. Compare the options by failure isolation, replay cost, contract stability, operational complexity, and team ownership boundaries.
```

## Validation

Before choosing a design, check:

- are the options meaningfully different
- are contracts and ownership boundaries explicit
- is failure recovery described, not implied
- does the design match your current learning or delivery scope

## Failure Modes

- letting AI generate one oversized architecture with no alternatives
- choosing by novelty instead of constraints
- converting a broad idea into implementation without an explicit boundary model

## Why This Works

Architecture quality improves when options are compared deliberately and then translated into explicit interfaces, stages, and ownership lines.

## Real Example

Scenario:

A team wants bronze, silver, and curated analytics layers for customer events, but only has one data engineer and limited operations capacity.

Useful AI comparison:

- direct raw-to-curated flow
- bronze plus curated with lightweight validation
- bronze plus validation plus curated with explicit contract gate

Architecture-heavy output that should emerge:

- where schema validation happens
- which layer owns replay safety
- where downstream contracts become stable
- what incidents can be isolated without full reprocessing

Code-backed case:

```python
def publish_curated(validated_events):
	curated_rows = [normalize(event) for event in validated_events]
	write_table("curated.customer_events", curated_rows)
```

The code is simple.

The architectural question is not the loop.

The architectural question is what guarantees `validated_events` must satisfy before this publish step is even allowed.

## Failure Mode To Avoid

Do not let AI produce a large architecture that ignores the learning goal or your available time.
