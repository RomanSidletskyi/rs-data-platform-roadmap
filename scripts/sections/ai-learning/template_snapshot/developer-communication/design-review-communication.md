# Design Review Communication

Design review communication is about clarity, not performance.

## Good Review Communication Sounds Like

- "The main trade-off here is operational simplicity versus flexibility."
- "This option reduces recovery complexity but increases storage cost."
- "The risky assumption is that upstream schema changes remain additive."
- "I would like review feedback on the publish contract and replay strategy."

## Weak Review Communication Sounds Like

- "This should be fine."
- "It is better this way."
- "I think this architecture is cleaner."

Those statements are too vague.

## Better Pattern

State:

- the decision
- the reason
- the trade-off
- the open question

## How AI Helps

Use AI to rehearse explanations, tighten phrasing, and surface missing assumptions.

Prompt example:

```text
Act as a senior engineer in a design review. Ask me follow-up questions about this ingestion architecture and challenge weak assumptions around replay, schema evolution, and publish boundaries.
```