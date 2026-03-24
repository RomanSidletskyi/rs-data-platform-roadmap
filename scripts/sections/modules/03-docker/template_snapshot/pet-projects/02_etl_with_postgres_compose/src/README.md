# Starter Notes For src

Implement the ETL application here.

Recommended minimum files:

- `main.py` as the entry point
- one helper module for extraction, transformation, and loading logic

Recommended responsibilities:

- read source CSV from `INPUT_PATH`
- validate required fields from `config/etl_config.json`
- load raw records into Postgres
- create one transformed summary output in Postgres