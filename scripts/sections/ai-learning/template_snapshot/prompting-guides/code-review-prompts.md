# Code Review Prompts

Use these prompts after you already have a first implementation.

The goal is to surface bugs, regressions, weak assumptions, and missing validation.

## Review Focus Areas

- correctness
- failure handling
- edge cases
- maintainability
- tests and validation gaps

## Example Prompts

### Bug Hunt Prompt

"Review this code for correctness issues, behavioural regressions, and hidden failure modes. Prioritize the findings by severity and cite the specific files or lines involved."

### Test Gap Prompt

"Given this implementation and its current tests, identify the most important missing tests. Explain which bugs could escape without them."

### Refactor Safety Prompt

"I changed this code for readability. Review whether the refactor preserved behaviour, error handling, and public interface expectations."

## Rule

Ask for findings first.

Do not ask only for general feedback, because that produces vague review output.
