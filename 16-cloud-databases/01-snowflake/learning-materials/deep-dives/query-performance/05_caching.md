# Snowflake Caching: Result Reuse, Warehouse Cache, and Metadata

Snowflake has several mechanisms that are casually called “the cache.” They cache different things, have different lifetimes, and answer different questions. Cache behavior should be controlled in a benchmark and interpreted as context in production; it is not a substitute for understanding the underlying query work.

## The Three Mechanisms

| Mechanism | What is reused | Typical effect | Key boundary |
| --- | --- | --- | --- |
| Persisted query result reuse | A prior eligible query result | Can return a result without re-running the query on a virtual warehouse | Eligibility depends on query determinism, underlying data/object changes, access, session context, and settings |
| Warehouse local data cache | Data read from remote storage and retained on active warehouse compute | Repeated scans can avoid some remote reads | Belongs to the running warehouse cluster; suspending a warehouse clears local cache, and reuse is not guaranteed |
| Metadata/pruning | Table and micro-partition metadata used during planning/scanning | Avoids reading irrelevant data or computing some metadata-only answers | This is not cached query output or a warehouse-local copy of table data |

Do not call all three “the result cache.” In particular, warehouse local data cache can affect a query that still executes, while persisted result reuse can avoid the normal table-scan/operator work entirely.

## 1. Persisted Query Result Reuse

For an eligible query, Snowflake can reuse a previously computed result instead of executing the SQL again. This is most visible with repeated deterministic queries over unchanged data. Reuse eligibility is conditional; changes in source objects, nondeterministic functions, access/role behavior, or relevant session/query settings can prevent reuse. Use current Snowflake documentation for the complete eligibility rules.

`USE_CACHED_RESULT = FALSE` disables persisted query-result reuse for the session/query context:

```sql
ALTER SESSION SET USE_CACHED_RESULT = FALSE;

SELECT order_date, SUM(net_amount)
FROM analytics.orders
GROUP BY order_date;
```

This is useful for a benchmark when you specifically want to compare query execution rather than a reused result. It does **not** disable the warehouse local data cache, guarantee a cold scan, or erase other cached state.

### When result reuse is useful

- Repeated dashboard or application requests with stable underlying data.
- Repeated deterministic queries where the cached result is an acceptable freshness contract.
- Avoiding repeated warehouse execution for eligible requests.

### What it can hide

A query that returns instantly from persisted result reuse has not demonstrated the execution speed of its joins, scan, windows, or aggregation. A cache-hit benchmark cannot prove that the underlying query plan is efficient.

## 2. Warehouse Local Data Cache

A running virtual warehouse can cache data read from Snowflake storage on local disk. A later query using the same active warehouse may read that data from local cache and reduce remote-storage reads. This is distinct from reusing a complete query result: the query still executes and may still pay for CPU, joins, sorting, aggregation, and result transfer.

The local cache is associated with warehouse compute. Suspending a warehouse clears the local cache; after resume, a query may need to read table data from remote storage again. Multi-cluster warehouses have separate compute clusters, so do not assume a query will use the same local cache on every run.

### Cache policy is a latency/cost trade-off

A longer auto-suspend interval can preserve local cache for likely repeat workloads, but it can also keep compute running while idle. A short interval can save idle warehouse spend while increasing resume latency and reducing warm local-cache reuse. Make this decision from arrival patterns and measured cost, not from a blanket “never suspend” rule.

Do not keep a large warehouse running solely for cache warmth unless you have measured the end-to-end benefit against idle compute usage and service requirements.

## 3. Metadata, Pruning, and Metadata-Only Results

Snowflake maintains micro-partition metadata that helps prune data during scans. Metadata can also allow some queries to be answered without reading all table data. These are storage/planning optimizations, not the same as a prior query's persisted result or a warehouse's local copy of scanned data.

A query that scans few partitions can still process many rows within them; a query that scans many partitions can be correct if it needs most of the table. Read `PARTITIONS_SCANNED`, `PARTITIONS_TOTAL`, bytes scanned, and selected columns together with the predicate and expected selectivity.

## 4. How To Read Cache Metrics

`PERCENTAGE_SCANNED_FROM_CACHE` (shown in Query History/Query Profile where available) describes the fraction of scanned data read from local disk cache. It does not mean:

- the full query result came from persisted result reuse;
- the query is efficient or inefficient by itself;
- all reads came from cache;
- a result is fresh according to the business SLA.

If a persisted result is reused, the usual table-scan/operator profile may not represent the work a cold execution would do. Record whether the result was reused and whether local scan data was warm.

## 5. Benchmark Matrix

| Test | Result reuse | Warehouse local cache | What it answers |
| --- | --- | --- | --- |
| Eligible repeated query under normal settings | May be reused | May be warm | User-visible repeated-request behavior |
| Same query with `USE_CACHED_RESULT = FALSE` on active warehouse | Disabled for persisted result | May be warm | Query execution with likely local-cache benefit |
| First run after warehouse resume | Depends on result-reuse setting/eligibility | Usually cold after suspension | Startup and remote-read behavior |
| Repeated run on same active warehouse | Depends on result-reuse setting/eligibility | May be warm | Warm execution behavior |

A valid performance report should state which row it measures, the query ID, warehouse size, concurrency, data state, and result-reuse setting. Do not mix result-cache hits with execution-time comparisons.

## 6. Example: Separate The Two Cache Effects

1. Run a representative query and record its query ID and profile.
2. Repeat it with default settings. Determine whether the result was reused from Query History/Query Profile and current Snowflake indicators.
3. Set `USE_CACHED_RESULT = FALSE` and rerun. This avoids persisted result reuse but may still benefit from local warehouse cache.
4. If cold local-cache behavior is important, test after a controlled warehouse suspend/resume, understanding that the resume itself changes latency and incurs compute.
5. Compare correctness, execution time, scan bytes, partitions, cache percentage, spill, and warehouse usage.

Use a disposable benchmark warehouse and realistic data. Avoid repeatedly suspending a shared production warehouse to manufacture a benchmark condition.

## 7. External Tables And Cache Freshness

External-table file metadata refresh and query-result reuse are separate. If new files have not been registered in external-table metadata, a query can be stale even before result-cache behavior is considered. Conversely, changes not reflected in the registered file set may not invalidate a persisted query result. Diagnose stage/file visibility, refresh registration, and result reuse as separate steps.

## Troubleshooting Checklist

- Was the statement executed, or was a persisted result reused?
- If it executed, what fraction of scanned data came from warehouse local cache?
- Was the warehouse active throughout the comparison, or suspended/resumed?
- Did underlying data or session context change between runs?
- Does the cache condition match real user traffic and freshness requirements?
- Are result-cache latency and cold-execution latency reported separately?

## Official References

- [Persisted query results](https://docs.snowflake.com/en/user-guide/querying-persisted-results)
- [Warehouse considerations](https://docs.snowflake.com/en/user-guide/warehouses-considerations)
- [Query Profile and Query History](https://docs.snowflake.com/en/user-guide/ui-query-profile)
