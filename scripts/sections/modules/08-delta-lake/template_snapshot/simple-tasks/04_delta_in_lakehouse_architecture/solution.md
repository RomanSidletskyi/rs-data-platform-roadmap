# Solutions: Delta In Lakehouse Architecture

## Task 1

Bronze uses Delta for source-near reliability and replay. Silver uses Delta for reusable cleaned records. Gold uses Delta for governed consumer-facing outputs. The format is the same, but the semantic contract is different at each layer.

## Task 2

Spark is the compute engine, Delta Lake is the table semantics layer, Databricks may provide managed jobs/governance/workspace surfaces, and storage persists files physically. Blurring these layers makes architecture reasoning weaker.

## Task 3

Delta helps unify the table layer between batch and streaming because the same Delta table can be read by both. It does not remove the need for replay, checkpoint, state, or recovery design.

## Task 4

A platform can use Delta correctly and still be weak if ownership is unclear, orchestration is fragile, and consumers do not know table grain or guarantees. Delta improves table reliability, not the whole platform automatically.
