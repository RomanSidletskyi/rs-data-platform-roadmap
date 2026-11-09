# Snowflake Performance Casebook

The cases below are synthetic but production-shaped: they represent recurring engineering failure modes, not claims about specific customer incidents. Each case follows the same diagnostic discipline: symptom, evidence, root cause, safer pattern, and trade-off. SQL is illustrative and assumes the stated data contract.

## Case 1: Function-Wrapped Timestamp Filter

**Scenario:** An hourly dashboard reads a year of order history but needs one day. Query Profile shows a large TableScan and many partitions scanned.

**Poor query:**

```sql
SELECT order_id, customer_id, amount
FROM analytics.orders
WHERE DATE_TRUNC('DAY', order_ts) = '2026-01-15'::TIMESTAMP_NTZ;
```

**Why it can hurt:** The expression applies a function to the filter column. The optimizer may simplify some expressions, so this is not proof of failed pruning; the profile must decide.

**Candidate rewrite:**

```sql
SELECT order_id, customer_id, amount
FROM analytics.orders
WHERE order_ts >= '2026-01-15 00:00:00'::TIMESTAMP_NTZ
  AND order_ts <  '2026-01-16 00:00:00'::TIMESTAMP_NTZ;
```

**Verify:** Same result rows around midnight and timezone boundaries; compare partitions and bytes scanned on representative runs.

**Trade-off:** Range predicates are explicit and can help pruning, but a full-range report still needs broad reads.

## Case 2: Repeated Filters On A Nested `VARIANT` Field

**Scenario:** Every BI query filters events by `payload:event_ts` and joins on `payload:customer_id`; mixed types and JSON nulls appear in source records.

**Poor pattern:** Extract the same paths and cast them independently in every downstream query.

**Candidate fix:** Preserve the raw payload for replay, then project validated `event_ts TIMESTAMP_TZ` and `customer_id STRING` into a curated staging contract. Add quality counters for missing, JSON-null, invalid-type, and valid values.

**Verify:** Query Profile TableScan paths/bytes/partitions, Query History, and output correctness. Compare representative data, not a few clean rows.

**Trade-off:** Typed projection adds transformation/storage work and schema ownership, but centralizes type semantics and can improve repeated filters/joins. VARIANT metadata extraction is selective; do not assume all paths are unoptimized or fully extracted.

## Case 3: Wide `SELECT *` In A Reused Model

**Scenario:** A downstream view selects every column from a wide event table; dashboards need five fields but read the full payload and several rarely used attributes.

**Poor pattern:**

```sql
SELECT *
FROM curated.events
WHERE event_date >= DATEADD('DAY', -7, CURRENT_DATE());
```

**Candidate fix:** Define the reporting contract with only the required fields, including explicitly typed attributes.

**Verify:** Compare columns scanned, bytes scanned, result bytes, and dependent consumers.

**Trade-off:** A narrower contract reduces accidental schema exposure and downstream transfer, but too many narrowly duplicated views can complicate ownership. `SELECT *` remains useful for exploration, not a stable serving contract.

## Case 4: Join Fan-Out Inflates Revenue

**Scenario:** A report joins order headers to items and then sums header-level `order_total`. Several items per order inflate revenue.

**Poor query:**

```sql
SELECT SUM(o.order_total) AS revenue
FROM orders AS o
JOIN order_items AS i
  ON i.order_id = o.order_id;
```

**Root cause:** The query changes grain from one row per order to one row per item before summing an order-grain measure.

**Candidate fix:** Aggregate item measures at order grain first, or aggregate order totals before joining to a one-row-per-order relation. Select the measure whose definition matches the intended grain.

**Verify:** Compare distinct order count, row counts before/after each join, and control totals against a trusted source.

**Trade-off:** Pre-aggregation may reduce join volume but must preserve refunds, duplicate source records, and late corrections.

## Case 5: Join Output Explodes

**Scenario:** Joining two customer feeds on email produces 50 million rows from 100 thousand input rows because both sides contain duplicates and null/normalized values.

**Poor pattern:** Add more warehouse compute before checking keys.

**Candidate fix:** Profile key multiplicity on each side, normalize according to a documented contract, choose a deterministic deduplication rule, and join at the intended grain. Preserve ambiguous matches in a quality/quarantine path rather than silently selecting one.

**Verify:** Compare join input/output rows per operator, duplicate-key distributions, unmatched rows, and resulting business totals.

