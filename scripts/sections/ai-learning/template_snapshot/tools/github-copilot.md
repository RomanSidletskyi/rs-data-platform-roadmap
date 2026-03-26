# GitHub Copilot

GitHub Copilot is an editor-native, repository-aware implementation tool for scoped coding, review, refactoring, and validation support.

## What It Is

Use GitHub Copilot when the work depends on real files, local conventions, and concrete code behavior rather than abstract discussion alone.

## Best For

- repository-aware implementation help
- targeted file edits
- code review assistance
- generating or refining tests
- navigating larger codebases while changing code

## Not Good For

- broad market research
- early technology strategy with unclear constraints
- replacing architecture thinking with generated code

## Strengths

- strong local codebase context
- useful for small and medium scoped changes
- good second-pass assistant for tests, edge cases, and review

## Weaknesses

- can encourage fast acceptance of changes
- still needs human review and validation
- weaker than chat tools for wide conceptual exploration

## Best Use Cases

- implementing scoped changes in existing files
- reviewing code for bugs, regressions, and missing tests
- expanding validation after a feature change
- refactoring code while preserving behavior
- understanding how a symbol is used across a codebase

## Main Risks

- asking for too much change at once
- accepting generated patches without reasoning through behavior
- confusing editor convenience with correctness

## How To Use It Well

- define the exact behavior change
- inspect the relevant files first
- ask for the smallest viable implementation
- review the patch carefully
- run tests or checks

## How Not To Use It

- do not ask for a large implementation before reading the codebase
- do not skip validation because the patch looks plausible

## Who Benefits Most

- developers working in real repositories
- engineers doing refactors, tests, and targeted fixes

## Primary Modes

- coding
- review

## Example Prompt

```text
Review this change like a senior engineer. Focus on behavioral regressions, missing tests, unsafe assumptions, and whether the implementation matches the existing repository patterns.
```

## Rule

Treat suggestions as proposed code, not trusted code.

Review behavior, interfaces, and validation every time.
