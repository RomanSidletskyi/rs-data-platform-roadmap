# Debugging Prompts

Use these prompts when something is failing and you need the AI to help isolate the problem instead of guessing fixes.

## Good Debugging Input

Provide:

- the exact error or wrong behaviour
- what you expected instead
- the relevant code or command
- what you already tried
- any known constraints about environment or data

## Example Prompts

### Root Cause Prompt

"Help me debug this failure. Based on the error, code, and execution context, list the most likely root causes in order and explain how to test each hypothesis quickly."

### Reproduction Prompt

"Suggest the smallest reproducible test for this issue so I can separate environment problems from code problems."

### Fix Review Prompt

"Here is the suspected fix. Review whether it addresses the root cause or only hides the symptom."

## Rule

Do not ask AI for a fix before it has helped structure the hypotheses.
