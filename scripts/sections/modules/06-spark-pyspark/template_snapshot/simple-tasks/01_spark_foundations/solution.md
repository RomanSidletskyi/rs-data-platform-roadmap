# Solutions: Spark Foundations

## Task 1

- the driver coordinates the Spark application
- executors perform distributed work
- a job is triggered by an action
- a stage is a group of tasks with a similar execution boundary
- a task is the smallest scheduled unit of work on a partition

Architectural reasoning:

The driver plans and coordinates. Executors do the parallel work. Jobs break into stages, and stages break into tasks. This hierarchy helps explain where runtime cost and failures appear.

## Task 2

- `filter`: mostly narrow
- `select`: mostly narrow
- `groupBy`: mostly wide
- `join`: often wide
- `withColumn`: often narrow unless it participates in later wide regrouping logic

Reasoning:

Narrow operations usually preserve local partition work. Wide operations usually require regrouping across the cluster.

## Task 3

Spark builds a logical plan first and delays execution until an action is requested.

This helps because Spark can optimize the plan, reduce unnecessary work, and schedule a better distributed execution path.

## Task 4

Spark should not be the default tool here.

If the workload is small, already warehouse-resident, and mostly relational, warehouse SQL may be simpler and cheaper. Strong architecture means using Spark when distributed compute is justified, not by habit.