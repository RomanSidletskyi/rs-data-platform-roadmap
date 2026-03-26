# Spark Learning Materials

This folder is the main theory and architecture path for the Spark module.

It is designed to take the learner from first-principles understanding of distributed execution to practical Spark design inside end-to-end data platforms.

## Reading Path

Start here:

1. `01_spark_foundations`
2. `02_pyspark_dataframes_and_transformations`
3. `03_distributed_execution_and_performance`
4. `04_spark_sql_and_data_modeling`
5. `05_batch_and_stream_processing_patterns`
6. `06_spark_in_data_platform_architecture`
7. `07_spark_cookbook`

## Suggested Study Tracks

Beginner track:

1. `01_spark_foundations`
2. `02_pyspark_dataframes_and_transformations`
3. `03_distributed_execution_and_performance`

Practical engineer track:

1. `02_pyspark_dataframes_and_transformations`
2. `03_distributed_execution_and_performance`
3. `07_spark_cookbook`

Architect track:

1. `04_spark_sql_and_data_modeling`
2. `05_batch_and_stream_processing_patterns`
3. `06_spark_in_data_platform_architecture`
4. `07_spark_cookbook`

## Practical Path

If you want the most code-heavy route first, prioritize these chapters:

1. `02_pyspark_dataframes_and_transformations/02_reading_filtering_and_column_transformations.md`
2. `02_pyspark_dataframes_and_transformations/03_joins_aggregations_and_window_patterns.md`
3. `02_pyspark_dataframes_and_transformations/05_read_write_patterns_and_output_layout.md`
4. `03_distributed_execution_and_performance/02_shuffle_cost_and_skew.md`
5. `04_spark_sql_and_data_modeling/03_incremental_models_and_rebuild_boundaries.md`
6. `05_batch_and_stream_processing_patterns/02_structured_streaming_foundations.md`
7. `05_batch_and_stream_processing_patterns/03_watermarks_state_and_late_data.md`
8. `07_spark_cookbook/01_join_strategy_decision_recipe.md`
9. `07_spark_cookbook/03_slow_job_triage_recipe.md`

These chapters now contain the densest mix of:

- real PySpark or SQL code
- explanation of why the code is shaped that way
- architecture reasoning about trade-offs and failure modes

## What Each Block Is For

### 01_spark_foundations

Build the mental model.

Focus:

- what Spark is and is not
- driver and executors
- jobs, stages, tasks, and partitions
- lazy evaluation and why it matters

Best starting chapters:

- `01_what_spark_is_and_is_not.md`
- `04_partitions_parallelism_and_data_movement.md`

### 02_pyspark_dataframes_and_transformations

Connect API usage to data-processing patterns.

Focus:

- DataFrame transformations
- filtering, projection, joins, aggregations, windows
- schema handling
- practical PySpark coding patterns

Best practical chapters:

- `02_reading_filtering_and_column_transformations.md`
- `03_joins_aggregations_and_window_patterns.md`
- `05_read_write_patterns_and_output_layout.md`

### 03_distributed_execution_and_performance

This is where Spark stops feeling like normal Python and starts feeling like distributed systems engineering.

Focus:

- narrow vs wide transformations
- shuffles and why they hurt
- skew and partition imbalance
- caching, persistence, and execution planning
- common performance anti-patterns

Best practical chapters:

- `02_shuffle_cost_and_skew.md`
- `05_debugging_slow_jobs_and_failure_patterns.md`

### 04_spark_sql_and_data_modeling

Connect Spark compute with table-oriented thinking.

Focus:

- Spark SQL mental model
- transformations into curated layers
- table and file layout implications
- modeling choices for downstream consumption

Best practical chapters:

- `01_spark_sql_as_a_modeling_layer.md`
- `03_incremental_models_and_rebuild_boundaries.md`

### 05_batch_and_stream_processing_patterns

Place Spark inside actual pipeline patterns.

Focus:

- batch ETL
- incremental processing
- structured streaming boundaries
- replay and rebuild thinking
- when Spark batch and Spark streaming differ architecturally

Best practical chapters:

- `02_structured_streaming_foundations.md`
- `03_watermarks_state_and_late_data.md`
- `06_end_to_end_kafka_to_spark_to_lakehouse.md`

### 06_spark_in_data_platform_architecture

This is the architect block.

Focus:

- Spark versus pandas
- Spark versus SQL-only pipelines
- Spark versus Flink for streaming contexts
- Spark between Kafka, storage, orchestration, and serving layers
- when not to use Spark

Best architecture chapters:

- `02_spark_between_kafka_lakehouse_and_warehouse.md`
- `03_operating_model_ownership_and_reliability.md`
- `04_when_spark_becomes_platform_debt.md`

### 07_spark_cookbook

This block should become a decision-oriented recipe collection.

Focus:

- join strategy heuristics
- partitioning decisions
- file sizing and layout rules
- debugging slow jobs
- replay and backfill operating patterns

Most practical recipes:

- `01_join_strategy_decision_recipe.md`
- `03_slow_job_triage_recipe.md`
- `05_replay_and_backfill_recipe.md`

## Learning Standard

This module should follow the same standard as the strongest modules in the repository:

- theory first
- examples-heavy explanation
- architecture-first reasoning
- from zero to architect

The goal is not to memorize Spark calls.

The goal is to understand what those calls cause inside a distributed system and why that matters for a real data platform.

After the latest content pass, all learning chapters under `01-07` include code fences. The only non-code file in this folder is this index page.

To use this folder well:

1. pick one study track instead of reading randomly
2. move into the matching `simple-tasks/` block after each major section
3. use `pet-projects/` only after the matching practical chapters feel clear enough to re-explain in your own words