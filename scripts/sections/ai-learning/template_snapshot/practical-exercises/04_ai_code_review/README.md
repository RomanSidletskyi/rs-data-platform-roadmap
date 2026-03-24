# AI Code Review

## Goal

Use AI as a review assistant to find bugs, regressions, weak assumptions, and missing tests.

## Read Before

- `../../workflows/ai-for-debugging.md`
- `../../developer-communication/review-communication-comparison.md`
- `../../tools/github-copilot.md`

## Read After

- `../../developer-communication/practice/review-reply-exercise.md`
- `../../personal-operating-model/mistakes-log.md`
- `../../personal-operating-model/weekly-review.md`

## Scenario

You already have an implementation.

Now the goal is not generation.

The goal is to improve review quality.

## Tasks

1. Choose a small change set or function.
2. Ask AI to review it like a senior engineer.
3. Request findings first, ordered by severity.
4. Compare AI findings with your own review.
5. Decide which findings are real and which are noise.
6. Add or update tests for the confirmed risks.

## Deliverables

- the reviewed code or change summary
- AI findings
- your accepted and rejected findings
- follow-up fixes or tests

## What This Exercise Trains

- review quality
- signal versus noise filtering
- validation after review

## Failure Mode To Avoid

Do not treat every AI review comment as equally important.

Good review still requires prioritization.

## Evaluation Sheet

Score the final review outcome from 1 to 5:

- severity judgment: did you rank the real problems above the cosmetic ones
- signal filtering: did you reject weak or noisy AI comments correctly
- evidence quality: are accepted findings tied to behavior, code paths, or test gaps
- follow-up quality: did the exercise end with a concrete fix, test, or explicit rejection
- review clarity: can another engineer understand what mattered and why

Use this interpretation:

- 1-2: noisy review with weak prioritization
- 3: useful but still mixed with avoidable noise
- 4: strong review with clear prioritization and evidence
- 5: senior-level review discipline with minimal noise and strong follow-up

## Worksheet Template

### Change Summary

What code, function, or diff did you review:

### AI Findings

- finding 1:
- finding 2:
- finding 3:

### Accepted Findings

- accepted finding 1 and why:
- accepted finding 2 and why:

### Rejected Findings

- rejected finding 1 and why:
- rejected finding 2 and why:

### Follow-Up Action

Fix added:

Test added:

Open risk left unresolved:

### Personal System Capture

Decision journal entry:

Mistake to log:

### Scorecard

- severity judgment: __/5
- signal filtering: __/5
- evidence quality: __/5
- follow-up quality: __/5
- review clarity: __/5

Lowest score and why:

Evidence for the score:

### Reflection

- which AI finding was most useful:
- which AI finding was noise:
- what you caught that AI missed:
- what you would review differently next time:

## Filled Example

### Change Summary

What code, function, or diff did you review:

A refactor that moved required-field checks from the transformation step into a dedicated validation helper.

### AI Findings

- the new validation helper may reject records that previously passed through partially
- tests do not appear to cover unknown optional fields
- variable naming in the helper could be clearer

### Accepted Findings

- accepted finding 1 and why: earlier failure changes runtime behavior and needs explicit review because it affects pipeline strictness
- accepted finding 2 and why: the absence of an optional-field test leaves a real schema-evolution gap

### Rejected Findings

- rejected finding 1 and why: the naming comment is low-priority noise compared with behavior and test coverage

### Follow-Up Action

Fix added:

Kept the validation boundary but documented that missing required fields now fail before transformation.

Test added:

Added a test showing that unknown optional fields do not fail the batch.

Open risk left unresolved:

The team still needs to confirm whether all currently required fields are truly contract-level requirements.

### Personal System Capture

Decision journal entry:

Treat behavior-changing validation shifts as high-severity review items and require explicit tests around the new boundary.

Mistake to log:

It was too easy to focus on naming noise and miss the larger behavioral change around early failure semantics.

### Example Scorecard

- severity judgment: 5/5
- signal filtering: 4/5
- evidence quality: 5/5
- follow-up quality: 5/5
- review clarity: 4/5

Lowest score and why:

Review clarity is not 5 because the rejected low-priority comment could still be summarized more cleanly.

Evidence for the score:

The review correctly focused on behavioral risk and missing tests, but the write-up could separate major and minor comments more sharply.

### Example Reflection

- which AI finding was most useful: the missing optional-field test
- which AI finding was noise: the naming suggestion
- what you caught that AI missed: the need to document the stricter failure boundary
- what you would review differently next time: ask for test-gap analysis explicitly earlier in the prompt