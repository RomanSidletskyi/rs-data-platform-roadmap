# Snowflake Simple Tasks

These short, account-free exercises help turn the references and deep dives into working understanding. Complete the task first, write down assumptions, and then compare your reasoning with the solution.

1. [Platform and objects](01_platform_and_objects/README.md)
2. [SQL and semi-structured data](02_sql_and_semi_structured/README.md)
3. [Ingestion and replay](03_ingestion_and_replay/README.md)
4. [Processing patterns](04_processing_patterns/README.md)
5. [Performance and cost](05_performance_and_cost/README.md)
6. [Security, recovery, and architecture](06_security_recovery_architecture/README.md)
7. [Snowflake storage and ingestion](07_snowflake_storage_and_ingestion/README.md)
8. [Snowflake open tables and refresh](08_snowflake_open_table_and_refresh/README.md)
9. [Snowflake architecture scenarios](09_snowflake_architecture_scenarios/README.md)
10. [Snowflake performance diagnosis and design](10_snowflake_performance/README.md)

The solution files are deliberately concise. A defensible alternative is valid when it states the constraints and trade-offs that make it fit.

## Optional Hands-On

The tasks do not need an account. To try your answers in Snowflake:

1. Open a trial: [Snowflake trial account](../../../shared/environments/setup-guide/accounts/snowflake.md), including its day-one cost guardrails.
2. Run SQL from files with the [Snowflake CLI](../../../shared/environments/setup-guide/02_cli_tools_and_auth.md#snowflake-cli), or paste into a Snowsight worksheet.
3. For ingestion tasks (03, 07), practice storage access with [Azure](../../../shared/environments/setup-guide/accounts/azure.md) or locally with the [Azurite emulator](../../../shared/environments/setup-guide/03_local_services.md#stack-c-azurite-azure-storage-emulator).
4. For semi-structured and file-format tasks (02, 07), [DuckDB](../../../shared/environments/setup-guide/03_local_services.md#duckdb) can read local JSON and Parquet for free.