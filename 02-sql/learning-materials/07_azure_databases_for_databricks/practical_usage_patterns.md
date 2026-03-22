
cat <<'EOF' > "$MODULE/learning-materials/07_azure_databases_for_databricks/synapse_vs_databricks_sql.md" <<'EOF'
# Synapse vs Databricks SQL

| Feature | Synapse SQL | Databricks SQL |
|---|---|---|
| Main style | warehouse SQL | lakehouse SQL |
| Core storage fit | warehouse / external query | Delta Lake |
| Best for | BI and warehouse patterns | analytics, engineering, lakehouse |
| Engine character | MPP warehouse style | Spark-based SQL over lakehouse |

## Use Synapse SQL When

- SQL warehouse model is dominant
- BI/reporting is the main driver
- platform is organized around warehouse semantics

## Use Databricks SQL When

- Delta Lake is central
- data engineering and analytics are combined
- ML and broader platform workflows matter
