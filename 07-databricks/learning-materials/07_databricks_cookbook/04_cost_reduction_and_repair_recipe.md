# Cost Reduction And Repair Recipe

## Goal

Reduce Databricks cost and repair unstable workloads without assuming bigger clusters or more spend are the only options.

## Recipe

1. Identify the true workload type and current compute surface.
2. Check whether interactive and production workloads are mixed.
3. Review job frequency, rebuild scope, and warehouse sizing.
4. Fix workload shape or job design before scaling compute.
5. Document a safe repair path for reruns and backfills.

## Rule

Treat Databricks cost as a platform-design signal, not as a finance-only afterthought.