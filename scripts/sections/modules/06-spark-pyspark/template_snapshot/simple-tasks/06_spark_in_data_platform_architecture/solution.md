# Solutions: Spark In Data-Platform Architecture

## Task 1

Calling Spark the compute layer means Spark sits between ingestion and consumption and performs the heavy transformation work that turns raw or partially structured data into reusable analytical datasets.

## Task 2

Good Spark candidate:

- large-scale transformation of raw event history into curated analytical outputs

Possible better fit elsewhere:

- a small relational daily aggregate already living in the warehouse

The boundary should be chosen by workload shape and platform simplicity, not by tool habit.

## Task 3

Minimum questions:

- who owns the job?
- who owns the dataset semantics?
- what validations must pass before publish?
- who responds to failure or bad output?
- how is replay or backfill performed safely?

## Task 4

Two common signs:

- small or simple workloads are forced through Spark without clear value
- the team cannot explain why Spark is still the right layer for a given transformation