#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../../lib/common.sh"
source "$SCRIPT_DIR/../../../lib/fs.sh"
source "$SCRIPT_DIR/../../../lib/section.sh"

SCRIPT_NAME="06-spark-pyspark-init"

REPO_ROOT="$(get_repo_root "$SCRIPT_DIR")"
MODULE="$(get_module_root "$REPO_ROOT" "06-spark-pyspark")"

log "Creating 06-spark-pyspark structure..."

ensure_dir "$MODULE"

ensure_dir "$MODULE/learning-materials"
ensure_dir "$MODULE/learning-materials/01_spark_foundations"
ensure_dir "$MODULE/learning-materials/02_pyspark_dataframes_and_transformations"
ensure_dir "$MODULE/learning-materials/03_distributed_execution_and_performance"
ensure_dir "$MODULE/learning-materials/04_spark_sql_and_data_modeling"
ensure_dir "$MODULE/learning-materials/05_batch_and_stream_processing_patterns"
ensure_dir "$MODULE/learning-materials/06_spark_in_data_platform_architecture"
ensure_dir "$MODULE/learning-materials/07_spark_cookbook"

ensure_dir "$MODULE/simple-tasks"
ensure_dir "$MODULE/simple-tasks/01_spark_foundations"
ensure_dir "$MODULE/simple-tasks/02_pyspark_dataframes_and_transformations"
ensure_dir "$MODULE/simple-tasks/03_distributed_execution_and_performance"
ensure_dir "$MODULE/simple-tasks/04_spark_sql_and_data_modeling"
ensure_dir "$MODULE/simple-tasks/05_batch_and_stream_processing_patterns"
ensure_dir "$MODULE/simple-tasks/06_spark_in_data_platform_architecture"
ensure_dir "$MODULE/simple-tasks/07_spark_cookbook"

ensure_dir "$MODULE/pet-projects"

ensure_dir "$MODULE/pet-projects/01_batch_orders_etl_lakehouse_lab"
ensure_dir "$MODULE/pet-projects/01_batch_orders_etl_lakehouse_lab/config"
ensure_dir "$MODULE/pet-projects/01_batch_orders_etl_lakehouse_lab/data"
ensure_dir "$MODULE/pet-projects/01_batch_orders_etl_lakehouse_lab/docker"
ensure_dir "$MODULE/pet-projects/01_batch_orders_etl_lakehouse_lab/src"
ensure_dir "$MODULE/pet-projects/01_batch_orders_etl_lakehouse_lab/tests"

ensure_dir "$MODULE/pet-projects/02_clickstream_sessionization_and_skew_lab"
ensure_dir "$MODULE/pet-projects/02_clickstream_sessionization_and_skew_lab/config"
ensure_dir "$MODULE/pet-projects/02_clickstream_sessionization_and_skew_lab/data"
ensure_dir "$MODULE/pet-projects/02_clickstream_sessionization_and_skew_lab/docker"
ensure_dir "$MODULE/pet-projects/02_clickstream_sessionization_and_skew_lab/src"
ensure_dir "$MODULE/pet-projects/02_clickstream_sessionization_and_skew_lab/tests"

ensure_dir "$MODULE/pet-projects/03_customer_360_curated_mart_lab"
ensure_dir "$MODULE/pet-projects/03_customer_360_curated_mart_lab/config"
ensure_dir "$MODULE/pet-projects/03_customer_360_curated_mart_lab/data"
ensure_dir "$MODULE/pet-projects/03_customer_360_curated_mart_lab/docker"
ensure_dir "$MODULE/pet-projects/03_customer_360_curated_mart_lab/src"
ensure_dir "$MODULE/pet-projects/03_customer_360_curated_mart_lab/tests"

ensure_dir "$MODULE/pet-projects/04_kafka_to_spark_lakehouse_pipeline_lab"
ensure_dir "$MODULE/pet-projects/04_kafka_to_spark_lakehouse_pipeline_lab/config"
ensure_dir "$MODULE/pet-projects/04_kafka_to_spark_lakehouse_pipeline_lab/data"
ensure_dir "$MODULE/pet-projects/04_kafka_to_spark_lakehouse_pipeline_lab/docker"
ensure_dir "$MODULE/pet-projects/04_kafka_to_spark_lakehouse_pipeline_lab/src"
ensure_dir "$MODULE/pet-projects/04_kafka_to_spark_lakehouse_pipeline_lab/tests"

