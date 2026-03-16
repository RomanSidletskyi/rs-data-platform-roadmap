# Pandas Basics

This section focuses on pandas for small and medium data transformations.

---

## Task 1 — Load CSV Into a DataFrame

### Goal
Read tabular data with pandas.

### Input

    sales.csv

    id,amount,category
    1,100,A
    2,200,B
    3,150,A
    4,300,C

### Requirements

- load the CSV file
- inspect columns and row count
- print sample records

### Expected Output

A DataFrame with 4 rows and 3 columns.

### Extra Challenge

- print data types
- print summary statistics

---

## Task 2 — Filter Rows and Select Columns

### Goal
Practice slicing data.

### Input

Use the same `sales.csv`.

### Requirements

- filter rows where `amount > 150`
- keep only `id` and `amount`

### Expected Output

Rows for ids 2 and 4 with selected columns.

### Extra Challenge

- save filtered output to CSV
- sort by amount descending

---

## Task 3 — Handle Null Values

### Goal
Work with incomplete data.

### Input

    users.csv

    id,name,email
    1,Alice,alice@example.com
    2,Bob,
    3,,charlie@example.com
    4,David,david@example.com

### Requirements

- identify nulls
- fill or remove missing values
- explain your approach

### Expected Output

A cleaned DataFrame with null handling applied.

### Extra Challenge

- create one version with dropped nulls
- create another version with filled nulls

---

## Task 4 — Group and Aggregate

### Goal
Build simple summaries.

### Input

    sales.csv

    id,amount,category
    1,100,A
    2,200,B
    3,150,A
    4,300,C
    5,120,A

### Requirements

- group by `category`
- calculate count and sum of `amount`
- sort results

### Expected Output

A grouped summary by category.

### Extra Challenge

- add average amount per category
- rename output columns clearly

---

## Task 5 — Join Two DataFrames

### Goal
Combine related datasets.

### Input

    users.csv
    id,name
    1,Alice
    2,Bob
    3,Charlie

    cities.csv
    id,city
    1,Warsaw
    2,Krakow
    4,Gdynia

### Requirements

- join two tables by `id`
- use left or inner join
- inspect unmatched rows

### Expected Output

A merged DataFrame.

### Extra Challenge

- show rows that did not match
- compare left join vs inner join results

---

## Task 6 — Parse Date Columns

### Goal
Prepare time-based data.

### Input

    events.csv

    id,event_date
    1,2025-01-01
    2,2025-02-15
    3,2025-03-10

### Requirements

- convert strings to datetime
- extract year and month
- filter by date range

### Expected Output

A DataFrame with parsed date columns.

### Extra Challenge

- add day of week
- group by month

---

## Task 7 — Remove Duplicates

### Goal
Practice data quality basics.

### Input

    users.csv

    id,name
    1,Alice
    2,Bob
    2,Bob
    3,Charlie
    3,Charlie

### Requirements

- identify duplicate rows
- remove duplicates
- compare row counts before and after

### Expected Output

A deduplicated DataFrame.

### Extra Challenge

- keep only the first duplicate
- report how many duplicates were removed

---

## Task 8 — Build a Small Summary Report

### Goal
Create a useful processed output.

### Input

Use any of the previous datasets.

### Requirements

- combine filtering, aggregation, and sorting
- generate a compact summary dataset
- save final results to CSV

### Expected Output

A CSV summary report.

### Extra Challenge

- save the report with a timestamped filename
- create two summary views from the same dataset
