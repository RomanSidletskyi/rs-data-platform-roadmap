# Airflow with Spark (Production-Level Deep Dive)

## 1. Core Principle

Airflow orchestrates.

Spark computes.

--------------------------------------------------

## 2. What Spark Should Do

Spark is responsible for:

- large-scale data processing
- joins
- aggregations
- transformations
- partitioned writes

--------------------------------------------------

## 3. What Airflow Should Do

Airflow is responsible for:

- scheduling
- dependency management
- triggering Spark jobs
- passing parameters
- monitoring execution

--------------------------------------------------

## 4. Architecture Pattern

    Airflow DAG
        ↓
    Spark job
        ↓
    S3 / Data Lake
        ↓
    dbt / warehouse

--------------------------------------------------

## 5. Spark Job Invocation

--------------------------------------------------

### Option 1: SparkSubmitOperator

    SparkSubmitOperator(
        task_id="spark_job",
        application="/jobs/job.py",
        conf={
            "spark.executor.memory": "2g"
        }
    )

--------------------------------------------------

### Option 2: BashOperator

    BashOperator(
        task_id="spark_job",
        bash_command="""
        spark-submit job.py \
          --start {{ data_interval_start }} \
          --end {{ data_interval_end }}
        """
    )

--------------------------------------------------

### Good

- external execution
- parameterized jobs

--------------------------------------------------

### Bad

    df = spark.read(...)

inside Airflow

--------------------------------------------------

### Why bad

- Airflow is not distributed
- memory bottlenecks
- no scaling

--------------------------------------------------

## 6. Parameter Passing

Always pass:

- interval start
- interval end

--------------------------------------------------

    --start {{ data_interval_start }}
    --end {{ data_interval_end }}

--------------------------------------------------

### Good

deterministic jobs

--------------------------------------------------

### Bad

    datetime.now()

--------------------------------------------------

### Why bad

- inconsistent runs

--------------------------------------------------

## 7. Output Design

Spark should write:

- partitioned data

--------------------------------------------------

    s3://bucket/orders/
        interval_start=...
        interval_end=...

--------------------------------------------------

### Good

overwrite partition

--------------------------------------------------

### Bad

append blindly

--------------------------------------------------

### Why bad

- duplicates
- inconsistent datasets

--------------------------------------------------

## 8. Idempotency in Spark

Spark jobs must be idempotent.

--------------------------------------------------

### Good

    mode("overwrite")

--------------------------------------------------

### Bad

    mode("append")

--------------------------------------------------

## 9. Data Contracts

Spark output must guarantee:

- schema stability
- partition consistency
- data completeness

--------------------------------------------------

## 10. Validation Pattern

After Spark:

- check output exists
- check row count
- check schema

--------------------------------------------------

    def validate():
        assert row_count > 0

--------------------------------------------------

## 11. Failure Handling

--------------------------------------------------

### Spark failure

- job fails
- Airflow marks task failed

--------------------------------------------------

### Retry

- Spark reruns entire job

--------------------------------------------------

### Requirement

job must be safe to rerun

--------------------------------------------------

## 12. Performance Considerations

--------------------------------------------------

### Partitioning

- by date
- by business key

--------------------------------------------------

### Small files problem

- too many files
- slow reads

--------------------------------------------------

### Solution

- coalesce
- compaction

--------------------------------------------------

## 13. Spark vs Airflow Responsibilities

--------------------------------------------------

### Spark

- compute
- transformations

--------------------------------------------------

### Airflow

- orchestration
- monitoring

--------------------------------------------------

## 14. Anti-Patterns

--------------------------------------------------

### 1. Spark inside PythonOperator

--------------------------------------------------

### 2. No partitioning

--------------------------------------------------

### 3. Non-idempotent jobs

--------------------------------------------------

### 4. Hardcoded paths

--------------------------------------------------

### 5. No validation

--------------------------------------------------

## 15. Production Scenarios

--------------------------------------------------

### Scenario 1: Duplicate data

Cause:
- append mode

--------------------------------------------------

### Scenario 2: Missing partition

Cause:
- failed Spark job

--------------------------------------------------

### Scenario 3: Slow queries

Cause:
- small files

--------------------------------------------------

## 16. Advanced Patterns

--------------------------------------------------

### Pattern 1: Metadata-driven jobs

Airflow passes:
- interval
- config

Spark decides:
- logic

--------------------------------------------------

### Pattern 2: Multi-stage pipelines

    extract → spark → validate → dbt

--------------------------------------------------

### Pattern 3: Lakehouse

Spark writes:
- delta / parquet

dbt reads:
- curated tables

--------------------------------------------------

## 17. Debugging

--------------------------------------------------

### Check:

- Spark logs
- Airflow logs
- output path

--------------------------------------------------

### Common issues

- path mismatch
- memory error
- schema mismatch

--------------------------------------------------

## 18. Good vs Bad

--------------------------------------------------

### Good

- external Spark jobs
- partitioned output
- idempotent writes
- validation

--------------------------------------------------

### Bad

- Spark in Airflow
- no partitioning
- append-only logic

--------------------------------------------------

## 19. Final Principles

- Airflow orchestrates
- Spark computes
- data must be partitioned
- jobs must be idempotent
- outputs must be validated
- failures must be expected

--------------------------------------------------