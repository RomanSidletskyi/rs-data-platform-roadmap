# Query Performance Metrics Reference

This reference groups the metrics an engineer should inspect during a performance investigation. A metric is evidence, not a diagnosis: interpret it with the query's workload, data shape, warehouse, cache state, and service objective.

## Metric Sources

| Source | Best use | Important limitation |
| --- | --- | --- |
| Snowsight Query History and Query Profile | One query's execution graph, expensive nodes, operator statistics, and query insights | Detailed profile availability is limited by query age and privileges; UI fields vary with the query and operator |
| `SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY` | Historical query inventory and workload correlation | Account Usage has ingestion latency; it is not an immediate runtime console |
| Information Schema `QUERY_HISTORY()` table function | Recent query investigations close to execution time | Its lookback window is shorter than Account Usage |
| `GET_QUERY_OPERATOR_STATS(query_id)` | Programmatic per-operator rows, I/O, pruning, spill, and execution-time breakdown | The query must be completed and recent; warehouse monitoring privileges are required |
| Warehouse load/metering and query-attribution views | Queueing, concurrency, and cost trends | Usage/credit attribution is not the same as a query's elapsed time and has its own latency and granularity |

## Query-Level Metrics

| Metric | What it measures | What may be concerning | Next question |
| --- | --- | --- | --- |
| `TOTAL_ELAPSED_TIME` | End-to-end statement time in milliseconds | It is high, but does not identify whether the query waited, executed, or returned a large result | Decompose compilation, queue, execution, and client/result time |
| `COMPILATION_TIME` | Planning/compilation time | It dominates a short query or grows sharply for a stable workload | Is the SQL/view graph unusually complex, or is the query executed frequently with different shapes? |
| `EXECUTION_TIME` | Time spent executing after compilation | It dominates total elapsed time | Inspect Query Profile and operator-level work |
| `QUEUED_PROVISIONING_TIME` | Time waiting for warehouse provision/resume/resize | It is a material part of latency for an interactive workload | Was the warehouse suspended, resizing, or starting? Would a different resume policy fit the SLA? |
| `QUEUED_OVERLOAD_TIME` | Time queued because current warehouse resources are overloaded | It increases during concurrency peaks | Which workload classes share the warehouse? Would isolation or multi-cluster behavior address concurrency? |
| `QUEUED_REPAIR_TIME` | Time waiting for warehouse repair | Repeated or user-visible repair delay | Is this transient infrastructure behavior or a recurring operational issue? |
| `TRANSACTION_BLOCKED_TIME` | Time blocked by concurrent DML | It is large on a write-sensitive path | Which transaction or write pattern is blocking this statement? |
| `BYTES_SCANNED` | Bytes scanned by the statement | High relative to the required result and workload | Is projection narrow? Is pruning effective? Are external bytes or repeated scans involved? |
| `PARTITIONS_SCANNED` / `PARTITIONS_TOTAL` | Micro-partitions scanned versus total for table scans | A large fraction is scanned when the query should be selective | Is the predicate selective and compatible with the table's data distribution? A full scan can be correct for broad analytics |
| `PERCENTAGE_SCANNED_FROM_CACHE` | Fraction of scanned data read from local warehouse cache; Query History expresses this from 0 to 1 | A benchmark relies on a warm cache but production often starts cold | Compare cold and warm runs; do not treat cache percentage as a query-quality score |
| `BYTES_SPILLED_TO_LOCAL_STORAGE` | Intermediate bytes spilled to local disk | Large spill accompanies an expensive join, sort, aggregate, or window | Can input/intermediate rows be reduced, or is more warehouse memory justified after SQL review? |
| `BYTES_SPILLED_TO_REMOTE_STORAGE` | Intermediate bytes spilled to remote storage | Significant remote spill often accompanies a slow memory-intensive operation | Find the spilling operator and its input cardinality; test query reduction and warehouse sizing |
| `BYTES_SENT_OVER_THE_NETWORK` | Network transfer associated with the statement | Large transfer around joins or data movement | Is the plan redistributing large rowsets, reading cross-region storage, or invoking external services? |
| `BYTES_WRITTEN_TO_RESULT` | Size of the returned result object | A report returns far more rows/columns than its consumer uses | Can the result contract be narrowed or paginated? |
| `QUERY_LOAD_PERCENT` | Approximate share of active warehouse compute resources for the query | High load coincides with queueing or interference | Correlate with warehouse load and other queries; it is not a standalone saturation verdict |
| `ROWS_PRODUCED` | Legacy row-count field in Query History | It appears inconsistent for DML or result semantics | It is documented for deprecation; prefer operation-specific row fields or operator statistics |

