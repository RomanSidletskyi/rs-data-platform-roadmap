# Reusable Workflows, Composite Actions, And Repository Structure

## 1. Why Reuse Matters

The first workflow in a repository is usually easy to write.

The fifth similar workflow is where maintainability problems appear.

The tenth similar workflow across several repositories is where bad duplication becomes an engineering tax.

That is why GitHub Actions reuse matters.

But reuse should be intentional, not clever for its own sake.

## 2. Three Levels Of Workflow Logic

When designing automation, think in three levels:

1. repository entry points
2. job-level reusable workflow patterns
3. step-level reusable actions

These are not the same thing.

## 3. Repository Entry Point

This is the workflow a repository owns locally.

It usually defines:

- the trigger
- repository-specific inputs
- branch rules
- high-level job graph

This is often the best place for repo-specific policy.

## 4. Reusable Workflow

A reusable workflow is the right choice when you want to reuse a whole job-level automation pattern.

Good examples:

- standard Python validation pipeline
- standard Docker publish pipeline
- standard release-with-approval pattern

That is bigger than "run these three shell commands".

It usually represents a full execution shape.

## 5. Composite Action

A composite action is the right choice when you want to package a repeated sequence of steps.

Good examples:

- normalize tag naming
- install a common tool chain
- prepare config files in a standardized way
- run one repeated setup routine

This is smaller and more local than a reusable workflow.

## 6. The Wrong Abstraction Problem

Bad reuse looks like:

- turning every small repetition into a reusable workflow
- hiding repository policy inside a shared abstraction no one understands
- over-abstracting before the pattern is stable

This makes onboarding slower rather than faster.

## 7. A Practical Rule

Use a reusable workflow when the repeated thing has job-level meaning.

Use a composite action when the repeated thing is only a step bundle.

If you cannot explain the ownership boundary in one sentence, the abstraction is probably premature.

## 8. Repository Structure

The most common locations are:

- `.github/workflows/` for workflows
- `.github/actions/` for local custom actions or composite actions

Keep repository structure predictable.

Predictable structure reduces cognitive load for future maintainers.

## 9. Ownership Thinking

This is the architectural question behind reuse:

Who owns this automation logic?

Examples:

- repo-specific trigger policy belongs in the repository
- shared validation flow may belong in a reusable workflow
- small repeated setup logic may belong in a composite action

Good reuse keeps ownership visible.

Bad reuse hides ownership.

## 10. Example Decision

Imagine three repositories all need:

- checkout
- setup Python
- install dependencies
- run lint
- run tests

That repeated full pattern is a strong reusable-workflow candidate.

Now imagine several jobs also need:

- prepare a version string
- normalize branch name
- write metadata file

That repeated small sequence is a strong composite-action candidate.

## 11. Good Strategy

- keep repo entry points thin and readable
- centralize stable, repeated patterns
- choose the smallest abstraction that solves the real duplication
- avoid magical reuse that hides behavior from maintainers

## 12. Key Takeaway

Good GitHub Actions reuse is less about clever abstraction and more about keeping workflow ownership visible at the right level.