# Snowflake Performance — Complete Guide (Senior Cheat Sheet)

## 1. Storage Basics

- Snowflake stores data in **columnar format**
- Data is split into **micro-partitions (~50–500MB uncompressed)**
- Each micro-partition contains metadata:
  - min/max per column
  - null count
  - stats

### Key Insight
Snowflake is **metadata-driven**, not index-driven.

---

## 2. Micro-partitions

- Created automatically on ingestion
- Based on **insertion order**
- Immutable (copy-on-write on changes)

### Good ingestion
ordered by date → good pruning

### Bad ingestion
random order → high overlap → poor pruning

---

## 3. Query Pruning

Snowflake skips irrelevant micro-partitions using metadata.

### Works well when:
- selective filters
- low overlap
- proper clustering

### Fails when:
- functions in WHERE
- casting columns
- high overlap
- poor ingestion order

### Example anti-pattern
WHERE DATE(event_ts) = '2026-01-01'

### Better
WHERE event_ts BETWEEN ...

---

## 4. Clustering

Clustering = **reorganizing data physically**

### What it does
- rewrites micro-partitions
- reduces overlap
- improves pruning

### Metrics
- average_overlaps
- average_depth

### Check clustering
SELECT SYSTEM$CLUSTERING_INFORMATION('table_name');

### When to use
- very large tables (TB+)
- range filters (date, timestamp)

### Cost trade-off
clustering costs compute → use only if query savings > clustering cost

### Important
clustering ≠ index

---

## 5. Search Optimization Service (SOS)

SOS = **lookup structure (value → partitions)**

### Use case
WHERE user_id = 123

### Works best for
- high-cardinality columns
- point lookups

### Not good for
- range queries

### Key difference
- Clustering → data layout
- SOS → metadata lookup

---

## 6. Materialized Views

- Precomputed query results
- Stored separately

### Use when
- heavy joins
- aggregations
- dashboards

### Trade-off
- storage + maintenance cost

---

## 7. Result Caching

Snowflake caches query results.

### Works when
- same query text
- same data
- no changes

### Benefits
- near-zero cost
- instant response

---

## 8. Join Strategies

### Broadcast Join
- small table copied to all nodes
- fast, no shuffle

### Repartition Join (Shuffle)
- both tables redistributed by key
- expensive

### Decision
small table → broadcast  
large tables → repartition

---

## 9. Data Skew

### What
uneven distribution of data across nodes

### Example
one user_id = 50% of data

### Result
- one node overloaded
- slow query

### Fix
- salting
- filtering hot keys

---

## 10. Spill

### Types
- local spill (disk)
- remote spill (very slow)

### Cause
- memory overflow
- skew
- large joins

### Fix
- reduce data
- pre-aggregate
- fix skew

---

## 11. Query Profile (Senior Approach)

### Order of analysis
1. where is time spent
2. partitions scanned
3. bytes scanned
4. skew
5. spill
6. join type

### Red flags
- 80–100% partitions scanned → bad pruning
- uneven execution → skew
- spill → memory issue

---

## 12. Query Plan Analysis

### Focus on
- largest operator
- join type
- scan volume
- distribution

### Questions to ask
- is pruning working?
- is join optimal?
- is data evenly distributed?

---

## 13. System Tables (Monitoring)

### Query history
SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY

### Query profile stats
GET_QUERY_OPERATOR_STATS

### Pruning
SNOWFLAKE.ACCOUNT_USAGE.TABLE_QUERY_PRUNING_HISTORY

### Clustering
SYSTEM$CLUSTERING_INFORMATION

### Copy / ingestion
COPY_HISTORY

### Snowpipe
PIPE_USAGE_HISTORY

---

## 14. Ingestion Impact

### Key rule
ingestion defines micro-partitions

### Problems
- random inserts
- late data
- merge operations

### Small files problem
- too many small files → bad partitions

### Best practice
- 100–250MB files
- ordered data

---

## 15. Micro-batching vs Streaming

### Micro-batching
- cheaper
- better partitions
- easier recovery

### Over-streaming
- expensive
- bad clustering
- hard recovery

### Insight
streaming optimizes latency  
micro-batching optimizes cost

---

## 16. No Indexes in Snowflake

### Why
- micro-partitions + metadata

### Replacements
- pruning
- clustering
- SOS

### Weakness
- point lookups without SOS

---

## 17. Performance Debug Checklist

When query is slow:

1. check pruning
2. check scan size
3. check join type
4. check skew
5. check spill
6. check ingestion pattern
7. only then scale warehouse

---

## 18. Senior Insights

- optimize data layout before scaling compute
- ingestion design = performance foundation
- not all queries need clustering
- streaming is not always better
- always validate with Query Profile

---

## 19. Anti-patterns

- SELECT *
- functions in WHERE
- over-clustering
- ignoring skew
- over-streaming
- scaling instead of optimizing

---

## 20. One-line Summary

Snowflake performance = pruning + data layout + join strategy + distribution