# Compute Selection Recipe

## Goal

Choose the right Databricks compute surface for the workload rather than defaulting to one cluster type for everything.

## Recipe

1. Identify whether the workload is exploratory, production ETL, or analytical serving.
2. Use all-purpose compute for interactive exploration.
3. Use job compute for repeatable scheduled pipelines.
4. Use SQL warehouses for governed analytical query serving.
5. Revisit cost and isolation after the first production runs.

## Rule

Choose compute based on workload shape and operating boundary, not on personal habit.