This reference example assumes a local Airflow runtime where `src/` and `data/` are mounted into the Airflow container.

Useful runtime notes:

- mount the project folder into `/opt/airflow/project`
- ensure the raw base path from `.env.example` exists or can be created
- install dependencies from `requirements.txt`

The DAG code itself is designed to work with a normal local Airflow environment rather than a large production deployment.