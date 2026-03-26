# Local Spark Environment And Project Shape

## Why This Topic Matters

Spark learning becomes much easier when the local development environment is predictable and the project layout separates raw inputs, transformation code, tests, and output artifacts clearly.

Without this, beginners often confuse environment problems with Spark problems.

## What A Healthy Local Setup Should Support

A good local Spark setup should allow you to:

- run small DataFrame transformations locally
- inspect input and output data clearly
- keep sample datasets deterministic
- validate outputs with simple repeatable checks
- separate raw data, code, and test fixtures

The goal is not to simulate a full cluster.

The goal is to create a learning environment where Spark behavior is visible and repeatable.

## Recommended Project Shape

A practical Spark practice project usually benefits from:

- `src/` for transformation logic
- `data/` for sample raw inputs
- `tests/` for expected outputs or smoke checks
- `config/` for runtime settings and path examples
- `docker/` when local reproducibility matters later

This is already consistent with the repository's broader project pattern.

## Example Local Flow

A small Spark batch practice project might look like this:

1. raw CSV or JSON files are stored under `data/`
2. PySpark code in `src/` reads raw inputs
3. transformations build a cleaned or aggregated DataFrame
4. the result is written to a local output path
5. a test or smoke-check script compares output with a fixture

This pattern matters because it teaches rebuildable pipelines rather than notebook-only experimentation.

## Real Local Project Example

```python
from pyspark.sql import SparkSession, functions as F

spark = (
	SparkSession.builder
	.appName("local-orders-preview")
	.master("local[*]")
	.getOrCreate()
)

orders = spark.read.json("data/raw/orders.jsonl")

daily_summary = (
	orders
	.filter(F.col("event_date") == F.lit("2026-03-24"))
	.groupBy("country_code")
	.agg(F.sum("net_amount").alias("revenue"))
)

daily_summary.write.mode("overwrite").json("data/output/daily_summary")
```

## Why This Is A Good Learning Example

- `master("local[*]")` makes the code runnable on one machine without pretending to be a real cluster
- `data/raw/` and `data/output/` keep input and result paths easy to inspect
- the job is small enough for learning, but still uses the same read-transform-write shape as production jobs

## Useful Smoke Check Example

```bash
python src/build_daily_summary.py
test -f data/output/daily_summary/_SUCCESS
```

This is intentionally simple.

The point is to teach that even local Spark practice should be repeatable and testable.

## Local Learning Principles

### Use Small But Honest Data

The dataset can be tiny, but it should still reflect real transformation issues such as:

- nulls
- duplicated records
- bad types
- uneven key distributions

### Keep Fixtures Deterministic

Spark jobs are easier to trust when the learner can compare output against a stable expected result.

### Separate Transformation Logic From Environment Setup

This helps the learner distinguish:

- data logic bugs
- path or dependency bugs
- output validation bugs

## Why Project Shape Matters Architecturally

A healthy local structure builds habits that scale later.

Teams that learn Spark only through ad hoc notebook cells often struggle when they later need:

- repeatable jobs
- versioned code
- deterministic smoke checks
- production-style debugging

So even the local project shape contributes to architecture thinking.

## Good Strategy

- keep local Spark projects reproducible and fixture-driven
- model the project after real raw-to-curated flows
- separate data, code, configuration, and tests clearly
- use local practice to prepare for production-shaped reasoning later

## Key Architectural Takeaway

Good local Spark setup is not just convenience. It is the first step toward reliable, rebuildable distributed data engineering.