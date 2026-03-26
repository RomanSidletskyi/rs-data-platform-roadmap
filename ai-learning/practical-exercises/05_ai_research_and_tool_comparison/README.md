# AI Research And Tool Comparison

## Goal

Learn how to compare tools and workflows without turning the process into hype-driven tool collecting.

## Read Before

- `../../comparisons/ai-tools-by-task.md`
- `../../comparisons/best-stacks-by-scenario.md`
- `../../workflows/ai-for-research.md`
- `../../architecture-examples/README.md`
- `../../architecture-practice/README.md`

## Read After

- `../../tools/README.md`
- `../../personal-operating-model/decision-journal.md`
- `../../personal-operating-model/mistakes-log.md`
- `../../workflows/design-review-prep.md`
- `../../personal-operating-model/weekly-review.md`

## Tasks

1. Pick one real task such as code review, architecture comparison, or technical writing.
2. Compare at least three tools for that task.
3. Write down strengths, weaknesses, and failure modes.
4. Choose one minimal stack and justify it.
5. Re-evaluate the choice after actual use.

## Deliverable

Create a short decision note that explains:

- the task
- the candidate tools
- the final choice
- why the rejected tools were not chosen
- what risk or ambiguity would trigger a review of the stack later

## Failure Mode To Avoid

Do not stop at a neat comparison table.

If you cannot explain what failed in the first tool choice, what evidence changed your mind, or what would trigger a re-review, the exercise is still shallow.

## Evaluation Sheet

Score the final comparison from 1 to 5:

- task framing: is the real task concrete enough to compare tools meaningfully
- comparison fairness: are tools compared by relevant criteria rather than brand impression
- trade-off quality: are strengths, weaknesses, and failure modes explicit
- stack discipline: did you choose a minimal usable stack instead of collecting tools
- decision defensibility: can another engineer understand and challenge the final choice

Use this interpretation:

- 1-2: hype-driven comparison with weak reasoning
- 3: useful but still generic or incomplete
- 4: strong task-based comparison with clear trade-offs
- 5: disciplined research note with a defendable final stack

## Worksheet Template

### Task To Solve

Describe the real task:

Success criteria:

Constraints:

### Candidate Tools

- tool 1:
- tool 2:
- tool 3:

### Comparison Notes

Tool 1 strengths:

Tool 1 weaknesses:

Tool 1 failure modes:

Tool 2 strengths:

Tool 2 weaknesses:

Tool 2 failure modes:

Tool 3 strengths:

Tool 3 weaknesses:

Tool 3 failure modes:

### Final Stack Decision

Chosen tool or minimal stack:

Why it was chosen:

Why the other options were rejected:

### Re-Evaluation After Use

What worked in practice:

What created friction:

Would you keep the same stack:

### Personal System Capture

Decision journal entry:

Mistake to log:

### Scorecard

- task framing: __/5
- comparison fairness: __/5
- trade-off quality: __/5
- stack discipline: __/5
- decision defensibility: __/5

Lowest score and why:

Evidence for the score:

### Reflection

- what assumption changed after real use:
- which tool was overhyped for this task:
- which tool was underestimated:
- what you would recommend now:

## Filled Example

### Task To Solve

Describe the real task:

Choose a minimal AI stack for comparing storage-layer options and writing a short architecture note.

Success criteria:

- the stack should support comparison, synthesis, and clean writing
- it should not require juggling too many tools

Constraints:

- one-person learning workflow
- technical accuracy matters more than flashy output

### Candidate Tools

- tool 1: ChatGPT
- tool 2: Claude
- tool 3: Perplexity

### Comparison Notes

Tool 1 strengths:

Strong iterative dialogue and structured comparison support.

Tool 1 weaknesses:

Can sound confident before evidence is checked.

Tool 1 failure modes:

Premature synthesis without enough grounding.

Tool 2 strengths:

Often strong at structured reasoning and rewriting long-form technical notes.

Tool 2 weaknesses:

Still needs external validation for factual claims.

Tool 2 failure modes:

Elegant wording can hide uncertain assumptions.

Tool 3 strengths:

Useful for finding source material and narrowing the search space quickly.

Tool 3 weaknesses:

Less suitable as the main workspace for iterative technical writing.

Tool 3 failure modes:

Research can remain shallow if source quality is not checked carefully.

### Final Stack Decision

Chosen tool or minimal stack:

Perplexity for fast discovery plus one main reasoning and writing tool such as ChatGPT.

Why it was chosen:

This stack stays small while covering search, comparison, and writing.

Why the other options were rejected:

Using all three as equal primary tools adds switching cost without enough extra value for one-person workflow.

### Re-Evaluation After Use

What worked in practice:

Perplexity narrowed the source landscape quickly, while ChatGPT helped turn notes into a cleaner comparison.

What created friction:

It was easy to trust the synthesized comparison too early before checking source quality.

Would you keep the same stack:

Yes, but only with an explicit source-validation step before final writing.

### Personal System Capture

Decision journal entry:

Keep one discovery tool and one main reasoning tool unless a third tool changes the decision quality enough to justify switching cost.

Mistake to log:

Multiple primary reasoning tools created more context switching than better judgment.

### Example Scorecard

- task framing: 5/5
- comparison fairness: 4/5
- trade-off quality: 5/5
- stack discipline: 5/5
- decision defensibility: 4/5

Lowest score and why:

Decision defensibility is not 5 because team context and budget constraints were not deeply analyzed.

Evidence for the score:

The stack fits a solo workflow well, but a different team setup could change the decision materially.

### Example Reflection

- what assumption changed after real use: using more tools did not produce proportionally better decisions
- which tool was overhyped for this task: the idea of keeping multiple primary reasoning tools open at once
- which tool was underestimated: fast discovery tools when used with disciplined validation
- what you would recommend now: keep one discovery tool and one main reasoning tool, then validate before finalizing