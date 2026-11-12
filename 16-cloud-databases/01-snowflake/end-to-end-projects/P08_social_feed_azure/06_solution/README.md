# P08 Solution

Reference implementation for [P08](../README.md). Build your own first with [07_build_it_yourself.md](../07_build_it_yourself.md); run this one with [QUICKSTART.md](../QUICKSTART.md).

## Layout

```text
06_solution/
  p08.env.example / run_sql.sh     env template; SQL runner fills <placeholders> from p08.env
  producer/
    jetstream_producer.py          Jetstream or synthetic, batches per collection, cursor checkpoint, P04 sinks
    test_jetstream_producer.py
    requirements.txt
  azure/
    01_provision.sh                storage, container, queue, Event Grid subscription, lifecycle policy
    lifecycle_policy.json          cool after 7 days, delete after 30
    02_grant_snowflake_access.sh   role assignments for Snowflake's service principals
    10_integrations.sql            storage and notification integrations
    11_stage_and_pipes.sql         external stage, four auto-ingest pipes, refresh
  aws/
    10_integration.sql             storage integration (provision with the P04 AWS scripts)
    11_stage_and_pipes.sql         stage and four pipes on the shared SQS queue
  core/
    00_account_setup.sql           roles, warehouse, monitor, database, task privileges
    01_schemas_and_raw.sql         transient raw tables, append-only streams, STG.EVENT, run log
    20_staging.sql                 PIPE.LOAD_EVENTS (dedup window), PIPE.PURGE_RAW
    30_mart.sql                    dynamic tables and dashboard views
    40_ops.sql                     files, latency, dedup, Snowpipe and task cost
    90_pause.sql / 91_resume.sql
  tests/
    data_quality_checks.sql
    failure_drills.md
  teardown.sql
```

## Expected Results (20 minutes of live Jetstream, default batching)

| Check | Expected |
| --- | --- |
| Producer tests | 7 passed |
| Events | About 600,000 in `STG.EVENT`, two thirds likes |
| Files | About 4 per minute (one per collection), from tens of KB (follows) to about 0.5 MB (likes) compressed |
| p95 event to RAW | About 1 to 2 minutes |
| Duplicate keys in `STG.EVENT` | 0, also after a producer restart |
| Data quality checks | All `PASS` |

## Design Notes Worth Comparing With Your Version

- **Cursor = oldest unflushed event**, saved after writing files: crash-safe without exactly-once machinery.
- **Four pipes, one queue:** isolation where it matters (tables, pauses), simplicity where it does not (notifications).
- **Two-hour dedup window:** constant cost per run as `STG.EVENT` grows.
- **Deletes resolved by joining to creates:** unresolved deletes are counted, not hidden.
- **Retention by layer:** lake lifecycle, transient raw with purge, permanent staging.
