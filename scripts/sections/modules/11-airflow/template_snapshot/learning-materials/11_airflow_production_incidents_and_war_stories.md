# Airflow Production Incidents and War Stories

## 1. Scheduler lag (the silent killer)

### What happened

Pipelines started running late.

- DAG scheduled at 01:00
- actually started at 01:40+

---

### How it looked in Airflow

- tasks stuck in "scheduled"
- DAG runs delayed
- UI shows no obvious error

---

### Root cause

- too many DAGs
- heavy DAG parsing
- metadata DB latency

---

### Debugging steps

1. Check scheduler logs

    airflow scheduler logs

2. Check DAG parsing time
3. Check DB performance
4. Count number of DAGs and tasks

---

### Fix

- reduce DAG complexity
- remove top-level heavy code
- optimize DB

---

### Prevention

- keep DAGs lightweight
- monitor scheduler lag
- limit dynamic DAG generation

---

### Good strategy

Design DAGs for fast parsing.

### Bad strategy

Heavy imports and API calls in DAG file.

### Why bad is bad

Scheduler becomes bottleneck.

---

## 2. Tasks stuck in queued

### What happened

Tasks never started.

---

### Symptoms

- status = queued
- workers idle or overloaded

---

### Root cause

- no available workers
- queue misconfiguration
- executor issue

---

### Debugging

    airflow celery inspect active

Check:

- worker status
- queue length

---

### Fix

- scale workers
- fix queue config

---

### Prevention

- monitor queue size
- define pools

---

## 3. Worker crash / memory leak

### What happened

Workers restarted randomly.

---

### Symptoms

- tasks fail with no logs
- sudden retries

---

### Root cause

- memory leak
- heavy Python processing

---

### Debugging

- check worker logs
- check memory usage

---

### Fix

- reduce memory usage
- split tasks

---

### Prevention

- avoid heavy compute in Airflow
- monitor memory

---

## 4. XCom explosion (DB killed)

### What happened

System became extremely slow.

---

### Symptoms

- UI slow
- scheduler lag
- DB size huge

---

### Root cause

- large data stored in XCom

---

### Debugging

Check XCom table size.

---

### Fix

- clear XCom
- move data to S3

---

### Prevention

- use XCom only for metadata

---

## 5. Backfill disaster

### What happened

Backfill triggered massive load.

---

### Symptoms

- thousands of tasks started
- DB overload
- API overload

---

### Root cause

- no concurrency control

---

### Debugging

Check:

- max_active_runs
- pools

---

### Fix

- limit concurrency
- pause DAG

---

### Prevention

- always control backfill rate

---

## 6. Duplicate data due to retries

### What happened

Data duplicated.

---

### Symptoms

- doubled rows
- inconsistent reports

---

### Root cause

- non-idempotent tasks

---

### Fix

- implement idempotency

---

### Prevention

- use interval-based logic

---

## 7. API outage → retry storm

### What happened

API failed → retries exploded.

---

### Symptoms

- high retries
- workers overloaded

---

### Root cause

- no retry control

---

### Fix

- reduce retries
- add backoff

---

### Prevention

- limit retry strategy

---

## 8. DAG parse slowdown

### What happened

Scheduler slowed drastically.

---

### Root cause

- heavy top-level code

---

### Bad example

    data = load_big_file()

---

### Fix

Move logic to tasks.

---

## 9. Silent data corruption

### What happened

Pipeline green but data wrong.

---

### Symptoms

- empty tables
- incorrect results

---

### Root cause

- no validation

---

### Fix

- add validation tasks

---

### Prevention

- always validate outputs

---

## 10. Wrong environment config

### What happened

Dev DAG wrote to prod.

---

### Root cause

- shared config

---

### Fix

- isolate environments

---

### Prevention

- strict config separation

---

## 11. Missing validation gate between stages

### What happened

Pipeline technically succeeded, but invalid intermediate output moved into downstream layers.

---

### Symptoms

- pipeline marked green
- downstream data incomplete or malformed
- issue discovered only in dashboards or analytics queries

---

### Root cause

- no explicit validate step between extract, transform, and publish stages

---

### Fix

- add validation tasks before publish
- check row counts, schema expectations, and required partitions

---

### Prevention

- use explicit pipeline shape such as `extract -> validate -> transform -> validate -> publish`

---

## 12. Dependency deadlock

---

## 11. Dependency deadlock

### What happened

Tasks never executed.

---

### Root cause

- circular dependencies

---

### Fix

- fix DAG graph

---

## 13. Dynamic DAG explosion

### What happened

Scheduler overloaded.

---

### Root cause

- thousands of DAGs generated

---

### Fix

- reduce DAG count

---

## Final lessons

- Airflow failures are often systemic  
- most issues are architecture-related  
- monitoring and design prevent incidents  

--------------------------------------------------