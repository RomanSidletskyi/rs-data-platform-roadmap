# Architecture Practice

This directory turns architecture examples into active practice.

The goal is not only to read good case studies.

The goal is to train your ability to compare options, defend trade-offs, capture decisions, and surface open risks in your own words.

Use this layer when you want to move from "I understand the example" to "I can defend the decision myself."

## How This Layer Fits

Use the layers in this order:

1. `../workflows/ai-for-project-design.md`
2. `../workflows/ai-for-research.md`
3. `../architecture-examples/README.md`
4. one exercise from this directory
5. `../personal-operating-model/decision-journal.md`
6. `../workflows/design-review-prep.md`

## Recommended Order

Do not start with the hardest topics first.

Build from cleaner boundary decisions toward higher coordination and operational complexity.

### Foundation Round

Use these first to build the habit of naming trust boundaries and rejected options:

1. `01_bronze_validation_curated.md`
2. `02_delta_recovery.md`
3. `03_replay_idempotency.md`
4. `04_schema_contracts.md`

### System Boundary Round

Use these after the first round feels natural:

1. `05_orchestration_boundaries.md`
2. `06_serving_contracts.md`
3. `07_dbt_contracts.md`
4. `08_airflow_logic_boundaries.md`

### Higher Coordination Round

Use these when you want more architectural ambiguity and more coordination trade-offs:

1. `09_kafka_event_contracts.md`
2. `10_spark_stateful_processing.md`

## How To Run One Exercise

Use one exercise as a short architecture decision drill, not as passive reading.

Recommended loop:

1. Read the paired architecture example.
2. Answer the worksheet yourself before looking at the filled example.
3. Force yourself to write why the losing option loses.
4. Compare your answer with the filled example.
5. Extract one decision entry and one mistake entry into your personal system.
6. If your answer still feels vague, use `../workflows/design-review-prep.md` to stress-test it.

## Personal Operating Model Capture

Do not leave the exercise result inside the worksheet only.

Move the output into your personal operating model in two directions.

### 1. Decision Journal

Use `../personal-operating-model/decision-journal.md` after every completed drill.

Capture at least:

- the chosen option
- the real alternatives you rejected
- the trade-off you accepted deliberately
- the follow-up trigger that would make you revisit the decision

Good signal:

You can explain not only what you chose, but what new fact would change your choice.

### 2. Mistakes Log

Use `../personal-operating-model/mistakes-log.md` whenever your first instinct was weak or incomplete.

Capture at least:

- the architectural mistake in your first pass
- the missed signal
- the prevention rule for next time

Good signal:

Your mistake turns into a reusable rule such as "stabilize the serving layer more than internal models" or "do not confuse schema compatibility with semantic compatibility."

## What Good Practice Looks Like

A strong answer usually has these properties:

- the trust boundary is explicit
- the ownership point is explicit
- the replay or recovery implication is explicit
- the rejected option is rejected for a reason, not by preference
- the open risks are real and not generic filler

## How To Repeat The Layer

Do not do each drill only once.

Repeat a drill later under one of these conditions:

- your answer depended too much on the filled example
- you chose an option but could not defend the rejected one
- you noticed you were optimizing for elegance instead of operations
- a real project in the roadmap exposed the same trade-off

## Included Exercises

Start with `template.md` if you want to invent your own architecture scenario after finishing the guided set.

- `template.md`
- `01_bronze_validation_curated.md`
- `02_delta_recovery.md`
- `03_replay_idempotency.md`
- `04_schema_contracts.md`
- `05_orchestration_boundaries.md`
- `06_serving_contracts.md`
- `07_dbt_contracts.md`
- `08_airflow_logic_boundaries.md`
- `09_kafka_event_contracts.md`
- `10_spark_stateful_processing.md`

## Standard Output

Each exercise should end with:

- a chosen option
- a rejected-option summary
- explicit trade-offs
- open risks
- one decision-journal entry
- one mistake to log

If those two personal-system outputs are missing, the exercise is not fully finished.

## Rule

If the exercise ends with a preferred option but no rejected-option reasoning, the architecture thinking is still too shallow.