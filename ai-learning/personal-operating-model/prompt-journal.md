# Prompt Journal

Use a prompt journal to keep only prompts that repeatedly produce useful work.

## What Belongs Here

- prompts that work across several similar tasks
- prompts that expose trade-offs, constraints, or failure modes clearly
- prompts that improve validation quality

## What Does Not Belong Here

- one-off prompts tied to a single temporary problem
- prompts that only sound sophisticated
- prompts with no evidence that they improved the result

## Entry Template

- task type:
- working prompt:
- why it works:
- when not to use it:
- validation step that should follow:

## Example

- task type: architecture comparison
- working prompt: compare these three design options by recovery model, contract stability, operating complexity, and failure isolation; list one context where each option becomes the best choice
- why it works: it prevents single-answer thinking and forces trade-off structure
- when not to use it: when the scenario is still too vague to compare responsibly
- validation step that should follow: convert the chosen option into an explicit design note

## Rule

If a prompt works only once, it is not journal material yet.