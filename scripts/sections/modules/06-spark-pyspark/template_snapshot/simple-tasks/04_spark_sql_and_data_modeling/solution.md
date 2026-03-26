# Solutions: Spark SQL And Data Modeling

## Task 1

Possible answer:

`order_line_daily_metrics` has one row per order line per business date. That means any measure in the table should be interpretable at that exact unit, and downstream users should not assume one row per order unless they aggregate intentionally.

## Task 2

- orders: fact-like
- products: dimension-like
- countries: dimension-like
- payments: fact-like

The main distinction is whether the dataset primarily represents measurable business events or descriptive context.

## Task 3

A safe strategy is to reprocess the last three days on every run and overwrite only the affected partitions. This aligns pipeline behavior with known data lateness instead of pretending the data is final after one day.

## Task 4

Current-state-only may be insufficient when historical analysis must reflect the category value that was valid at the time of the event rather than the latest category value.