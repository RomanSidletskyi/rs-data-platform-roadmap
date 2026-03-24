# 07 Pandas Basics - Solution

This file gives reference patterns for small and medium tabular transformations.

The goal is to show `pandas` as a practical transformation tool, not as a replacement for clear data reasoning.

## Pattern 1 - Load And Inspect Data

```python
import pandas as pd


df = pd.read_csv("sales.csv")

print(df.head())
print(df.shape)
print(df.columns.tolist())
print(df.dtypes)
print(df.describe(include="all"))
```

Why this matters:

- good `pandas` work starts with inspecting shape and schema before changing anything

## Pattern 2 - Filter Rows And Columns

```python
filtered = (
    df.loc[df["amount"] > 150, ["id", "amount"]]
    .sort_values("amount", ascending=False)
    .reset_index(drop=True)
)
```

Why this is a good baseline:

- filtering, selecting, sorting, and resetting index are common early operations

## Pattern 3 - Handle Nulls With Intent

```python
users_df = pd.read_csv("users.csv")

dropped_nulls = users_df.dropna(subset=["name", "email"])
filled_nulls = users_df.fillna({"name": "unknown", "email": "missing@example.com"})
```

Good reasoning:

- drop rows when required fields are missing
- fill values when the field can safely use a default

## Pattern 4 - Group And Aggregate

```python
summary = (
    df.groupby("category", as_index=False)
    .agg(
        order_count=("id", "count"),
        total_amount=("amount", "sum"),
        average_amount=("amount", "mean"),
    )
    .sort_values("total_amount", ascending=False)
)

summary["average_amount"] = summary["average_amount"].round(2)
```

Why this matters:

- grouped summaries are one of the fastest ways to turn raw tabular data into something useful

## Pattern 5 - Join DataFrames And Inspect Match Quality

```python
users_df = pd.read_csv("users.csv")
cities_df = pd.read_csv("cities.csv")

left_joined = users_df.merge(cities_df, on="id", how="left", indicator=True)
inner_joined = users_df.merge(cities_df, on="id", how="inner")
unmatched = left_joined.loc[left_joined["_merge"] != "both"]
```

Why this matters:

- joins are not only about combining data
- they are also about understanding missing reference matches

## Pattern 6 - Parse Dates Early

```python
events_df = pd.read_csv("events.csv")

events_df["event_date"] = pd.to_datetime(events_df["event_date"])
events_df["year"] = events_df["event_date"].dt.year
events_df["month"] = events_df["event_date"].dt.month
events_df["day_name"] = events_df["event_date"].dt.day_name()

filtered_events = events_df.loc[
    events_df["event_date"].between("2025-02-01", "2025-03-31")
]
```

Why this is safer:

- once dates are real datetime values, filtering and grouping become more reliable than string-based logic

## Pattern 7 - Identify And Remove Duplicates

```python
users_df = pd.read_csv("users.csv")

duplicate_rows = users_df.loc[users_df.duplicated(keep=False)]
deduplicated = users_df.drop_duplicates(keep="first")

duplicates_removed = len(users_df) - len(deduplicated)
```

Why this matters:

- duplicate handling is a small but real data quality step

## Pattern 8 - Build A Small Summary Report

```python
report = (
    df.loc[df["amount"] >= 120]
    .groupby("category", as_index=False)
    .agg(total_amount=("amount", "sum"), record_count=("id", "count"))
    .sort_values("total_amount", ascending=False)
)

report.to_csv("data/processed/category_report.csv", index=False)
```

Why this is a good end-of-block task:

- it combines filtering, grouping, sorting, and intentional output writing

## Key Point

Pandas in this module should be treated as a practical transformation tool, not as a replacement for architectural thinking.

The key questions are still:

- what is the input shape
- what is changing
- why is it changing
- what output is being produced