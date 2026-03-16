#!/bin/bash

set -e

echo "Initializing Data Platform Roadmap structure..."

ROOT="."

# ------------------------------------------------
# Root files
# ------------------------------------------------

touch $ROOT/README.md

# ------------------------------------------------
# Docs
# ------------------------------------------------

mkdir -p $ROOT/docs
touch $ROOT/docs/{roadmap.md,how-to-study.md,portfolio-guidelines.md,architecture-principles.md}

# ------------------------------------------------
# Templates
# ------------------------------------------------

mkdir -p $ROOT/templates
touch $ROOT/templates/{learning-module-readme-template.md,task-readme-template.md,pet-project-readme-template.md,real-project-readme-template.md}

# ------------------------------------------------
# Shared
# ------------------------------------------------

mkdir -p $ROOT/shared/{datasets,diagrams,utils,glossary}

# ------------------------------------------------
# AI Learning
# ------------------------------------------------

mkdir -p $ROOT/ai-learning/prompting-guides
mkdir -p $ROOT/ai-learning/workflows
mkdir -p $ROOT/ai-learning/tools
mkdir -p $ROOT/ai-learning/practical-exercises/{01_ai_python_refactor,02_ai_sql_generation,03_ai_pipeline_design,04_ai_code_review}

touch $ROOT/ai-learning/README.md

touch $ROOT/ai-learning/prompting-guides/{learning-prompts.md,debugging-prompts.md,architecture-prompts.md,code-review-prompts.md}

touch $ROOT/ai-learning/workflows/{how-to-learn-faster.md,ai-pair-programming.md,ai-for-debugging.md,ai-for-project-design.md}

touch $ROOT/ai-learning/tools/{chatgpt.md,github-copilot.md,cursor-ide.md,codeium.md,ai-data-tools.md}

# ------------------------------------------------
# 01 Python
# ------------------------------------------------

mkdir -p $ROOT/01-python/learning-materials/{fundamentals,files-and-json,api-work,testing-and-logging,packaging-and-env,data-engineering-focus}

mkdir -p $ROOT/01-python/simple-tasks/{01_variables_conditions_loops,02_functions_modules,03_work_with_files_csv_json,04_requests_and_api,05_error_handling_logging,06_virtualenv_and_project_setup,07_pandas_basics,08_data_engineering_python_tasks}

mkdir -p $ROOT/01-python/pet-projects/{01_api_to_csv_pipeline,02_json_normalizer,03_log_parser_pipeline,04_data_quality_checker,05_incremental_ingestion_simulator}

touch $ROOT/01-python/README.md

# ------------------------------------------------
# 02 SQL
# ------------------------------------------------

mkdir -p $ROOT/02-sql/{learning-materials,simple-tasks,pet-projects}

touch $ROOT/02-sql/README.md

# ------------------------------------------------
# 03 Docker
# ------------------------------------------------

mkdir -p $ROOT/03-docker/{learning-materials,simple-tasks,pet-projects}
touch $ROOT/03-docker/README.md

# ------------------------------------------------
# 04 GitHub Actions
# ------------------------------------------------

mkdir -p $ROOT/04-github-actions/{learning-materials,simple-tasks,pet-projects}
touch $ROOT/04-github-actions/README.md

# ------------------------------------------------
# 05 Kafka / Confluent
# ------------------------------------------------

mkdir -p $ROOT/05-confluent-kafka/learning-materials/{kafka-fundamentals,producers-consumers,topics-partitions-offsets,schema-registry,kafka-connect,stream-processing,event-driven-design}

mkdir -p $ROOT/05-confluent-kafka/simple-tasks/{01_run_local_kafka,02_first_producer_consumer,03_json_events,04_retry_dead_letter_queue,05_multi_consumer_groups,06_streaming_simulation}

mkdir -p $ROOT/05-confluent-kafka/pet-projects/{01_iot_streaming_lab,02_clickstream_pipeline,03_orders_payments_shipments_events,04_kafka_to_postgres_pipeline}

