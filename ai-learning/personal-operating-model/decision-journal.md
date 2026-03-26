# Decision Journal

Use a decision journal to keep architecture and workflow choices explicit.

## Scenario

You compared several options and picked one, but later it becomes hard to remember:

- why that option was chosen
- what assumptions were accepted
- what risks were left open

## Decision Entry Template

- decision: what was chosen
- context: what problem triggered the choice
- options considered: what real alternatives existed
- trade-offs accepted: what cost or risk you accepted deliberately
- evidence used: docs, experiments, code, incidents, or examples
- follow-up trigger: what would make you revisit the choice

## Example

- decision: add an explicit validation stage before curated publish
- context: raw-to-curated flow made schema failures hard to isolate
- options considered: direct publish, validation stage, full contract-gate workflow
- trade-offs accepted: one extra stage for clearer recovery and contract trust
- evidence used: pipeline failure analysis and schema-change scenarios
- follow-up trigger: revisit if the team needs multi-engine contract enforcement

## Why This Works

Architecture thinking improves when decisions are connected to trade-offs, not just chosen outcomes.

## Rule

Never write only the chosen option.

Write why the rejected options lost.