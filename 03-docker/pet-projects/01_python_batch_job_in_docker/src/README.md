# Starter Notes For src

Implement the batch application here.

Suggested files:

- `main.py` as the entry point
- `batch_job.py` or similar helper module for transformation and output logic

Recommended minimum responsibilities:

- load config from `CONFIG_PATH`
- read CSV input from `INPUT_PATH`
- validate required columns
- aggregate totals by region and category
- write output artifacts into `OUTPUT_DIR`

Use environment variables instead of hardcoded paths.