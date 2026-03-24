# Solutions: Delta Lake Foundations

## Task 1

Delta Lake is a transactional table layer on top of data-lake storage. It is not the same as Parquet, which is only a file format; it is not the same as Spark, which is the compute engine; it is not the same as Databricks, which may provide the managed platform around it; and it is not cloud storage, which persists the files physically.

## Task 2

A Delta table should be understood as files plus transaction log because the log defines which files belong to each table version. That is why the platform can support time travel, atomic commits, and safer recovery.

## Task 3

Delta adds transactional state, history, controlled mutation semantics, schema controls, and safer repair options. Plain Parquet gives only file storage behavior, not table-level change management.

## Task 4

Time travel is useful for inspection and recovery. Schema evolution is useful for intentional table change. Both are dangerous if used without thinking about downstream consumers, governance, and recovery boundaries.