**Trade-off:** Deduplication adds processing and requires a survivorship rule; leaving ambiguous records can be more correct than forcing one match.

## Case 6: An `OR` Join Predicate Has A Costly Plan

**Scenario:** A customer can match either of two legacy identifiers. The join predicate uses `a.legacy_id = b.legacy_id OR a.alt_id = b.alt_id`; Query Profile shows a large join/filter stage.

**Poor assumption:** “Every OR join is a Cartesian product.” The plan and data determine the actual behavior; the warning is a hypothesis, not a universal implementation guarantee.

**Candidate fixes:** Prefer a normalized identifier mapping relation with one row per identifier/type, or split into separate branches only if the duplicate semantics are defined. If both keys can match the same entity, explicitly decide whether to deduplicate and how.

**Verify:** Compare operator input/output rows, matched/unmatched counts, and duplicate matches. Run a result-set equivalence check against the original.

**Trade-off:** A mapping table adds a maintained data product but often makes match precedence and uniqueness explicit. A two-branch rewrite may improve a measured plan but can change multiplicity.

## Case 7: Repeated CTE Reference

**Scenario:** A costly filtered event CTE is referenced by three branches. Profile shows repeated scans or a `WithClause`/repeated work; query behavior varies with data volume.

**Poor rule:** “CTEs are always recomputed” or “CTEs are always materialized.” Neither is a safe blanket claim.

**Candidate experiment:** Compare the CTE form with an explicitly materialized temporary/staging result only after the profile shows repeated expensive work. Include the write/read and lifecycle cost of the temporary relation.

**Verify:** Scan count/bytes, execution operators, freshness, concurrency, and cost for both forms.

**Trade-off:** A temp/staging table can avoid repeated computation but consumes storage/compute and introduces cleanup/ownership requirements. Keep the readable CTE if the optimizer already produces an efficient plan.

## Case 8: Self-Join For Previous-Row Logic

**Scenario:** A session report joins each event to all earlier events for the same customer to find the previous timestamp. Join output grows sharply.

**Poor pattern:** A many-to-many self-join followed by aggregation when the requirement is simply the previous row in a deterministic order.

**Candidate rewrite:**

```sql
SELECT
  customer_id,
  event_ts,
  event_id,
  LAG(event_ts) OVER (
    PARTITION BY customer_id
    ORDER BY event_ts, event_id
  ) AS prior_event_ts
FROM events;
```

**Verify:** Tie-breaking, null behavior, late events, and row grain. Inspect WindowFunction/Sort rows and spill against the original join.

**Trade-off:** Window functions often express this pattern more directly, but a very large/skewed partition still needs sorting and can be costly. The right method depends on the required result and distribution.

## Case 9: Unneeded Sort And Duplicate Elimination

**Scenario:** A pipeline sorts a subquery, unions two disjoint sources with `UNION`, then sorts the final result again.

**Poor pattern:**

```sql
SELECT * FROM (
  SELECT * FROM source_a ORDER BY event_ts
  UNION
  SELECT * FROM source_b ORDER BY event_ts
);
```

**Candidate fix:** Remove ordering that is not consumed by a top-N/window/final result requirement. Use `UNION ALL` only if duplicates are allowed or uniqueness is established independently.

**Verify:** Sort/Aggregate operators, output rows, and duplicate semantics.

**Trade-off:** `UNION` may be required to deduplicate; changing it to `UNION ALL` for speed without proving uniqueness changes results.

## Case 10: Repeated `FLATTEN` In Dashboard Queries

**Scenario:** Several dashboards independently flatten a nested `items` array; nested discounts multiply rows, and downstream joins spill.

**Poor pattern:** Flatten the full payload before reducing events and repeat the same expansion in every dashboard.

**Candidate fix:** Filter relevant source records, flatten only the needed path/levels, establish the output grain, and consider a shared typed staging model if repeated use justifies its refresh/storage cost.

**Verify:** Input rows versus rows after each Flatten, join fan-out, spill, result grain, and duplicated parent-level measures.

**Trade-off:** Materialization improves reuse but creates freshness, storage, schema-evolution, and ownership obligations. SQL clause order does not force execution order; inspect the plan.

## Case 11: External Table Used As Permanent BI Serving

