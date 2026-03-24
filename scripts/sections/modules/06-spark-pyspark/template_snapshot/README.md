# 06-spark-pyspark

This module teaches Spark and PySpark as the distributed processing layer of a modern data platform.

It is not only a syntax guide for `select`, `filter`, and `groupBy`.

It is a structured path from first DataFrame transformations to architect-level reasoning about distributed execution, shuffles, joins, partitioning, storage layout, batch pipelines, structured streaming, and Spark's place between Kafka, storage, lakehouse systems, orchestration, and downstream analytics.

## Why This Module Matters

Once data becomes large enough, frequent enough, or complex enough, single-machine tools stop being sufficient.

Spark matters because it changes how we think about:

- processing scale
- distributed execution
- fault tolerance
- data layout and movement
- performance trade-offs between compute and storage

That matters in real systems such as:

- batch ETL on raw event or file data
- transformation of Kafka-landed datasets into curated tables
- enrichment and joining of large operational datasets
- medallion-style raw-to-curated processing
- large-scale aggregations for analytics and ML feature preparation

Without a solid Spark foundation, later modules such as Databricks, Delta Lake, Airflow, and large end-to-end data-platform projects are harder to reason about correctly.

## What This Module Is Really About

This module covers Spark on three levels at the same time.

Level 1: fundamentals

- what Spark is
- how driver, executors, tasks, partitions, and jobs fit together
- what DataFrames and transformations represent
- why lazy execution matters

Level 2: engineering practice

- PySpark DataFrame transformations
- joins, aggregations, and window functions
- partitioning and file layout thinking
- debugging skew, shuffles, and inefficient pipelines
- local development patterns for repeatable Spark work

Level 3: architecture

- when Spark is the right tool and when it is not
- where Spark sits between Kafka, storage, and serving layers
- how Spark differs from pandas, SQL scripts, and streaming engines
- how to reason about cost, reliability, and maintainability in distributed processing

## What Spark Is

Spark is a distributed data processing engine designed for large-scale transformations and computations.

At a practical level, it gives you:

- a driver that coordinates work
- executors that process partitions of data
- transformations that define logical work
- actions that trigger execution
- distributed APIs through DataFrames, SQL, and other abstractions

Spark is strong when you need:

- large-scale batch transformations
- joins and aggregations over bigger datasets
- distributed processing across many partitions
- reproducible transformation pipelines that can be rebuilt from raw data

## Spark Vs PySpark Vs Spark SQL Vs Scala API Vs Databricks

It is useful to separate these concepts clearly:

- Apache Spark: the distributed processing engine itself
- PySpark: the Python API for working with Spark
- Spark SQL: the SQL interface inside Spark
- Scala Spark API: another API for the same Spark engine, but through Scala
- Databricks: a platform and workspace built around Spark and the lakehouse ecosystem

Short version:

- Spark = engine
- PySpark = the Python control surface for that engine
- Spark SQL = the SQL control surface inside that engine
- Scala API = another control surface, often closer to Spark's native ecosystem
- Databricks = an environment that packages Spark with notebooks, jobs, governance, storage integrations, and operational tooling

This distinction matters because learners often mix up:

- the engine itself
- the language interface they are using
- the managed platform where they happen to run it

If you write Python code like `spark.read.parquet(...).groupBy(...)`, you are using PySpark.

If the job runs on Spark, the execution engine is still Spark.

If the same transformation is written in SQL, the execution engine is still Spark.

If the same work is executed on Databricks, Databricks is the surrounding platform, while Spark remains the processing engine.

## What Spark Is Not

Spark is not:

- a replacement for every Python script
- a transactional serving database
- a workflow orchestrator
- automatically fast just because it is distributed
- the best answer for every streaming problem

Common bad assumptions:

- "If we use Spark, the job is automatically scalable and efficient"
- "Spark should replace pandas even for tiny datasets"
- "More executors always means faster pipelines"
- "Spark SQL and architecture design are separate concerns"

## Spark In A Data Platform

A typical data-platform flow looks like this:

		Sources / raw files / CDC / Kafka
					↓
		Storage landing layer
					↓
		Spark batch or streaming transformations
					↓
		Curated tables / serving-ready datasets
					↓
		Analytics / ML / dashboards / downstream systems

Spark is the distributed compute and transformation layer in that picture.

It should usually own:

