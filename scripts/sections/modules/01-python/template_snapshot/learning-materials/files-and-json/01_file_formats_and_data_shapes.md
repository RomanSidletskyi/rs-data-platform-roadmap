# File Formats And Data Shapes

## Why This Topic Matters

Much of early data engineering is file work.

If the learner cannot reason clearly about file shape, record shape, and output shape, later tooling becomes accidental instead of intentional.

## Common Shapes

### CSV

Good for:

- tabular datasets
- simple exports
- lightweight interchange

### JSON

Good for:

- nested API responses
- config files
- semi-structured records

## Good Strategy

- inspect input shape before writing transformation logic
- document required keys and output columns
- keep raw inputs separate from cleaned outputs

## Bad Strategy

- assume JSON is always flat enough to convert directly to CSV
- mix raw and processed outputs in one folder

## Libraries Worth Knowing Here

### Start With The Standard Library

The first tools here should usually be:

- `json`
- `csv`
- `pathlib`
- `gzip`

Why:

- these are enough for a large amount of early file work
- they teach file shape and data shape directly
- they keep the learner close to the mechanics of the format

### Add `pandas` When Tabular Manipulation Grows

Worth using when:

- the file is tabular
- many column transforms are needed
- deduplication and profiling become repetitive

Example:

```python
import pandas as pd


df = pd.read_csv("data/raw/orders.csv")
df["status"] = df["status"].str.strip().str.lower()
df = df.drop_duplicates(subset=["order_id"])
df.to_csv("data/processed/orders.csv", index=False)
```

### Add `pyarrow` When Parquet Appears

Worth using when:

- parquet enters the workflow
- the learner starts working with columnar formats

Example:

```python
import pandas as pd


df = pd.read_csv("data/raw/orders.csv")
df.to_parquet("data/processed/orders.parquet", index=False)
```

## Key Architectural Takeaway

File handling is where data contracts start becoming visible.