`ACCOUNT_USAGE.QUERY_HISTORY` includes queue, scan, spill, and result fields. It is not a direct per-query warehouse-credit ledger. For cost, correlate query tags/attribution with warehouse metering and billing views, and use the same time window and warehouse scope.

## Operator-Level Metrics

`GET_QUERY_OPERATOR_STATS` returns one row per operator for a completed query. The Query Profile exposes similar information visually. Important fields include:

| Operator data | Meaning | Interpretation |
| --- | --- | --- |
| `OPERATOR_TYPE`, `STEP_ID`, `OPERATOR_ID`, `PARENT_OPERATORS` | Operator identity and data-flow relationships | Use these to follow the graph; do not assume operator IDs are global across queries |
| `OPERATOR_STATISTICS:input_rows` / `output_rows` | Rows entering and leaving an operator | A large join output/input ratio may reveal fan-out; an aggregate reducing rows may be expected |
| `OPERATOR_STATISTICS:io:bytes_scanned` | Bytes scanned by a TableScan | Connect scan volume to projected columns and filters |
| `OPERATOR_STATISTICS:pruning:partitions_scanned` / `partitions_total` | TableScan pruning detail | Compare with query selectivity and table contents, not a universal target |
| `OPERATOR_STATISTICS:spilling:bytes_spilled_local_storage` / `bytes_spilled_remote_storage` | Intermediate spill per operator | Attribute spill to the responsible operator before changing compute |
| `OPERATOR_STATISTICS:network:network_bytes` | Network bytes associated with an operator | Helps identify expensive redistribution or movement |
| `EXECUTION_TIME_BREAKDOWN:overall_percentage` | The operator's share of query execution time | Use to locate costly nodes; do not assume all node percentages are additive or independently optimizable |
| `EXECUTION_TIME_BREAKDOWN:processing`, `local_disk_io`, `remote_disk_io`, `network_communication`, `synchronization`, `initialization` | Time categories for an operator | Reveals whether work is CPU processing, I/O, network, coordination, or startup dominated |
| `OPERATOR_ATTRIBUTES` | Operator-specific details such as join type/condition, scan columns, window functions, or sort keys | Use it to connect physical work back to SQL and data semantics |

Some keys can be `NULL` or absent when they do not apply or are zero. Do not equate missing profile detail with zero cost.

## Reading Common Metric Combinations

| Observed combination | Likely direction | What not to conclude immediately |
| --- | --- | --- |
| High elapsed + high overload queue + ordinary execution | Concurrency/capacity isolation | That a bigger warehouse will necessarily lower all workload cost |
| High elapsed + high provisioning queue | Resume/provisioning policy | That SQL rewriting will remove the wait |
| High execution + large scan + broad partitions | Data-read or predicate/layout problem | That clustering is automatically the answer |
| Low partitions scanned but high bytes | Wide projection, large columns, or external reads | That pruning is poor |
| Join output far exceeds intended grain | Duplicate keys, incomplete join condition, or legitimate fan-out | That every many-to-many result is erroneous; validate expected grain |
| Large sort/window input + spill | Large partitions, wide rows, or ordering requirements | That replacing a window with a self-join is safer or faster |
| High remote spill on a join/aggregate | Intermediate work exceeds practical memory/local capacity | That increasing warehouse size is the only fix |
| High external bytes or file-listing time | External stage/table access, file layout, or metadata path | That internal-table metrics explain the external source bottleneck |
| High cache percentage on a fast run | The run read substantial local cached data | That cold starts or first-run users get the same latency |
| Large `BYTES_WRITTEN_TO_RESULT` | Result transfer/consumer shape may dominate end-to-end time | That table scanning is the only bottleneck |

