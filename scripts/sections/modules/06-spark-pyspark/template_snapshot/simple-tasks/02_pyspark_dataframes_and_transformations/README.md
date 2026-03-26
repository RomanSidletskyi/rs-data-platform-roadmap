# Simple Tasks: PySpark DataFrames And Transformations

## Task 1: Define Grain

You are building a dataset called `customer_daily_revenue`.

Define the grain explicitly and list two mistakes that may happen if the grain is not documented.

## Task 2: Join Review

You need to join a large orders dataset with a small country reference dataset.

Explain:

- why this is not the same as joining two large fact-like datasets
- what you would prune before the join

## Task 3: Null And Type Handling

Describe a safe strategy for handling:

- null revenue values
- malformed timestamps
- inconsistent country-code formats

## Task 4: Output Layout

You are writing a daily analytical dataset mostly queried by `event_date`.

Explain why output layout matters for downstream jobs and BI consumers.