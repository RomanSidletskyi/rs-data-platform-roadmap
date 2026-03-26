# AI Pipeline Design

## Goal

Use AI to compare pipeline designs and strengthen architecture reasoning.

## Read Before

- `../../workflows/ai-for-project-design.md`
- `../../workflows/ai-for-research.md`
- `../../comparisons/best-stacks-by-scenario.md`
- `../../how-to-think-like-a-data-platform-architect-with-ai.md`
- `../../architecture-examples/README.md`
- `../../architecture-practice/README.md`

## Read After

- `../../workflows/design-review-prep.md`
- `../../developer-communication/architecture-notes.md`
- `../../developer-communication/design-review-communication.md`
- `../../personal-operating-model/decision-journal.md`
- `../../personal-operating-model/mistakes-log.md`
- `../../personal-operating-model/note-capture.md`

## Scenario

You need to design a small data pipeline or platform flow.

The difficulty is not only implementation.

The difficulty is choosing a direction that balances simplicity, reliability, and future evolution.

## Tasks

1. Write a short scenario with constraints.
2. Ask AI for two to four design options.
3. Ask for trade-offs around recovery, schema evolution, operating complexity, and downstream contracts.
4. Choose one option and justify it in your own words.
5. Write a small architecture note.
6. Ask AI to review the note for weak assumptions.

## Deliverables

- scenario statement
- compared options
- final architecture note
- one list of open questions or risks

## What This Exercise Trains

- architecture comparison
- trade-off reasoning
- converting AI output into a human design decision
- turning a design choice into a reviewable architecture position

## Failure Mode To Avoid

Do not let AI choose the design for you.

The decision must still be defensible in your own words.

Do not stop at the chosen option.

You should also be able to state the rejected option, open risks, and what would trigger a design review.

## Evaluation Sheet

Score the final design exercise from 1 to 5:

- scenario framing: are constraints and goals clear enough to compare designs
- option quality: are the design alternatives meaningfully different and realistic
- trade-off reasoning: are recovery, evolution, complexity, and contracts discussed clearly
- decision quality: is the final choice defended in your own words
- open-risk visibility: are unresolved questions made explicit instead of hidden

Use this interpretation:

- 1-2: shallow architecture comparison with weak ownership of the decision
- 3: useful comparison but still generic or under-specified
- 4: strong architecture exercise with explicit trade-offs
- 5: disciplined design reasoning with clear decision boundaries and visible open risks

## Worksheet Template

### Scenario Statement

Problem to solve:

Constraints:

Non-goals:

### Compared Options

Option 1:

Option 2:

Option 3 if needed:

### Trade-Off Review

Recovery implications:

Schema evolution implications:

Operating complexity:

Downstream contract implications:

### Final Architecture Note

Chosen option:

Why it was chosen:

Why the other options were not chosen:

### Open Questions Or Risks

- risk 1:
- risk 2:

### Personal System Capture

Decision journal entry:

Mistake to log:

### Scorecard

- scenario framing: __/5
- option quality: __/5
- trade-off reasoning: __/5
- decision quality: __/5
- open-risk visibility: __/5

Lowest score and why:

Evidence for the score:

### Reflection

- which option looked best too early:
- what AI compared well:
- what AI simplified too much:
- what still needs design review with humans:

## Filled Example

### Scenario Statement

Problem to solve:

Design a small customer-events pipeline that lands raw files, validates schema changes, and publishes stable curated tables for analytics.

Constraints:

- small team with limited operations capacity
- Spark-first processing
- downstream analysts need stable contracts

Non-goals:

- full multi-engine optimization in phase one

### Compared Options

Option 1:

Land raw files and transform directly into curated tables without a distinct validation stage.

Option 2:

Use separate bronze, validation, and curated stages with early schema checks.

Option 3 if needed:

Add a contract-review gate before curated publish for breaking changes.

### Trade-Off Review

Recovery implications:

Option 2 makes replay and failure isolation clearer than direct raw-to-curated transformation.

Schema evolution implications:

Separate validation makes contract changes more visible before curated tables are affected.

Operating complexity:

Option 2 adds one more step, but it reduces hidden debugging cost later.

Downstream contract implications:

Curated publish is more trustworthy when validation happens earlier and explicitly.

### Final Architecture Note

Chosen option:

Option 2 with an explicit validation stage, plus a lightweight contract-review check for breaking changes.

Why it was chosen:

It balances operational simplicity with stronger trust boundaries and better failure diagnosis.

Why the other options were not chosen:

Direct raw-to-curated flow is simpler on paper but too brittle when schema changes arrive.

### Open Questions Or Risks

- how strict should validation be for optional fields
- when should a contract-review gate block release versus warn only

### Personal System Capture

Decision journal entry:

Use a dedicated validation boundary when replay safety and downstream trust matter more than minimizing stage count.

Mistake to log:

The simplest flow looked best too early because recovery and contract failure modes were not compared first.

### Example Scorecard

- scenario framing: 5/5
- option quality: 4/5
- trade-off reasoning: 5/5
- decision quality: 4/5
- open-risk visibility: 5/5

Lowest score and why:

Decision quality is not 5 because the contract-review gate still needs clearer ownership and escalation rules.

Evidence for the score:

The direction is defendable, but the governance mechanism is not fully defined yet.

### Example Reflection

- which option looked best too early: the simplest raw-to-curated flow looked attractive before recovery and contract risks were considered
- what AI compared well: operational simplicity versus trust boundaries
- what AI simplified too much: governance ownership for contract review
- what still needs design review with humans: blocking rules for schema changes