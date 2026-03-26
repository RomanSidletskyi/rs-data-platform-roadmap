# Real Project 01: Python Plus SQL ETL

## Goal

Build a simple but production-shaped batch ETL pipeline using Python and SQL.

The project should establish the baseline architecture for extraction, raw landing, transformation, and curated analytical output.

Current MVP status:

- runnable locally
- uses CSV as source input
- preserves raw snapshots in `data/raw/`
- writes data quality reports into `data/quality/`
- loads raw and curated layers into SQLite
- builds a daily sales summary as the first curated output
- supports CLI overrides for source path, database path, and run mode

## Suggested Stack

- Python
- SQL
- local files or database storage
- simple scheduler or manual run entrypoint

## Architecture Focus

- batch pipeline shape
- raw versus curated boundaries
- rerun and backfill safety
- idempotent load behavior

## Suggested Deliverables

- project structure for extraction, transformation, and load
- sample dataset or fixtures
- raw landing layer
- curated analytical table or reporting output
- run instructions
- validation notes

## Current Repository Structure

```text
01_python_sql_etl/
	README.md
	architecture-notes.md
	adr.md
	implementation-plan.md
	config/
		settings.json
	data/
		quality/
		raw/
		source/
			orders.csv
			orders_invalid.csv
		warehouse/
			warehouse.db
	src/
		python_sql_etl/
			config_loader.py
			database.py
			io_utils.py
			pipeline.py
			quality.py
	tests/
		test_pipeline.py
	run_pipeline.py
```

## Pipeline Flow

1. read source CSV from `data/source/orders.csv`
2. write a timestamped raw snapshot into `data/raw/`
3. load raw rows into SQLite table `raw_orders`
4. build curated table `curated_daily_sales` with SQL aggregation
5. log the resulting curated rows

## How To Run

From the project directory:

```bash
/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/.venv/bin/python run_pipeline.py
```

Useful CLI examples:

Full run with defaults:

```bash
/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/.venv/bin/python run_pipeline.py --run-mode full
```

Extract only:

```bash
/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/.venv/bin/python run_pipeline.py --run-mode extract
```

Load raw only:

```bash
/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/.venv/bin/python run_pipeline.py --run-mode load
```

Transform from the latest raw load already in SQLite:

```bash
/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/.venv/bin/python run_pipeline.py --run-mode transform
```

Override source file:

```bash
/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/.venv/bin/python run_pipeline.py --source-path data/source/orders.csv
```

Override database path:

```bash
/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/.venv/bin/python run_pipeline.py --database-path data/warehouse/custom_warehouse.db
```

## How To Validate

Run the smoke test:

```bash
/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/.venv/bin/python -m unittest tests/test_pipeline.py
```

This test suite now checks both:

- successful full pipeline execution
- failure on invalid input data quality

## Data Quality Checks

Before the curated layer is built, the pipeline checks:

- required fields are present
- `order_id` values are unique
- `order_date` is a valid ISO date
- `quantity` is a positive integer
- `unit_price` is a positive number

If validation fails:

- the quality report is still written into `data/quality/`
- the pipeline stops before curated output is rebuilt

## Included Local Assets

You do not need to download external data for this MVP.

Included in the project already:

- `data/source/orders.csv` as the valid sample source
- `data/source/orders_invalid.csv` as the failing sample source for quality-check practice
- `data/warehouse/warehouse.db` as the local SQLite target created by the pipeline

## Step-By-Step Practice Path

If you want to build or understand the project yourself, use this order:

1. read `architecture-notes.md` and `adr.md`
2. inspect `config/settings.json`
3. inspect `data/source/orders.csv`
4. run `--run-mode extract`
5. inspect the new raw snapshot in `data/raw/`
6. run `--run-mode load`
7. inspect raw data in SQLite table `raw_orders`
8. run `--run-mode transform`
9. inspect curated data in SQLite table `curated_daily_sales`
10. run the smoke test
11. run the pipeline against `data/source/orders_invalid.csv` to see the quality gate fail

## What The Final State Should Be

When you finish the MVP successfully, you should have:

- one or more timestamped raw CSV snapshots in `data/raw/`
- one or more JSON quality reports in `data/quality/`
- SQLite database at `data/warehouse/warehouse.db`
- raw table `raw_orders`
- curated table `curated_daily_sales`
- log file at `logs/pipeline.log`
- passing smoke test output from `unittest`

## First Curated Output

The MVP builds `curated_daily_sales` with:

- `sales_date`
- `product_category`
- `orders_count`
- `total_quantity`
- `gross_revenue`

This output is the business-facing layer. Raw snapshots and `raw_orders` stay technical layers.

## Rerun Behavior

- every run writes a new raw CSV snapshot with a timestamped filename
- raw rows are loaded under a unique `run_id`
- curated output is rebuilt deterministically from the current run's raw load

## Next Extensions

- add customer dimension and joins
- add separate source and target schemas beyond the single orders example
- add stronger SQL-based validation after raw load
- containerize the project in the next real-project stage

## Review Questions

- where is raw data stored before transformation
- how would the pipeline rerun after partial failure
- which output is safe for business consumption

## Read With

- `../../docs/architecture/reviews/real-project-review-exercises.md`
- `../../docs/architecture/reviews/batch-pipeline-review-checklist.md`
- `../../docs/architecture/adr/template.md`