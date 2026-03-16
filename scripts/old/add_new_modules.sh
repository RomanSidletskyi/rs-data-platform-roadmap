#!/bin/bash

set -e

ROOT="."

########################################
# 11 Airflow
########################################

mkdir -p "$ROOT/11-airflow/learning-materials"/{airflow-basics,dag-design,scheduling-and-retries,operators-and-hooks,airflow-with-spark,production-patterns}
mkdir -p "$ROOT/11-airflow/simple-tasks"/{01_first_dag,02_task_dependencies,03_scheduling_and_retries,04_python_operator_pipeline,05_airflow_with_external_jobs,06_basic_monitoring}
mkdir -p "$ROOT/11-airflow/pet-projects"/{01_batch_pipeline_orchestration,02_api_to_lakehouse_orchestration,03_multi_step_data_workflow,04_production_style_airflow_project}
touch "$ROOT/11-airflow/README.md"

########################################
# 12 dbt
########################################

mkdir -p "$ROOT/12-dbt/learning-materials"/{dbt-basics,models-and-materializations,tests-and-quality,macros-and-jinja,documentation-and-lineage,dbt-with-lakehouse}
mkdir -p "$ROOT/12-dbt/simple-tasks"/{01_first_model,02_staging_models,03_incremental_model,04_tests_and_sources,05_marts_layer,06_docs_and_lineage}
mkdir -p "$ROOT/12-dbt/pet-projects"/{01_analytics_engineering_project,02_sales_marts_with_dbt,03_dbt_on_lakehouse_data,04_end_to_end_dbt_project}
touch "$ROOT/12-dbt/README.md"

########################################
# 13 Flink
########################################

mkdir -p "$ROOT/13-flink/learning-materials"/{flink-basics,streams-and-transformations,event-time-and-watermarks,stateful-processing,windowing,flink-with-kafka,production-patterns}
mkdir -p "$ROOT/13-flink/simple-tasks"/{01_first_stream_job,02_kafka_to_flink,03_windows_and_aggregations,04_event_time_intro,05_stateful_processing,06_checkpointing_basics}
mkdir -p "$ROOT/13-flink/pet-projects"/{01_realtime_metrics_pipeline,02_clickstream_sessionization,03_fraud_detection_simulator,04_flink_end_to_end_project}
touch "$ROOT/13-flink/README.md"

########################################
# 14 Iceberg
########################################

mkdir -p "$ROOT/14-iceberg/learning-materials"/{iceberg-basics,table-format-concepts,partitioning-and-evolution,iceberg-with-spark,iceberg-with-flink,lakehouse-tradeoffs}
mkdir -p "$ROOT/14-iceberg/simple-tasks"/{01_first_iceberg_table,02_partition_evolution,03_schema_evolution,04_time_travel_intro,05_spark_with_iceberg,06_streaming_to_iceberg_concepts}
mkdir -p "$ROOT/14-iceberg/pet-projects"/{01_iceberg_lakehouse_lab,02_spark_iceberg_pipeline,03_flink_iceberg_streaming_case,04_open_lakehouse_project}
touch "$ROOT/14-iceberg/README.md"

echo "New modules created successfully:"
echo "- 11-airflow"
echo "- 12-dbt"
echo "- 13-flink"
echo "- 14-iceberg"