**Scenario:** A dashboard repeatedly scans a growing set of small Parquet files through an external table. New-file auto-refresh is enabled, but the dashboard has strict completeness and latency needs.

**Candidate path:** Keep the external table as file discovery/validation if useful; load validated data into a native table for Snowflake-centered joins and serving. If another engine needs the same governed table state, evaluate Iceberg rather than treating an external table as an Iceberg substitute.

**Verify:** external bytes/listing and refresh history, file counts and row groups, persisted-result behavior, TableScan cost, and the dashboard's freshness contract.

**Trade-off:** Native ingestion adds copy/transform and replay responsibilities; external tables keep file access simple but leave file layout and metadata refresh on the critical path. A materialized view over an external table has its own edition and maintenance requirements.

## Case 12: Cluster Key Chosen By Table Size Alone

**Scenario:** A growing fact table reaches several terabytes, so a cluster key is added without identifying repeated filters. Automatic clustering usage rises but dashboard latency barely changes.

**Root cause to test:** The key may not match the dominant predicate, natural load order may already be sufficient, query scans may be caused by broad filters, or the workload may be compute/join-bound instead.

**Candidate fix:** Baseline representative query groups, inspect pruning and clustering overlap, then test a candidate key or remove it if no measured improvement. Compare query savings with automatic-clustering usage over a representative period.

**Trade-off:** Clustering changes layout and can improve repeated pruning, but adds maintenance cost. Table size alone is not a decision criterion.

## Case 13: Search Optimization Added To A Range Scan

**Scenario:** A large dashboard filters a month of orders by date; Search Optimization is enabled on a high-cardinality customer key, but it does not materially improve the query.

**Root cause to test:** The workload is a broad range scan rather than a selective lookup that matches the feature's supported access pattern.

**Candidate fix:** Inspect predicates and scan profile; evaluate natural pruning/clustering for date-range workloads. Reserve Search Optimization for measured, supported selective lookups and compare its service/storage cost.

**Trade-off:** The feature can accelerate eligible lookups but adds maintenance and storage. High cardinality alone does not establish suitability.

## Case 14: Warm Cache Hides Cold-Run Latency

**Scenario:** An engineer reports a 2-second query based on the second run. Users opening a dashboard after an overnight suspend observe much slower first-run behavior.

**Root cause:** The benchmark mixed persisted result reuse or warm warehouse local data cache with cold-start behavior.

**Candidate fix:** Report result-cache and local-cache conditions separately. Use `USE_CACHED_RESULT = FALSE` when testing actual query execution, and separately benchmark a controlled first run after warehouse resume. Include resume latency and compute usage.

**Trade-off:** Keeping a warehouse active may preserve local cache for recurring traffic but incurs idle cost; a suspended warehouse saves idle usage but may have resume/cold-read latency. Select policy from measured workload and SLA.

## Case 15: Bigger Warehouse Chosen For A Queue

**Scenario:** Users complain about “slow queries.” Query History shows high overload queueing but normal execution time when the query runs.

**Poor response:** Upsize the same warehouse and assume both latency and concurrency improve.

**Candidate fix:** Classify workload classes, schedule batch work away from peak, consider workload-specific warehouses or eligible multi-cluster scaling for concurrency, and instrument query tags/warehouse load.

**Verify:** Queue time and execution time separately before and after, plus total warehouse usage and impact on other workloads.

**Trade-off:** Multi-cluster or additional warehouses can reduce queueing but increase active compute and operational complexity. They do not make a single inefficient query's plan better.

## Case 16: Low-Lag Dynamic Tables Create Continuous Refresh Spend

**Scenario:** Every layer in an analytics DAG uses a five-minute target lag, including a large monthly rollup consumed once per day. Refresh usage rises with little user-visible benefit.

**Candidate fix:** Set freshness targets by consumer/SLA, inspect actual lag and refresh history, and compare dynamic tables with scheduled tasks/dbt or periodic aggregate rebuilds for heavy layers.

**Verify:** User-facing freshness, refresh duration/failures, dependency lag, warehouse/serverless usage, and result correctness.

**Trade-off:** A lower target lag may improve freshness but increase refresh activity, concurrency, and spend. Target lag is not a business SLA guarantee; define monitoring and fallback behavior.

## Casebook Use

These cases are study prompts, not universal fixes. For every proposed change, state the expected metric movement, a correctness check, the cost measure, and the condition under which you would reject or roll back the change.
