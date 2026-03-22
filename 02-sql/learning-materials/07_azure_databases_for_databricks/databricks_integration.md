
cat <<'EOF' > "$MODULE/learning-materials/07_azure_databases_for_databricks/database_selection_guide.md" <<'EOF'
# Database Selection Guide

## Use Azure SQL When

- workload is transactional
- relational integrity matters
- application backend needs familiar SQL engine
- source system is OLTP

## Use CosmosDB When

- globally distributed app is needed
- JSON documents fit naturally
- partition-aware NoSQL model is appropriate
- microservice operational workload dominates

## Use Synapse SQL When

- warehouse-style SQL is primary
- BI / reporting is dominant
- data lake query integration is needed in warehouse style

## Use Databricks + Delta When

- analytics platform is core
- batch + streaming are needed
- data engineering pipelines dominate
- lakehouse architecture is the target
