#!/usr/bin/env bash

set -e

MODULE="02-sql"

create_dir() {
  if [ ! -d "$1" ]; then
    mkdir -p "$1"
    echo "[CREATE DIR] $1"
  else
    echo "[SKIP DIR] $1"
  fi
}

create_file() {
  if [ ! -f "$1" ]; then
    touch "$1"
    echo "[CREATE FILE] $1"
  else
    echo "[SKIP FILE] $1"
  fi
}

echo "Initializing SQL module structure..."

# Root
create_dir "$MODULE"

# Main folders
create_dir "$MODULE/learning-materials"
create_dir "$MODULE/simple-tasks"
create_dir "$MODULE/pet-projects"

# Learning modules
create_dir "$MODULE/learning-materials/01_sql_analytics_patterns"
create_dir "$MODULE/learning-materials/02_sql_for_lakehouse"
create_dir "$MODULE/learning-materials/03_sql_vs_nosql_architecture"
create_dir "$MODULE/learning-materials/04_document_database_modeling"
create_dir "$MODULE/learning-materials/05_mongodb"
create_dir "$MODULE/learning-materials/06_dynamodb"
create_dir "$MODULE/learning-materials/07_azure_databases_for_databricks"

# Global learning files
create_file "$MODULE/learning-materials/data_modeling_comparison.md"
create_file "$MODULE/learning-materials/query_pattern_cheatsheet.md"
create_file "$MODULE/learning-materials/indexing_strategy_across_databases.md"

# MongoDB files
create_file "$MODULE/learning-materials/05_mongodb/README.md"
create_file "$MODULE/learning-materials/05_mongodb/python_setup.md"
create_file "$MODULE/learning-materials/05_mongodb/queries.md"
create_file "$MODULE/learning-materials/05_mongodb/aggregation.md"
create_file "$MODULE/learning-materials/05_mongodb/indexing.md"
create_file "$MODULE/learning-materials/05_mongodb/data_modeling.md"

# DynamoDB
create_file "$MODULE/learning-materials/06_dynamodb/README.md"
create_file "$MODULE/learning-materials/06_dynamodb/architecture.md"
create_file "$MODULE/learning-materials/06_dynamodb/query_patterns.md"
create_file "$MODULE/learning-materials/06_dynamodb/data_modeling.md"
create_file "$MODULE/learning-materials/06_dynamodb/hot_partition_problem.md"

# Azure databases
create_file "$MODULE/learning-materials/07_azure_databases_for_databricks/README.md"
create_file "$MODULE/learning-materials/07_azure_databases_for_databricks/azure_sql_database.md"
create_file "$MODULE/learning-materials/07_azure_databases_for_databricks/azure_sql_indexes.md"
create_file "$MODULE/learning-materials/07_azure_databases_for_databricks/azure_sql_stored_procedures.md"
create_file "$MODULE/learning-materials/07_azure_databases_for_databricks/azure_cosmosdb.md"
create_file "$MODULE/learning-materials/07_azure_databases_for_databricks/cosmos_queries.md"
create_file "$MODULE/learning-materials/07_azure_databases_for_databricks/synapse_sql.md"
create_file "$MODULE/learning-materials/07_azure_databases_for_databricks/synapse_queries.md"
create_file "$MODULE/learning-materials/07_azure_databases_for_databricks/databricks_integration.md"

# Simple tasks
create_dir "$MODULE/simple-tasks/01_analytics_queries"
create_dir "$MODULE/simple-tasks/02_window_queries"
create_dir "$MODULE/simple-tasks/03_document_queries"
create_dir "$MODULE/simple-tasks/04_nosql_modeling"

create_file "$MODULE/simple-tasks/01_analytics_queries/README.md"
create_file "$MODULE/simple-tasks/02_window_queries/README.md"
create_file "$MODULE/simple-tasks/03_document_queries/README.md"
create_file "$MODULE/simple-tasks/04_nosql_modeling/README.md"

# Pet projects
create_dir "$MODULE/pet-projects/01_sql_analytics_engine"
create_dir "$MODULE/pet-projects/02_mongodb_event_store"
create_dir "$MODULE/pet-projects/03_relational_to_document_migration"

create_file "$MODULE/pet-projects/01_sql_analytics_engine/README.md"
create_file "$MODULE/pet-projects/02_mongodb_event_store/README.md"
create_file "$MODULE/pet-projects/03_relational_to_document_migration/README.md"

echo "SQL module structure initialized."