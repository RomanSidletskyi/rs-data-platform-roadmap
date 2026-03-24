# AI Python Refactor

## Goal

Learn how to use AI to improve structure and readability without changing behaviour accidentally.

## Read Before

- `../../tools/github-copilot.md`
- `../../workflows/ai-pair-programming.md`
- `../../comparisons/ai-tools-by-task.md`

## Read After

- `../04_ai_code_review/README.md`
- `../../personal-operating-model/mistakes-log.md`
- `../../personal-operating-model/weekly-review.md`

## Scenario

You have a small Python module that works but is hard to read, hard to test, or mixes responsibilities.

The goal is not to rewrite everything.

The goal is to identify a narrow refactor that makes the code easier to reason about.

## Tasks

1. Pick a small Python file or function with mixed responsibilities.
2. Describe the current behaviour before changing anything.
3. Ask AI for the smallest viable refactor.
4. Review the proposal for hidden behavioural changes.
5. Add or improve tests around the changed area.
6. Write down what got better and what still needs human judgment.

## Deliverables

- before and after code
- a short explanation of the refactor goal
- tests or validation steps
- one note about a risk the AI did not handle automatically

## What This Exercise Trains

- scoped change discipline
- review of generated code
- preservation of behaviour during refactoring

## Failure Mode To Avoid

Do not turn a small refactor into a full rewrite just because AI can generate more code quickly.

## Evaluation Sheet

Score the final refactor outcome from 1 to 5:

- scope control: did the change stay narrow and intentional
- behavior preservation: is the original behavior still protected by tests or checks
- readability improvement: is the code easier to reason about now
- risk awareness: did you identify what AI could have broken silently
- validation quality: are the tests or manual checks strong enough for the changed area

Use this interpretation:

- 1-2: refactor drifted or changed behavior carelessly
- 3: useful refactor but validation or scope control is weak
- 4: strong small refactor with good discipline
- 5: high-signal refactor with clear benefits and strong behavior protection

## Worksheet Template

### Starting Code

File or function under review:

Current responsibility mix or readability problem:

### Refactor Goal

What should improve:

What must not change:

### AI Proposal

Paste the proposed refactor summary here:

### Reviewed Refactor

What you kept:

What you rejected:

Final code summary:

### Validation

Tests added or updated:

Manual checks:

Risk AI did not handle automatically:

### Personal System Capture

Decision journal entry:

Mistake to log:

### Scorecard

- scope control: __/5
- behavior preservation: __/5
- readability improvement: __/5
- risk awareness: __/5
- validation quality: __/5

Lowest score and why:

Evidence for the score:

### Reflection

- what improved most:
- what AI suggested that was risky:
- what still needs human judgment:

## Filled Example

### Starting Code

File or function under review:

`normalize_event(record)` mixes field extraction, validation, default filling, and output shaping in one long block.

Current responsibility mix or readability problem:

The function works, but it interleaves validation and transformation logic, making failures harder to reason about and harder to test in isolation.

### Refactor Goal

What should improve:

Split validation from normalization so the function is easier to read and test.

What must not change:

Valid input must still produce the same normalized output shape.

### AI Proposal

Extract validation into a helper, keep normalization in the main function, and simplify nested conditionals.

### Reviewed Refactor

What you kept:

The helper extraction for required-field checks.

What you rejected:

The AI suggestion to rename several domain fields at the same time, because that increased change scope.

Final code summary:

Validation now runs in a small helper before normalization, while output-shaping logic remains in the original function.

### Validation

Tests added or updated:

- valid event still produces the same normalized structure
- missing required field now fails in the validation helper

Manual checks:

- compared normalized output before and after for the same fixture input

Risk AI did not handle automatically:

The AI proposal did not protect against accidental output-key renaming.

### Personal System Capture

Decision journal entry:

Keep behavior-preserving refactors narrow and reject bundled naming changes unless tests justify the extra scope.

Mistake to log:

AI bundled structural cleanup with domain renaming, which increased regression risk unnecessarily.

### Example Scorecard

- scope control: 5/5
- behavior preservation: 4/5
- readability improvement: 4/5
- risk awareness: 5/5
- validation quality: 4/5

Lowest score and why:

Behavior preservation is not 5 because only the main fixture path was validated, not every edge-case branch.

Evidence for the score:

The refactor keeps the main output stable, but more edge-case fixtures would increase confidence.

### Example Reflection

- what improved most: the function is easier to test and explain
- what AI suggested that was risky: bundled renaming together with structural cleanup
- what still needs human judgment: whether the validation boundary matches business rules