## Five Core Performance Failure Signatures

### 1. Spilling: Local And Remote Storage

Spill occurs when an operator's intermediate state does not fit in the memory/local resources available for that execution. Snowflake can spill to local storage and then remote storage. It is a useful warning signal, but spill volume alone does not identify whether the root cause is row explosion, a wide sort, a large aggregate, skew, or warehouse capacity.

**Metrics:** Query History `BYTES_SPILLED_TO_LOCAL_STORAGE` / `BYTES_SPILLED_TO_REMOTE_STORAGE`; in Query Profile or `GET_QUERY_OPERATOR_STATS`, inspect the spilling operator and its input/output rows.

**Interpretation:** local spill means an operation used local disk for intermediate data; remote spill means data had to use remote storage and can add substantial I/O/network latency. Neither metric alone proves that the warehouse is undersized.

**Response order:** identify the spilling operator; check its row counts, join cardinality, sort keys, window partition size, and skew; reduce rows/columns or pre-aggregate when semantics allow; then test a larger warehouse if the remaining operation is memory/compute constrained. Compare latency and credits, and preserve result correctness. Avoid the blanket response “remote spill means immediately resize to L/XL.”

### 2. Weak Pruning Or A Broad Scan

**Metrics:** For each TableScan, inspect `PARTITIONS_SCANNED`, `PARTITIONS_TOTAL`, `BYTES_SCANNED`, selected columns, filters/access predicates, and any extracted VARIANT paths.

**Interpretation:** partitions scanned near total can indicate weak pruning when the workload should be selective. It is not automatically a failure: full-table analytics may need most of the data, and external/Iceberg scans have different metadata and file-layout considerations. Evaluate scanned data against expected selectivity and the report's purpose, not a universal “a few percent” threshold.

**Response order:** verify that the filter is logically selective; inspect its type and expression; check data distribution, micro-partition overlap, and whether a VARIANT path is extracted; compare native/external/Iceberg scan behavior; only then consider clustering or Search Optimization for a supported query shape. Re-run the same query and compare scan bytes, partitions, output rows, and cost.

### 3. Join Explosion Or Unexpected Fan-Out

**Metric:** Compare `input_rows` and `output_rows` for each Join operator and inspect join conditions and downstream Aggregate/Sort/Spill nodes.

**Interpretation:** for example, a join that takes 100,000 rows and emits 50,000,000 deserves an explanation. It may be a missing/incomplete condition, duplicate keys, a many-to-many relation, or an intentional expansion. Establish the expected grain before calling it a bug.

**Response order:** check key uniqueness and null behavior on both sides; calculate multiplicity by key; verify the join condition against the data contract; pre-aggregate or deduplicate only when that preserves semantics; then compare output rows and business totals. Never “optimize” away valid many-to-many output.

### 4. Queuing: Provisioning, Repair, Or Overload

**Metrics:** `QUEUED_PROVISIONING_TIME`, `QUEUED_REPAIR_TIME`, and `QUEUED_OVERLOAD_TIME` in Query History, correlated with warehouse load and other query classes.

**Interpretation:** provisioning is startup/resume/resize wait; repair is resource-repair wait; overload is contention for current warehouse capacity. A query can have a good execution plan and still miss its SLA because it waited.

**Response order:** confirm which queue component is material; compare workload arrival patterns and warehouse load; consider auto-resume/suspend, workload isolation, scheduling, or multi-cluster behavior for concurrency. Multi-cluster is a concurrency tool; it does not necessarily accelerate one query's execution. Upsizing a warehouse targets execution capacity and should not be assumed to fix every queue.

