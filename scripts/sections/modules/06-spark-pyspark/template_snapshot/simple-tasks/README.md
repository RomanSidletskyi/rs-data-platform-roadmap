# Spark Simple Tasks

This folder will contain focused practice tasks aligned to the seven learning-material blocks.

The purpose of these tasks is to make the learner implement small, clear Spark exercises before moving into larger production-shaped projects.

The task structure should mirror the theory structure:

1. Spark foundations
2. PySpark DataFrames and transformations
3. Distributed execution and performance
4. Spark SQL and data modeling
5. Batch and stream processing patterns
6. Spark in data-platform architecture
7. Spark cookbook

Each task block should eventually contain:

- a `README.md` with the exercises
- a `solution.md` with practical solutions and design reasoning

Current task blocks:

1. `01_spark_foundations`
2. `02_pyspark_dataframes_and_transformations`
3. `03_distributed_execution_and_performance`
4. `04_spark_sql_and_data_modeling`
5. `05_batch_and_stream_processing_patterns`
6. `06_spark_in_data_platform_architecture`
7. `07_spark_cookbook`

## Recommended Order

Use tasks immediately after the matching learning block.

Suggested sequence:

1. `learning-materials/01_spark_foundations` -> `simple-tasks/01_spark_foundations`
2. `learning-materials/02_pyspark_dataframes_and_transformations` -> `simple-tasks/02_pyspark_dataframes_and_transformations`
3. `learning-materials/03_distributed_execution_and_performance` -> `simple-tasks/03_distributed_execution_and_performance`
4. `learning-materials/04_spark_sql_and_data_modeling` -> `simple-tasks/04_spark_sql_and_data_modeling`
5. `learning-materials/05_batch_and_stream_processing_patterns` -> `simple-tasks/05_batch_and_stream_processing_patterns`
6. `learning-materials/06_spark_in_data_platform_architecture` -> `simple-tasks/06_spark_in_data_platform_architecture`
7. `learning-materials/07_spark_cookbook` -> `simple-tasks/07_spark_cookbook`

## How To Use A Task Well

- solve it before reading `solution.md`
- explain why the chosen Spark shape is healthy, not only why the syntax works
- check whether the task is about API mechanics, execution behavior, or architecture trade-offs

The goal is not just to make the learner write short snippets.

The goal is to force the learner to explain Spark behavior, choose healthier design options, and connect implementation details to data-platform architecture.