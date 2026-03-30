# Config Notes

Use this folder for:

- Spark catalog configuration
- Glue catalog naming assumptions
- S3 warehouse root decisions
- environment-specific settings that should not be buried in job logic

Suggested first file to create:

- `spark_catalog_config.md`

Starter asset already included:

- `runtime_config.json`

Optional local lab assets also included:

- `.env.local.example`
- `local_lab_runtime_config.json`
- `spark-defaults.local.conf.template`