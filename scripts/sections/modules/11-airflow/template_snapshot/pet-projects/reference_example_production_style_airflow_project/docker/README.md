This reference example is designed for a local Airflow runtime where the project folder is mounted into the Airflow container.

Useful runtime notes:

- make `src/` available in the Airflow container
- ensure `RAW_OUTPUT_ROOT` points to a writable location
- install dependencies from `requirements.txt`

The DAG models production-style concerns, but keeps the runtime simple enough for local learning.