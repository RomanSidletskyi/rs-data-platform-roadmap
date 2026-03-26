# Note Capture

Use this guide to keep AI-assisted work from dissolving into chat history.

## What To Capture

Capture only information that improves future work:

- decisions
- unresolved questions
- failure modes
- reusable prompts with clear context
- architecture trade-offs that are easy to forget

## What Not To Capture

- long AI answers copied without synthesis
- generic summaries with no action value
- notes that repeat the original source without adding a conclusion

## Good Note Format

- context: what task or decision this came from
- insight: what changed in your understanding
- implication: what this means for implementation or learning
- next step: what should happen because of this note

## Example

Context:

- comparing raw Parquet tables against Delta Lake for replay-heavy pipelines

Insight:

- replay cost is not only about compute; it also changes recovery confidence and downstream contract stability

Implication:

- storage-layer choice affects incident response and analytics trust, not just performance

Next step:

- document replay and recovery assumptions in architecture notes

## Rule

If a note does not change a future action, shorten it or delete it.