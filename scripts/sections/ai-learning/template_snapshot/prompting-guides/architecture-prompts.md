# Architecture Prompts

Use these prompts when the goal is to reason about system shape, boundaries, and trade-offs rather than generate code immediately.

## Good Prompt Pattern

Include:

- the business or platform scenario
- the expected scale or load shape
- the technologies already chosen or still undecided
- the main constraints
- what kind of answer you want back

## Example Prompts

### Platform Boundary Prompt

"Given this data platform scenario, propose the main boundaries between ingestion, storage, processing, transformation, and serving. Call out ownership lines, interface contracts, and failure isolation points."

### Technology Choice Prompt

"Compare these two designs for this workload. Focus on operational complexity, scalability limits, data contracts, failure recovery, and team cognitive load."

### Review Prompt

"Review this architecture note like a senior engineer. Identify weak assumptions, missing components, unclear interfaces, and risky shortcuts."

## Rule

Ask for trade-offs and failure modes explicitly.

If you do not, most AI answers will stay too optimistic.
