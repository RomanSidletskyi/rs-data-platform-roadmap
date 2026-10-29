# Query Performance and Diagnostics

## Diagnose Before Tuning

Start with a representative query ID and its execution context. Separate:

- compilation and planning
- queue time waiting for compute
- execution time
- data scanned and partitions pruned
- join and aggregation work
- local or remote spill
- result delivery and client behavior

Query Profile and query history help identify operators and bottlenecks. A query being slow does not automatically mean the warehouse is too small.

## A Practical Diagnostic Sequence

1. Reproduce the query with the same role, warehouse, parameters, and data scale.
2. Check whether it queued; if so, investigate concurrency and warehouse availability.
3. Check partitions scanned, bytes scanned, and filters to understand pruning.
4. Inspect joins for cardinality explosion, skew, unnecessary columns, and duplicate rows.
5. Inspect spill, sorting, aggregation, and repeated scans.
6. Change one thing, record the before/after, and verify result correctness.
7. Measure the effect on cost and other workloads, not only elapsed time.

## Common Interventions

- Filter early when it preserves intended semantics.
- Project only required columns, especially from wide or semi-structured sources.
- Fix join keys, grain, and cardinality before increasing compute.
- Consider warehouse size when execution is compute constrained.
- Consider multi-cluster or workload isolation when concurrency queues are the issue.
- Consider clustering or search optimization only when profile evidence supports the expected benefit and ongoing cost.
- Avoid relying on warm-cache timings as the only benchmark.

## Trade-Offs

| Intervention | Can help | Does not solve |
| --- | --- | --- |
| Larger warehouse | Compute-bound execution and some memory pressure | Bad SQL, wrong grain, or queueing from independent workloads |
| Separate warehouse | Workload contention and ownership isolation | Inefficient individual queries or unbounded spend |
| Multi-cluster | Concurrency for supported workloads | One inefficient query's execution plan |
| Clustering | Repeated filters with poor pruning on suitable large tables | All table scan or join problems; maintenance has cost |
| Search Optimization | Supported selective lookup patterns | Broad scans or unsupported query shapes |

## Benchmark Discipline

Use representative data and repeat runs. Compare correctness, elapsed time, scanned data, warehouse usage, queueing, and relevant cache state. Document concurrent workloads and whether the test is cold or warm. An optimization is not successful if it makes one dashboard faster but creates unpredictable cost or starves another workload.

## Review Checklist

- Is the bottleneck identified from evidence?
- Did the change preserve row grain and results?
- Is the improvement stable across realistic data and concurrency?
- What new compute, storage, or maintenance cost is introduced?
- Is there a rollback or re-evaluation trigger?