- large-scale data transformations
- joins and aggregations across partitions
- enrichment and normalization pipelines
- rebuilding curated outputs from raw or bronze layers

Spark should usually not own:

- long-term business serving semantics
- orchestration across many external systems
- event transport itself
- tiny low-latency scripts that do not need distributed execution

Good boundary examples:

- Kafka transports events
- object storage or tables keep raw and curated data
- Spark transforms raw data into curated analytical layers
- Airflow orchestrates multi-step jobs
- dbt models warehouse-facing transformations after data is landed appropriately

## Main Learning Goals

By the end of this module, the learner should be able to:

- explain Spark as a distributed processing engine rather than "pandas on a cluster"
- describe driver, executors, partitions, stages, shuffles, and lazy execution
- write practical PySpark DataFrame transformations and aggregations
- reason about wide versus narrow transformations
- understand join strategies, partitioning, and skew risks
- explain how storage layout and file sizing affect Spark performance
- distinguish Spark batch, Spark Structured Streaming, and surrounding platform responsibilities
- place Spark correctly inside a data platform architecture
- recognize when Spark is unnecessary or overly expensive
- debug common failure and performance patterns at a systems level

## Module Structure

		06-spark-pyspark/
				README.md
				learning-materials/
				simple-tasks/
				pet-projects/

## Learning Philosophy

This module is intentionally built with a strong architecture bias.

Spark is easy to misuse if the learner remembers only API calls and not the execution model behind them.

So the material here should repeatedly connect:

- what Spark does technically
- how data moves through the execution plan
- where performance problems come from
- how storage and processing choices reinforce or weaken the architecture

The learner should not leave this module thinking only:

- how to call `withColumn`
- how to run `groupBy`

The learner should leave understanding:

- why shuffles dominate cost
- why partitioning and file layout matter
- why Spark is powerful but not free
- why good distributed data design starts long before the final action runs

## Learning Materials

The learning materials are organized into seven topic groups.

1. `01_spark_foundations`
2. `02_pyspark_dataframes_and_transformations`
3. `03_distributed_execution_and_performance`
4. `04_spark_sql_and_data_modeling`
5. `05_batch_and_stream_processing_patterns`
6. `06_spark_in_data_platform_architecture`
7. `07_spark_cookbook`

## Best Entry Points

If the learner wants the cleanest beginner-to-architect route:

1. `learning-materials/01_spark_foundations`
2. `learning-materials/02_pyspark_dataframes_and_transformations`
3. `simple-tasks/01_spark_foundations`
4. `simple-tasks/02_pyspark_dataframes_and_transformations`
5. `pet-projects/01_batch_orders_etl_lakehouse_lab`

If the learner wants the most practical code-first route:

1. `learning-materials/02_pyspark_dataframes_and_transformations/03_joins_aggregations_and_window_patterns.md`
2. `learning-materials/02_pyspark_dataframes_and_transformations/05_read_write_patterns_and_output_layout.md`
3. `learning-materials/03_distributed_execution_and_performance/02_shuffle_cost_and_skew.md`
4. `learning-materials/05_batch_and_stream_processing_patterns/02_structured_streaming_foundations.md`
5. `learning-materials/07_spark_cookbook/01_join_strategy_decision_recipe.md`

If the learner wants the architecture-first route:

1. `learning-materials/04_spark_sql_and_data_modeling`
2. `learning-materials/05_batch_and_stream_processing_patterns`
3. `learning-materials/06_spark_in_data_platform_architecture`
4. `pet-projects/04_kafka_to_spark_lakehouse_pipeline_lab`

## How The Module Parts Work Together

- `learning-materials/` explains the concepts, trade-offs, and code patterns
- `simple-tasks/` forces small focused implementation and reasoning steps
- `pet-projects/` turns those ideas into production-shaped labs

The strongest learning sequence is usually:

1. read one block in `learning-materials/`
2. complete the matching block in `simple-tasks/`
3. use one `pet-projects/` lab to combine several blocks in one workflow

## Expected Outcome

By the end of this module, the learner should be able to reason about Spark not only as code, but as the distributed compute layer that turns raw data movement into reliable, scalable, architecture-aware processing.

They should also be able to answer three higher-level questions clearly:

- when Spark is the right compute layer
- how to shape Spark jobs so data movement and storage layout stay healthy
- how Spark fits into a larger platform with Kafka, lakehouse storage, orchestration, and downstream serving layers
