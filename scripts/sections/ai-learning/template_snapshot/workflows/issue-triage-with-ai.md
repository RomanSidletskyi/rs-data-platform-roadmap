# Issue Triage With AI

## Goal

Use AI to improve issue quality during triage without inventing facts.

## Workflow

1. Write down the current symptom.
2. Separate known facts from guesses.
3. Ask AI to suggest missing fields such as impact, reproduction, scope, and likely unknowns.
4. Rewrite the issue so another engineer can understand it quickly.
5. Keep the root cause marked as unknown until verified.

## Example Prompt

```text
Review this bug report and tell me what is missing for effective triage. Focus on reproduction, impact, likely scope, and what assumptions should be marked as unverified.
```

## Failure Mode To Avoid

Do not let AI turn guesses into confident root-cause statements.