# Operating Model

This reference example assumes:

- developers run locally against `ANALYTICS_DEV`
- pull requests validate against `ANALYTICS_QA`
- merges to main deploy against `ANALYTICS_PROD`

Artifacts to inspect after runs:

- `logs/dbt.log`
- `target/compiled/`
- `target/run/`
- `manifest.json`
- `run_results.json`
