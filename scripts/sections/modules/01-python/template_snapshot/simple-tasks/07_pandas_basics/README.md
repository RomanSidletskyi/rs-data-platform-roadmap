# Pandas Basics

This section focuses on `pandas` as a practical tool for small and medium tabular transformations.

The goal is not only to learn DataFrame syntax.

The goal is to practice the kinds of operations that appear constantly in real data work:

- reading files
- inspecting schema and shape
- filtering rows
- cleaning nulls
- deduplicating data
- joining reference tables
- parsing dates
- building output reports

## What Good Completion Looks Like

By the end of this block, you should be able to:

- load CSV files confidently
- inspect columns and dtypes before transforming data
- explain how nulls are handled
- join two tabular datasets without guessing blindly
- create grouped summaries with readable column names
- write processed output intentionally

## Task 1 — Load CSV Into A DataFrame

### Goal

Read tabular data with `pandas` and inspect it before any transformation.

### Input

`sales.csv`

```csv
id,amount,category
1,100,A
2,200,B
3,150,A
4,300,C
```

### Requirements

- load the CSV file into a DataFrame
- inspect column names
- inspect row count and shape
- print sample records
- inspect data types

### Expected Output

A DataFrame with 4 rows and 3 columns, plus basic inspection output.

### Extra Challenge

- print summary statistics
- explain which columns are numeric versus categorical

## Task 2 — Filter Rows And Select Columns

### Goal

Practice row filtering and column selection.

### Input

Use the same `sales.csv`.

### Requirements

- filter rows where `amount > 150`
- keep only `id` and `amount`
- sort by `amount` descending

### Expected Output

Rows for ids 4 and 2 with selected columns.

### Extra Challenge

- save filtered output to `data/processed/high_value_sales.csv`
- compare `.loc[]` with boolean indexing

## Task 3 — Handle Null Values

### Goal

Work with incomplete data intentionally instead of ignoring nulls.

### Input

`users.csv`

```csv
id,name,email
1,Alice,alice@example.com
2,Bob,
3,,charlie@example.com
4,David,david@example.com
```

### Requirements

- identify missing values
- produce one version that drops critical nulls
- produce one version that fills selected nulls
- explain why you used different strategies

### Expected Output

At least two cleaned DataFrames with different null-handling strategies.

### Extra Challenge

- decide which fields are required versus optional
- write cleaned outputs to separate CSV files

## Task 4 — Group And Aggregate

### Goal

Build small analytical summaries.

### Input

`sales.csv`

```csv
id,amount,category
1,100,A
2,200,B
3,150,A
4,300,C
5,120,A
```

### Requirements

- group by `category`
- calculate row count
- calculate sum of `amount`
- calculate average of `amount`
- sort results by total amount descending
- rename columns clearly

### Expected Output

A grouped summary by category.

### Extra Challenge

- round average values
- save the summary to `data/processed/category_summary.csv`

## Task 5 — Join Two DataFrames

### Goal

Combine related datasets and inspect join quality.

### Input

`users.csv`

```csv
id,name
1,Alice
2,Bob
3,Charlie
```

`cities.csv`

```csv
id,city
1,Warsaw
2,Krakow
4,Gdynia
```

### Requirements

- join the two tables by `id`
- run both an inner join and a left join
- inspect unmatched rows
- explain what the join result means

### Expected Output

Two merged DataFrames and one view of unmatched records.

### Extra Challenge

- use `indicator=True`
- write unmatched rows to a separate CSV report

## Task 6 — Parse Date Columns

### Goal

Prepare time-based data for filtering and grouping.

### Input

`events.csv`

```csv
id,event_date
1,2025-01-01
2,2025-02-15
3,2025-03-10
```

### Requirements

- convert strings to datetime
- extract year and month
- extract day name
- filter rows by a date range

### Expected Output

A DataFrame with parsed date columns and a filtered subset.

### Extra Challenge

- group by month
- explain why parsing dates early is safer than treating them as strings

## Task 7 — Remove Duplicates

### Goal

Practice data quality basics in a tabular workflow.

### Input

`users.csv`

```csv
id,name
1,Alice
2,Bob
2,Bob
3,Charlie
3,Charlie
```

### Requirements

- identify duplicate rows
- remove duplicates
- compare row counts before and after
- report how many duplicates were removed

### Expected Output

A deduplicated DataFrame and a small duplicate-count summary.

### Extra Challenge

- compare `keep="first"` and `keep="last"`
- detect duplicates only on selected business keys

## Task 8 — Build A Small Summary Report

### Goal

Create a useful processed output that combines several `pandas` skills.

### Input

Use one of the earlier datasets or combine two of them.

### Requirements

- inspect the data first
- apply at least one cleaning step
- apply at least one filter
- build a grouped or sorted summary
- save final results to CSV
- name the output clearly

### Expected Output

A CSV summary report and a short explanation of what the report represents.

### Extra Challenge

- save the report with a timestamped filename
- create both a detailed cleaned dataset and a separate summary dataset

## Key Learning Rule

Do not use `pandas` as a magic black box.

Before each transformation, make sure you can answer:

- what is the input shape
- what is the output shape
- why is this cleaning step needed
- what data quality assumption is being enforced
