# AI Technical Writing

## Goal

Use AI to improve technical writing without losing precision.

## Read Before

- `../../workflows/ai-for-technical-writing.md`
- `../../developer-communication/comparisons-by-context.md`
- `../../developer-communication/writing-better-issues.md`

## Read After

- `../../developer-communication/practice/issue-writing-exercise.md`
- `../../developer-communication/practice/pr-description-exercise.md`
- `../../personal-operating-model/note-capture.md`
- `../../personal-operating-model/prompt-journal.md`

## Tasks

1. Write a raw issue description or architecture summary yourself.
2. Ask AI to improve structure and clarity.
3. Review the rewrite for lost constraints or false certainty.
4. Produce a final version that is both clearer and technically accurate.

## Deliverable

Keep three versions:

- original
- AI-assisted rewrite
- final reviewed version

Then explain what changed and why.

## Evaluation Sheet

Score the final version from 1 to 5:

- clarity: can another engineer understand the message quickly
- completeness: are scope, constraints, and next action visible
- technical honesty: are uncertainty and assumptions explicit
- structure quality: does the text guide the reader cleanly
- conciseness: does the text remove noise without losing meaning

Use this interpretation:

- 1-2: weak or misleading
- 3: acceptable but still creates friction
- 4: strong and usable
- 5: precise, readable, and review-ready

## Worksheet Template

### Original Version

Paste your raw issue, design note, or architecture summary here:

### AI-Assisted Rewrite

Paste the AI rewrite here:

### Final Reviewed Version

Paste the final reviewed text here:

### Personal System Capture

Decision journal entry:

Mistake to log:

### Scorecard

- clarity: __/5
- completeness: __/5
- technical honesty: __/5
- structure quality: __/5
- conciseness: __/5

Lowest score and why:

Evidence for the score:

### Reflection

- what got clearer:
- what AI improved well:
- what AI weakened or over-smoothed:
- what still needs work:

## Working Rule

If the AI rewrite sounds more polished but less precise, reject the polish and restore the technical substance.

## Filled Example

### Original Version

The daily bronze ingestion job is failing after upstream changed the schema. The pipeline cannot process the new files and downstream models are blocked. We should probably update the parser.

### AI-Assisted Rewrite

The daily bronze ingestion job fails after the upstream schema change, and downstream models are now blocked because the pipeline cannot process the new files.

We likely need to update the parser to support the new schema.

### Final Reviewed Version

The daily bronze ingestion job fails when it processes files produced with upstream schema version `2026-03`.

Impact:

- downstream silver models are blocked until the bronze batch succeeds

Known facts:

- the previous schema sample still succeeds
- the failure occurs in parsing before transformation begins

Open question:

- whether the root cause is strict parser behavior or stale schema mapping

Next action:

- confirm the intended schema-handling rule and then update either parser tolerance or schema mapping explicitly

### Personal System Capture

Decision journal entry:

Technical writing should preserve uncertainty, constraints, and next action even when AI makes the prose smoother.

Mistake to log:

The AI rewrite improved fluency but did not automatically preserve reproduction and constraint detail.

### Example Scorecard

- clarity: 4/5
- completeness: 4/5
- technical honesty: 5/5
- structure quality: 4/5
- conciseness: 4/5

Lowest score and why:

Completeness is still not 5 because reproduction details are not included.

Evidence for the score:

The note explains impact, facts, and the next action, but it does not yet tell another engineer exactly how to reproduce the failure locally.

### Example Reflection

- what got clearer: the failure is now tied to a specific schema version and pipeline stage
- what AI improved well: it made the opening sentence more readable
- what AI weakened or over-smoothed: it turned uncertainty into a premature recommendation about updating the parser
- what still needs work: reproduction details and owner assignment