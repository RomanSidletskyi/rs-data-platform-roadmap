# Cost And Performance Levers

## Why This Topic Matters

Managed platforms make it easy to consume compute.

That convenience becomes dangerous when teams stop thinking about cost and performance as first-class design constraints.

## Main Cost Drivers

Typical Databricks cost drivers include:

- cluster size and duration
- interactive clusters left running too long
- oversized SQL warehouses
- repeated poorly designed jobs
- workload duplication across teams

## Main Performance Levers

Common performance levers include:

- correct compute surface selection
- healthy Spark job design
- file and table layout discipline
- reducing unnecessary wide transformations
- separating exploratory and production workloads

Databricks does not remove Spark cost logic.

It packages that logic inside a managed platform where compute choices are easier to make and therefore easier to misuse.

## Real Example

A team may blame Databricks cost growth on the platform itself.

But the real issue may be:

- always-on all-purpose clusters
- notebook-only manual reruns
- gold tables rebuilt too frequently
- analysts using ETL compute for BI-style queries

That is not a Databricks failure.

That is a workload-shape failure.

## Good Strategy

- separate cost attribution by workload type
- pick compute surfaces deliberately
- review job design before scaling cluster size
- treat platform cost control as architecture, not after-the-fact finance cleanup

## Key Architectural Takeaway

Databricks cost is mostly the visible consequence of workload, compute, and operating-model choices rather than a mysterious property of the platform itself.