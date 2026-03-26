# Architecture Examples

This directory contains architecture-heavy case studies for learning how to reason beyond tools and prompts.

The goal is not to memorize one correct design.

The goal is to see how trade-offs, failure modes, contracts, recovery rules, and ownership boundaries shape real design choices.

Use this layer as the reading side of the architecture loop.

Read here first, then move into `../architecture-practice/` to defend a decision yourself.

## What This Directory Covers

- pipeline boundaries
- replay and idempotency
- schema evolution and contract control
- storage-layer trade-offs
- orchestration boundaries
- serving and downstream contract design

## How This Layer Fits

Use the architecture layers as one connected flow:

1. `../workflows/ai-for-project-design.md`
2. `../workflows/ai-for-research.md`
3. one case from this directory
4. the matching drill in `../architecture-practice/`
5. `../personal-operating-model/decision-journal.md`
6. `../workflows/design-review-prep.md`

This directory helps you inspect a tension.

The practice directory forces you to take a position on that tension.

## Recommended Reading Order

Do not read the cases randomly if your goal is architectural growth.

Build from clearer boundary problems toward coordination-heavy and operations-heavy problems.

### Foundation Cases

Start here if you are building the habit of seeing trust boundaries and replay implications:

1. `bronze-validation-curated-boundaries.md`
2. `delta-vs-parquet-recovery.md`
3. `replay-and-idempotency.md`
4. `schema-evolution-contracts.md`

### System Boundary Cases

Use these after the foundation cases feel natural:

1. `orchestration-boundaries.md`
2. `serving-layer-contracts.md`
3. `dbt-model-contracts.md`
4. `airflow-dag-vs-pipeline-logic.md`

### Higher Coordination Cases

Use these when you want stronger ambiguity around ownership, semantics, and operational burden:

1. `kafka-event-contract-boundaries.md`
2. `spark-stateful-processing-tradeoffs.md`

## Included Examples

- `bronze-validation-curated-boundaries.md`
- `delta-vs-parquet-recovery.md`
- `replay-and-idempotency.md`
- `schema-evolution-contracts.md`
- `orchestration-boundaries.md`
- `serving-layer-contracts.md`
- `dbt-model-contracts.md`
- `airflow-dag-vs-pipeline-logic.md`
- `kafka-event-contract-boundaries.md`
- `spark-stateful-processing-tradeoffs.md`

## How To Use These Cases

Do not treat the case as documentation to consume passively.

For each example:

1. read the scenario
2. identify the real architectural tension
3. inspect the trade-offs and failure modes
4. answer the review questions before looking for closure
5. use the AI prompt pack only to challenge your reasoning, not replace it
6. compare the example with your own preferred design
7. move into the matching drill in `../architecture-practice/`
8. write one short decision note in your own words

## Example-To-Practice Mapping

Use these pairs together instead of reading the examples in isolation:

- `bronze-validation-curated-boundaries.md` -> `../architecture-practice/01_bronze_validation_curated.md`
- `delta-vs-parquet-recovery.md` -> `../architecture-practice/02_delta_recovery.md`
- `replay-and-idempotency.md` -> `../architecture-practice/03_replay_idempotency.md`
- `schema-evolution-contracts.md` -> `../architecture-practice/04_schema_contracts.md`
- `orchestration-boundaries.md` -> `../architecture-practice/05_orchestration_boundaries.md`
- `serving-layer-contracts.md` -> `../architecture-practice/06_serving_contracts.md`
- `dbt-model-contracts.md` -> `../architecture-practice/07_dbt_contracts.md`
- `airflow-dag-vs-pipeline-logic.md` -> `../architecture-practice/08_airflow_logic_boundaries.md`
- `kafka-event-contract-boundaries.md` -> `../architecture-practice/09_kafka_event_contracts.md`
- `spark-stateful-processing-tradeoffs.md` -> `../architecture-practice/10_spark_stateful_processing.md`

## What To Extract After Reading

Before leaving a case, capture at least these points in your own words:

- what the real boundary decision is
- what makes the losing option attractive at first
- what failure mode changes the decision most
- what open risk remains even after choosing the better option

If you cannot name those four things, move to the paired practice drill before reading more cases.

## Personal Operating Model Handoff

Do not stop at recognition.

After reading and then completing the paired drill, record the outcome in your personal system:

- use `../personal-operating-model/decision-journal.md` for the chosen option, rejected options, accepted trade-off, and follow-up trigger
- use `../personal-operating-model/mistakes-log.md` if your first instinct ignored the real contract, replay, or ownership issue

## Read With

- `../workflows/ai-for-project-design.md`
- `../workflows/ai-for-research.md`
- `../how-to-think-like-a-data-platform-architect-with-ai.md`
- `../architecture-practice/README.md`
- `../practical-exercises/03_ai_pipeline_design/README.md`
- `../personal-operating-model/decision-journal.md`

## What Good Reading Looks Like

You are using this layer well when:

- you can state the core tension before the case explains it
- you can explain why a tempting alternative still loses
- you can name the ownership boundary, not just the technology choice
- you can describe the replay or recovery consequence of the decision

## Rule

If you can describe the chosen design but not the rejected alternatives and failure boundaries, the architecture thinking is still shallow.