touch $ROOT/05-confluent-kafka/README.md

# ------------------------------------------------
# 06 Spark / PySpark
# ------------------------------------------------

mkdir -p $ROOT/06-spark-pyspark/learning-materials/{spark-core,dataframe-api,transformations-actions,joins-window-functions,performance-basics,parquet-partitions,pyspark-etl}

mkdir -p $ROOT/06-spark-pyspark/simple-tasks/{01_read_write_files,02_transformations,03_joins_and_windows,04_partitioning,05_basic_aggregations,06_etl_mini_jobs}

mkdir -p $ROOT/06-spark-pyspark/pet-projects/{01_batch_etl_pipeline,02_log_analytics_pyspark,03_large_csv_to_parquet_optimizer,04_data_quality_framework_spark}

touch $ROOT/06-spark-pyspark/README.md

# ------------------------------------------------
# 07 Databricks
# ------------------------------------------------

mkdir -p $ROOT/07-databricks/learning-materials/{workspace-basics,notebooks-jobs,delta-lake,medallion-architecture,unity-catalog,workflows,production-patterns}

mkdir -p $ROOT/07-databricks/simple-tasks/{01_first_notebook,02_bronze_silver_gold,03_delta_tables,04_notebook_to_job,05_autoloader_intro,06_basic_governance}

mkdir -p $ROOT/07-databricks/pet-projects/{01_lakehouse_pipeline,02_cdc_to_delta,03_bi_ready_gold_layer,04_end_to_end_databricks_project}

touch $ROOT/07-databricks/README.md

# ------------------------------------------------
# 08 Delta Lake
# ------------------------------------------------

mkdir -p $ROOT/08-delta-lake/{learning-materials,simple-tasks,pet-projects}
touch $ROOT/08-delta-lake/README.md

# ------------------------------------------------
# 09 Azure Data Lake Storage
# ------------------------------------------------

mkdir -p $ROOT/09-azure-data-lake-storage/learning-materials/{storage-basics,adls-gen2,access-control,partitioning-layout,integration-patterns}

mkdir -p $ROOT/09-azure-data-lake-storage/simple-tasks/{01_storage_account_layout,02_raw_curated_zones,03_partition_strategy,04_access_and_secrets_concepts}

mkdir -p $ROOT/09-azure-data-lake-storage/pet-projects/{01_cloud_data_landing_zone,02_bronze_silver_gold_storage_design,03_adls_for_databricks_pipeline}

touch $ROOT/09-azure-data-lake-storage/README.md

# ------------------------------------------------
# 10 Power BI / Fabric
# ------------------------------------------------

mkdir -p $ROOT/10-powerbi-fabric/learning-materials/{power-query,data-modeling,dax,performance,rls,fabric-overview}

mkdir -p $ROOT/10-powerbi-fabric/simple-tasks/{01_first_dashboard,02_star_schema_model,03_dax_measures,04_power_query_cleaning,05_rls_basic_case}

mkdir -p $ROOT/10-powerbi-fabric/pet-projects/{01_executive_dashboard,02_sales_analytics_report,03_operational_monitoring_dashboard,04_bi_portfolio_case}

touch $ROOT/10-powerbi-fabric/README.md

# ------------------------------------------------
# Real Projects
# ------------------------------------------------

mkdir -p $ROOT/real-projects/{01_python_sql_etl,02_python_docker_github_actions,03_python_kafka,04_python_kafka_databricks,05_python_spark_delta,06_databricks_adls_powerbi,07_kafka_databricks_powerbi,08_end_to_end_data_platform}

touch $ROOT/real-projects/README.md

echo ""
echo "✅ Data Platform Roadmap structure created!"
echo ""

if command -v tree &> /dev/null
then
    tree -L 3
else
    echo "Install tree to view structure:"
    echo "brew install tree"
fi