ensure_dir "$MODULE/pet-projects/reference_example_batch_orders_etl_lakehouse_lab"
ensure_dir "$MODULE/pet-projects/reference_example_batch_orders_etl_lakehouse_lab/data"
ensure_dir "$MODULE/pet-projects/reference_example_batch_orders_etl_lakehouse_lab/src"
ensure_dir "$MODULE/pet-projects/reference_example_batch_orders_etl_lakehouse_lab/tests"

ensure_dir "$MODULE/pet-projects/reference_example_kafka_to_spark_lakehouse_pipeline_lab"
ensure_dir "$MODULE/pet-projects/reference_example_kafka_to_spark_lakehouse_pipeline_lab/data"
ensure_dir "$MODULE/pet-projects/reference_example_kafka_to_spark_lakehouse_pipeline_lab/src"
ensure_dir "$MODULE/pet-projects/reference_example_kafka_to_spark_lakehouse_pipeline_lab/tests"

log "Adding .gitkeep files where useful..."

ensure_gitkeep "$MODULE/learning-materials"

ensure_gitkeep "$MODULE/simple-tasks/01_spark_foundations"
ensure_gitkeep "$MODULE/simple-tasks/02_pyspark_dataframes_and_transformations"
ensure_gitkeep "$MODULE/simple-tasks/03_distributed_execution_and_performance"
ensure_gitkeep "$MODULE/simple-tasks/04_spark_sql_and_data_modeling"
ensure_gitkeep "$MODULE/simple-tasks/05_batch_and_stream_processing_patterns"
ensure_gitkeep "$MODULE/simple-tasks/06_spark_in_data_platform_architecture"
ensure_gitkeep "$MODULE/simple-tasks/07_spark_cookbook"

ensure_gitkeep "$MODULE/pet-projects/01_batch_orders_etl_lakehouse_lab/config"
ensure_gitkeep "$MODULE/pet-projects/01_batch_orders_etl_lakehouse_lab/data"
ensure_gitkeep "$MODULE/pet-projects/01_batch_orders_etl_lakehouse_lab/docker"
ensure_gitkeep "$MODULE/pet-projects/01_batch_orders_etl_lakehouse_lab/src"
ensure_gitkeep "$MODULE/pet-projects/01_batch_orders_etl_lakehouse_lab/tests"

ensure_gitkeep "$MODULE/pet-projects/02_clickstream_sessionization_and_skew_lab/config"
ensure_gitkeep "$MODULE/pet-projects/02_clickstream_sessionization_and_skew_lab/data"
ensure_gitkeep "$MODULE/pet-projects/02_clickstream_sessionization_and_skew_lab/docker"
ensure_gitkeep "$MODULE/pet-projects/02_clickstream_sessionization_and_skew_lab/src"
ensure_gitkeep "$MODULE/pet-projects/02_clickstream_sessionization_and_skew_lab/tests"

ensure_gitkeep "$MODULE/pet-projects/03_customer_360_curated_mart_lab/config"
ensure_gitkeep "$MODULE/pet-projects/03_customer_360_curated_mart_lab/data"
ensure_gitkeep "$MODULE/pet-projects/03_customer_360_curated_mart_lab/docker"
ensure_gitkeep "$MODULE/pet-projects/03_customer_360_curated_mart_lab/src"
ensure_gitkeep "$MODULE/pet-projects/03_customer_360_curated_mart_lab/tests"

ensure_gitkeep "$MODULE/pet-projects/04_kafka_to_spark_lakehouse_pipeline_lab/config"
ensure_gitkeep "$MODULE/pet-projects/04_kafka_to_spark_lakehouse_pipeline_lab/data"
ensure_gitkeep "$MODULE/pet-projects/04_kafka_to_spark_lakehouse_pipeline_lab/docker"
ensure_gitkeep "$MODULE/pet-projects/04_kafka_to_spark_lakehouse_pipeline_lab/src"
ensure_gitkeep "$MODULE/pet-projects/04_kafka_to_spark_lakehouse_pipeline_lab/tests"

ensure_gitkeep "$MODULE/pet-projects/reference_example_batch_orders_etl_lakehouse_lab/data"
ensure_gitkeep "$MODULE/pet-projects/reference_example_batch_orders_etl_lakehouse_lab/src"
ensure_gitkeep "$MODULE/pet-projects/reference_example_batch_orders_etl_lakehouse_lab/tests"

ensure_gitkeep "$MODULE/pet-projects/reference_example_kafka_to_spark_lakehouse_pipeline_lab/data"
ensure_gitkeep "$MODULE/pet-projects/reference_example_kafka_to_spark_lakehouse_pipeline_lab/src"
ensure_gitkeep "$MODULE/pet-projects/reference_example_kafka_to_spark_lakehouse_pipeline_lab/tests"

log "06-spark-pyspark structure initialized."