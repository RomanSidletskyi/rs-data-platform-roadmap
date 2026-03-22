# Scheduling and Retries (Production-Level Deep Dive)

## 1. What Scheduling Really Means

Scheduling in Airflow is NOT:

- “run this at 12:00”

It is:

- defining data intervals
- creating DAG runs based on those intervals
- processing data for a specific time window

--------------------------------------------------

## 2. Logical Time vs Execution Time

Airflow works with:

- logical time (data interval)
- not wall-clock time

--------------------------------------------------

Example:

Daily DAG:

- schedule: @daily
- run created: 2024-01-02
- processes: 2024-01-01

--------------------------------------------------

### Good

    start = context["data_interval_start"]
    end = context["data_interval_end"]

--------------------------------------------------

### Bad

    now = datetime.now()

--------------------------------------------------

### Why bad

- backfills break
- reruns inconsistent

--------------------------------------------------

## 3. Schedule Types

--------------------------------------------------

### Cron

    schedule="0 2 * * *"

--------------------------------------------------

### Presets

    @daily
    @hourly
    @weekly

--------------------------------------------------

### Dataset-based (modern)

Triggered by data availability

--------------------------------------------------

## 4. Catchup

Catchup defines:

- whether historical DAG runs are created

--------------------------------------------------

    catchup=True

- creates runs for past intervals

--------------------------------------------------

    catchup=False

- only current runs

--------------------------------------------------

### Good

Use catchup for:
- batch pipelines
- historical data

--------------------------------------------------

### Bad

Disable without understanding

--------------------------------------------------

### Why bad

- missing data
- incomplete history

--------------------------------------------------

## 5. Backfill

Backfill = manual reprocessing

--------------------------------------------------

    airflow dags backfill DAG_ID

--------------------------------------------------

Good:
- fix historical data

Bad:
- unsafe tasks

Why bad:
- duplicates

--------------------------------------------------

## 6. Task Retries

Airflow retries tasks automatically

    retries=3
    retry_delay=timedelta(minutes=5)

--------------------------------------------------

## 7. Retry Philosophy

Retries are NORMAL behavior.

Not exception.

--------------------------------------------------

### Good

- idempotent tasks
- safe re-execution

--------------------------------------------------

### Bad

- side effects

--------------------------------------------------

### Why bad

- duplicates
- corrupted state

--------------------------------------------------

## 8. Retry vs Failure

--------------------------------------------------

Retry when:
- API failure
- temporary DB issue

--------------------------------------------------

Fail when:
- bad data
- logic error

--------------------------------------------------

## 9. Retry Patterns

--------------------------------------------------

### Exponential Backoff

    retry_exponential_backoff=True

--------------------------------------------------

### Max Retry Delay

    max_retry_delay=timedelta(minutes=30)

--------------------------------------------------

### Good

- gradual retry

--------------------------------------------------

### Bad

- aggressive retries

--------------------------------------------------

### Why bad

- system overload

--------------------------------------------------

## 10. Timeout Handling

--------------------------------------------------

    execution_timeout=timedelta(minutes=30)

--------------------------------------------------

Good:
- prevent hanging tasks

--------------------------------------------------

Bad:
- no timeout

--------------------------------------------------

### Why bad

- stuck workers

--------------------------------------------------

## 11. Concurrency Controls

--------------------------------------------------

### max_active_runs

    max_active_runs=1

--------------------------------------------------

### task concurrency

- limits per task

--------------------------------------------------

### pools

    pool="api_pool"

--------------------------------------------------

Good:
- control load

--------------------------------------------------

Bad:
- unlimited parallelism

--------------------------------------------------

### Why bad

- DB overload
- API throttling

--------------------------------------------------

## 12. SLA and Monitoring

--------------------------------------------------

    sla=timedelta(hours=1)

--------------------------------------------------

Used for:
- alerting

--------------------------------------------------

## 13. Dependency Timing Issues

--------------------------------------------------

### Scenario

Upstream data arrives late

--------------------------------------------------

Solution:
- sensors
- delayed scheduling

--------------------------------------------------

## 14. Failure Scenarios

--------------------------------------------------

### 1. Retry storm

Cause:
- many tasks retry at once

--------------------------------------------------

Fix:
- exponential backoff
- pools

--------------------------------------------------

### 2. Duplicate processing

Cause:
- non-idempotent tasks

--------------------------------------------------

### 3. Missed runs

Cause:
- catchup disabled

--------------------------------------------------

### 4. Stuck tasks

Cause:
- no timeout

--------------------------------------------------

## 15. Good vs Bad

--------------------------------------------------

### Good

- interval-based logic
- idempotent tasks
- controlled retries
- concurrency limits

--------------------------------------------------

### Bad

- current time usage
- no retry control
- no limits

--------------------------------------------------

## 16. Production Patterns

--------------------------------------------------

### Pattern 1: Safe retry

- overwrite output
- no side effects

--------------------------------------------------

### Pattern 2: Controlled parallelism

- pools
- limits

--------------------------------------------------

### Pattern 3: Backfill-safe DAG

- interval-based logic

--------------------------------------------------

## 17. Debugging Scheduling Issues

--------------------------------------------------

### CLI

    airflow dags list
    airflow tasks state DAG_ID TASK_ID DATE

--------------------------------------------------

### What to check

- DAG run exists?
- task state?
- dependencies satisfied?

--------------------------------------------------

## 18. Final Principles

- scheduling = data intervals
- retries are normal
- tasks must be idempotent
- concurrency must be controlled
- failures must be expected
- backfills must be safe

--------------------------------------------------