### 5. Disk I/O And Network Communication

**Metrics:** Query Profile/`EXECUTION_TIME_BREAKDOWN` categories such as `local_disk_io`, `remote_disk_io`, and `network_communication`; operator `bytes_scanned`, local/remote spill, network bytes, and external bytes where present.

**Interpretation:** high remote I/O can mean large remote scans or remote spill; high network communication can indicate redistribution for joins/aggregations, large intermediate rowsets, or external/cross-region work. The category alone does not identify the source.

**Response order:** tie the time category to the operator; distinguish remote table scan from remote spill; inspect join input/output rows, file layout, and region boundaries; reduce data movement or improve the table/access pattern when supported by evidence. If local cache is involved, record its state and do not treat a warm run as a cold baseline.

## Query History Example

Use a narrow time range and a query tag or warehouse filter when possible. Account Usage views can lag; use the Information Schema function or Snowsight when investigating a recent run.

```sql
SELECT
  query_id,
  query_tag,
  warehouse_name,
  warehouse_size,
  execution_status,
  total_elapsed_time,
  compilation_time,
  execution_time,
  queued_provisioning_time,
  queued_overload_time,
  queued_repair_time,
  transaction_blocked_time,
  bytes_scanned,
  partitions_scanned,
  partitions_total,
  percentage_scanned_from_cache,
  bytes_spilled_to_local_storage,
  bytes_spilled_to_remote_storage,
  bytes_sent_over_the_network,
  bytes_written_to_result
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE start_time >= DATEADD('hour', -24, CURRENT_TIMESTAMP())
  AND query_type = 'SELECT'
ORDER BY total_elapsed_time DESC
LIMIT 50;
```

Validate columns and role access for the selected history source. Never compare a filtered Account Usage sample with a full Snowsight workload without noting the different windows and visibility.

## Operator Statistics Example

Capture the query ID immediately after the statement, then inspect operators:

```sql
SET investigated_query_id = LAST_QUERY_ID();

SELECT
  step_id,
  operator_id,
  parent_operators,
  operator_type,
  operator_statistics:input_rows::NUMBER AS input_rows,
  operator_statistics:output_rows::NUMBER AS output_rows,
  operator_statistics:io:bytes_scanned::NUMBER AS bytes_scanned,
  operator_statistics:pruning:partitions_scanned::NUMBER AS partitions_scanned,
  operator_statistics:pruning:partitions_total::NUMBER AS partitions_total,
  operator_statistics:spilling:bytes_spilled_remote_storage::NUMBER AS remote_spill_bytes,
  execution_time_breakdown:overall_percentage::FLOAT AS execution_time_percentage,
  operator_attributes
FROM TABLE(GET_QUERY_OPERATOR_STATS($investigated_query_id))
ORDER BY step_id, operator_id;
```

This function is for completed, recent queries and requires sufficient monitoring privileges on the warehouse. It returns runtime statistics for an execution, not a stable plan guarantee for future executions.

## Metric Reading Checklist

- Is latency dominated by queueing, compilation, execution, or result delivery?
- Which TableScan and processing operators account for the work?
- Does observed row volume match the intended grain at every stage?
- Are scan, partitions, spill, network, or external reads high for this workload?
- Are cache conditions comparable between baseline and candidate runs?
- Do the metrics represent performance, cost, correctness, or only one of these?
- What is the next test that can disprove the current hypothesis?

## Official References

- [Snowflake Query Profile and Query History](https://docs.snowflake.com/en/user-guide/ui-query-profile)
- [`GET_QUERY_OPERATOR_STATS`](https://docs.snowflake.com/en/sql-reference/functions/get_query_operator_stats)
- [`QUERY_HISTORY` Account Usage view](https://docs.snowflake.com/en/sql-reference/account-usage/query_history)
