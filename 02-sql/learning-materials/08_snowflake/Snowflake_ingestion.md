# Snowflake Ingestion — Complete Guide (Senior Cheat Sheet)

## 1. Big Picture

Snowflake ingestion usually consists of these layers:

- **Files** in object storage (S3 / GCS / Azure)
- **Stage** as a named access point to storage
- **File format** describing how files are parsed
- **COPY INTO** for batch loading
- **Snowpipe** for automated micro-batch loading
- **Raw tables** as immutable or near-immutable landing tables
- **dbt** for standardization and marts

Snowpipe loads files **as soon as they are available in a stage**, which makes it suitable for micro-batch ingestion rather than large scheduled batch loads. :contentReference[oaicite:0]{index=0}

---

## 2. Stages

A stage is a Snowflake object that points to file storage. A stage can be:

- **Internal stage** — storage inside Snowflake
- **External stage** — points to S3 / GCS / Azure

`CREATE STAGE` supports both internal and external stages. :contentReference[oaicite:1]{index=1}

### 2.1 Internal stage

    CREATE OR REPLACE STAGE int_stage;

Use when:
- loading local files temporarily
- quick prototyping
- you do not need direct cloud bucket ownership

### 2.2 External stage

    CREATE OR REPLACE STAGE ext_raw_stage
      URL='s3://company-raw/';

If the URL ends with `/`, Snowflake treats it as a bucket prefix and loads objects under that path. :contentReference[oaicite:2]{index=2}

### 2.3 Path usage

If stage URL is:

    s3://company-raw/

then:

- `@ext_raw_stage/orders/`
- `@ext_raw_stage/users/dt=2026-03-20/`

are sub-prefixes below that stage root.

### 2.4 One big stage vs many stages

**One big stage**
- simpler initial setup
- more centralized
- can become messy operationally

**Domain-based stages**
- clearer ownership
- simpler access control
- cleaner copy and Snowpipe definitions

Example:

    CREATE OR REPLACE STAGE orders_stage
      URL='s3://company-raw/orders/';

    CREATE OR REPLACE STAGE users_stage
      URL='s3://company-raw/users/';

---

## 3. Access to S3 Bucket

The recommended secure approach is **storage integration** rather than embedding raw cloud credentials in SQL. A storage integration stores a generated IAM entity plus allowed / blocked locations. Cloud admins then grant bucket permissions to that generated entity. :contentReference[oaicite:3]{index=3}

### 3.1 Create storage integration (AWS S3)

    CREATE OR REPLACE STORAGE INTEGRATION s3_raw_int
      TYPE = EXTERNAL_STAGE
      STORAGE_PROVIDER = S3
      ENABLED = TRUE
      STORAGE_ALLOWED_LOCATIONS = ('s3://company-raw/');

This creates a Snowflake-managed IAM identity / principal model for access to the external bucket. :contentReference[oaicite:4]{index=4}

### 3.2 Inspect integration details

    DESC INTEGRATION s3_raw_int;

From this output, cloud admins usually take:
- Snowflake IAM user / principal info
- external ID if needed
- allowed locations

Then they configure the AWS IAM role / bucket policy to allow Snowflake access. Snowflake documents this as the standard flow for S3 storage integrations. :contentReference[oaicite:5]{index=5}

### 3.3 Create stage using storage integration

    CREATE OR REPLACE STAGE ext_raw_stage
      URL='s3://company-raw/'
      STORAGE_INTEGRATION = s3_raw_int;

This is generally preferred over putting AWS keys directly into stage credentials. :contentReference[oaicite:6]{index=6}

### 3.4 Auto-ingest notifications for Snowpipe

Automated Snowpipe on S3 relies on cloud event notifications rather than scanning the bucket continuously. Notifications include file names but not the data itself. :contentReference[oaicite:7]{index=7}

Typical flow:
- file lands in S3
- S3 event notification is emitted
- message queue / notification integration passes event
- Snowpipe consumes event and loads file

Snowflake’s official S3 automated Snowpipe flow is documented around storage integration + event notifications. :contentReference[oaicite:8]{index=8}

---

## 4. File Formats

File formats define how Snowflake parses files during load.

`CREATE FILE FORMAT` is the standard object used for this. :contentReference[oaicite:9]{index=9}

### 4.1 Parquet

    CREATE OR REPLACE FILE FORMAT ff_parquet
      TYPE = PARQUET;

Best for:
- structured data
- large analytical feeds
- efficient storage and scanning

### 4.2 JSON

    CREATE OR REPLACE FILE FORMAT ff_json
      TYPE = JSON;

Best for:
- schema drift
- nested payloads
- landing into VARIANT

### 4.3 CSV

    CREATE OR REPLACE FILE FORMAT ff_csv
      TYPE = CSV
      FIELD_DELIMITER = ','
      SKIP_HEADER = 1
      FIELD_OPTIONALLY_ENCLOSED_BY = '"';

CSV is usually the most fragile format operationally because of delimiter, quoting, header, and column-count mismatch issues. Snowflake’s file format options are the main control layer for CSV parsing. :contentReference[oaicite:10]{index=10}

---

## 5. COPY INTO — Core Loading Primitive

`COPY INTO <table>` is Snowflake’s main command for batch loading from files into tables. It supports:
- selecting files by path or pattern
- file format selection
- transform-during-load
- error handling
- validation mode
- metadata columns
- name-based matching in supported cases :contentReference[oaicite:11]{index=11}

### 5.1 Simplest load

    COPY INTO raw_orders
    FROM @ext_raw_stage/orders/
    FILE_FORMAT = (FORMAT_NAME = ff_parquet);

This attempts to load all files under `orders/` into `raw_orders`, using the declared file format. :contentReference[oaicite:12]{index=12}

### 5.2 Restrict files using PATTERN

    COPY INTO raw_orders
    FROM @ext_raw_stage/orders/
    FILE_FORMAT = (FORMAT_NAME = ff_parquet)
    PATTERN = '.*[.]parquet';

Useful when one prefix contains multiple file types.

### 5.3 Restrict files explicitly using FILES

    COPY INTO raw_orders
    FROM @ext_raw_stage/orders/
    FILES = ('part-0001.parquet', 'part-0002.parquet')
    FILE_FORMAT = (FORMAT_NAME = ff_parquet);

### 5.4 Load via SELECT (transform during load)

    COPY INTO raw_orders
      (order_id, user_id, order_ts, amount)
    FROM (
      SELECT
        $1:order_id::STRING,
        $1:user_id::STRING,
        $1:order_ts::TIMESTAMP_NTZ,
        $1:amount::NUMBER(18,2)
      FROM @ext_raw_stage/orders/
    )
    FILE_FORMAT = (FORMAT_NAME = ff_json);

This pattern is useful when:
- the source is JSON / VARIANT-like
- you want explicit casts
- you want metadata columns
- you want better control during raw ingestion

Snowflake supports transform-during-load through a `SELECT` in `COPY INTO`. :contentReference[oaicite:13]{index=13}

---

## 6. COPY INTO — Column Handling

This is one of the most important interview topics.

### 6.1 Positional loading

Default simple loading often assumes compatibility between file structure and table structure.

Risk:
- column order drift
- file schema changes
- accidental silent mismatches

### 6.2 MATCH_BY_COLUMN_NAME

Use this when you want Snowflake to map source fields to target columns by name instead of relying on position.

    COPY INTO raw_users
    FROM @ext_raw_stage/users/
    FILE_FORMAT = (FORMAT_NAME = ff_parquet)
    MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;

Main values:
- `CASE_SENSITIVE`
- `CASE_INSENSITIVE`
- `NONE`

Use it when:
- producer may reorder columns
- Parquet / JSON feeds are reasonably structured
- you want safer ingestion under additive schema change

Important limitation:
`MATCH_BY_COLUMN_NAME` cannot be used together with `VALIDATION_MODE` in the same `COPY` statement. :contentReference[oaicite:14]{index=14}

### 6.3 Explicit column list

    COPY INTO raw_orders
      (order_id, user_id, order_ts, amount)
    FROM @ext_raw_stage/orders/
    FILE_FORMAT = (FORMAT_NAME = ff_parquet);

Useful when:
- target table has more columns than source
- you want controlled column population
- raw table also includes audit fields with defaults

### 6.4 Using metadata columns in load

Snowflake exposes staged-file metadata columns such as:
- `METADATA$FILENAME`
- `METADATA$FILE_ROW_NUMBER`
- `METADATA$FILE_LAST_MODIFIED`
- `METADATA$START_SCAN_TIME` :contentReference[oaicite:15]{index=15}

Example:

    COPY INTO raw_orders
      (order_id, user_id, amount, src_filename, src_row_number, src_last_modified, scan_time)
    FROM (
      SELECT
        $1:order_id::STRING,
        $1:user_id::STRING,
        $1:amount::NUMBER(18,2),
        METADATA$FILENAME,
        METADATA$FILE_ROW_NUMBER,
        METADATA$FILE_LAST_MODIFIED,
        METADATA$START_SCAN_TIME
      FROM @ext_raw_stage/orders/
    )
    FILE_FORMAT = (FORMAT_NAME = ff_json);

Why keep them:
- lineage
- debugging
- replay analysis
- bad-row tracing
- dedup support

---

## 7. COPY INTO — Error Handling

Error handling is one of the most important production concerns.

`ON_ERROR` controls what Snowflake does when parsing or load errors occur. Supported behaviors include:
- `ABORT_STATEMENT`
- `CONTINUE`
- `SKIP_FILE`
- `SKIP_FILE_<n>`
- `SKIP_FILE_<n>%` :contentReference[oaicite:16]{index=16}

### 7.1 Fail fast

    COPY INTO raw_billing
    FROM @ext_raw_stage/billing/
    FILE_FORMAT = (FORMAT_NAME = ff_csv)
    ON_ERROR = ABORT_STATEMENT;

Good for:
- billing
- finance
- regulated pipelines

### 7.2 Continue

    COPY INTO raw_events
    FROM @ext_raw_stage/events/
    FILE_FORMAT = (FORMAT_NAME = ff_json)
    ON_ERROR = CONTINUE;

Good for:
- noisy event streams
- high-volume telemetry
- cases where isolated bad rows should not stop the whole load

Caveat:
do not use `CONTINUE` without observability and quarantine logic.

### 7.3 Skip bad files

    COPY INTO raw_orders
    FROM @ext_raw_stage/orders/
    FILE_FORMAT = (FORMAT_NAME = ff_parquet)
    ON_ERROR = SKIP_FILE;

Good when:
- files are atomic batch units
- one broken file should not block the rest

### 7.4 Choosing ON_ERROR by domain

Recommended mental model:
- **critical business data** → fail fast
- **high-volume event data** → controlled continue / skip
- **semi-structured unstable data** → often land raw first, then quarantine downstream

---

## 8. COPY INTO — Validation Without Loading

`VALIDATION_MODE` lets you validate staged files without actually loading them into the table. This is useful for dry-runs, troubleshooting, and testing a new feed. Snowflake documents options such as `RETURN_ALL_ERRORS`. :contentReference[oaicite:17]{index=17}

Example:

    COPY INTO raw_payments
    FROM @ext_raw_stage/payments/
    FILE_FORMAT = (FORMAT_NAME = ff_json)
    VALIDATION_MODE = RETURN_ALL_ERRORS;

Use cases:
- validate a new source before first production run
- investigate broken files
- test after upstream schema changes

Important:
`VALIDATION_MODE` cannot be used together with `MATCH_BY_COLUMN_NAME` in the same statement. :contentReference[oaicite:18]{index=18}

---

## 9. COPY INTO — Other Important Options

These are the most important practical options to remember.

### PURGE

    COPY INTO raw_orders
    FROM @ext_raw_stage/orders/
    FILE_FORMAT = (FORMAT_NAME = ff_parquet)
    PURGE = TRUE;

Meaning:
- after successful bulk load, remove staged files

Important:
pipe objects do **not** support `PURGE`; Snowpipe cannot automatically delete staged files after successful load. Snowflake recommends `REMOVE` or cloud lifecycle policies instead. :contentReference[oaicite:19]{index=19}

### FORCE

    COPY INTO raw_orders
    FROM @ext_raw_stage/orders/
    FILE_FORMAT = (FORMAT_NAME = ff_parquet)
    FORCE = TRUE;

Meaning:
- reload files even if Snowflake thinks they were already loaded

Use carefully:
- recovery
- replay
- controlled reloads

### SIZE_LIMIT
Can be used to cap the amount of data loaded in a statement. Useful operationally for testing or partial loads. :contentReference[oaicite:20]{index=20}

### TRUNCATECOLUMNS
Allows oversized string values to be truncated rather than failing the statement. Use carefully because it can hide data issues. :contentReference[oaicite:21]{index=21}

### ENFORCE_LENGTH
Controls whether oversized strings error out versus being accepted/truncated depending on settings. :contentReference[oaicite:22]{index=22}

### RETURN_FAILED_ONLY
Useful for narrowing output to failures during certain copy/reporting workflows. :contentReference[oaicite:23]{index=23}

Practical rule:
use explicit `COPY INTO` options rather than relying on inherited stage defaults when operational correctness matters.

---

## 10. Snowpipe

Snowpipe loads data from files automatically when they appear in a stage. It is designed for micro-batch / near-real-time file ingestion. :contentReference[oaicite:24]{index=24}

### 10.1 Create pipe

    CREATE OR REPLACE PIPE pipe_orders
      AUTO_INGEST = TRUE
    AS
    COPY INTO raw_orders
    FROM @ext_raw_stage/orders/
    FILE_FORMAT = (FORMAT_NAME = ff_parquet)
    MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;

### 10.2 When to use Snowpipe

Use Snowpipe when:
- producers write files continuously into cloud storage
- minutes-level freshness is enough
- you want managed ingestion

### 10.3 When not to use Snowpipe

Consider alternatives when:
- you need strict sub-second / ultra-low-latency streaming
- data does not naturally arrive as files
- bulk scheduled loads are simpler and cheaper

### 10.4 Pause / staleness behavior

When a pipe is paused, event messages enter a limited retention period. The default is 14 days; after that the pipe can become stale. :contentReference[oaicite:25]{index=25}

### 10.5 Snowpipe file cleanup

Snowpipe does not support `PURGE`. Use:
- `REMOVE`
- bucket lifecycle policies
- archive lifecycle rules :contentReference[oaicite:26]{index=26}

---

## 11. Metadata-Driven Ingestion

Instead of hardcoding many `COPY INTO` or `CREATE PIPE` statements, use a config table.

### 11.1 Config table example

    CREATE OR REPLACE TABLE ingestion_config (
        source_prefix STRING,
        target_table STRING,
        file_format_name STRING,
        pattern STRING,
        pipe_name STRING,
        on_error STRING,
        match_by_column_name STRING,
        is_active BOOLEAN
    );

Example rows:

    INSERT INTO ingestion_config VALUES
    ('orders/',   'raw_orders',   'ff_parquet', '.*[.]parquet', 'pipe_orders',   'ABORT_STATEMENT', 'CASE_INSENSITIVE', TRUE),
    ('users/',    'raw_users',    'ff_parquet', '.*[.]parquet', 'pipe_users',    'ABORT_STATEMENT', 'CASE_INSENSITIVE', TRUE),
    ('payments/', 'raw_payments', 'ff_json',    '.*[.]json',    'pipe_payments', 'CONTINUE',        'NONE',             TRUE);

### 11.2 Why this pattern is good

- scalable
- less copy-paste
- easier onboarding of new feeds
- centralized governance
- easier orchestration and deployment

---

## 12. Metadata-Driven Deployment Procedure

Example procedure to create or replace Snowpipes dynamically from config:

    CREATE OR REPLACE PROCEDURE deploy_pipes()
    RETURNS STRING
    LANGUAGE JAVASCRIPT
    AS
    $$
    var rs = snowflake.execute({
      sqlText: `
        SELECT source_prefix, target_table, file_format_name, pattern, pipe_name, on_error, match_by_column_name
        FROM ingestion_config
        WHERE is_active = TRUE
      `
    });

    while (rs.next()) {
      var sourcePrefix = rs.getColumnValue(1);
      var targetTable  = rs.getColumnValue(2);
      var fileFormat   = rs.getColumnValue(3);
      var pattern      = rs.getColumnValue(4);
      var pipeName     = rs.getColumnValue(5);
      var onError      = rs.getColumnValue(6);
      var matchMode    = rs.getColumnValue(7);

      var copySql = `
        COPY INTO ${targetTable}
        FROM @ext_raw_stage/${sourcePrefix}
        FILE_FORMAT = (FORMAT_NAME = ${fileFormat})
        PATTERN = '${pattern}'
        ON_ERROR = ${onError}
      `;

      if (matchMode != 'NONE') {
        copySql += ` MATCH_BY_COLUMN_NAME = ${matchMode}`;
      }

      var pipeSql = `
        CREATE OR REPLACE PIPE ${pipeName}
          AUTO_INGEST = TRUE
        AS
        ${copySql}
      `;

      snowflake.execute({sqlText: pipeSql});
    }

    return 'Pipes deployed';
    $$;

Run it:

    CALL deploy_pipes();

Notes:
- this is a deployment-time control-plane procedure
- in production, validate object names to avoid unsafe dynamic SQL
- often paired with CI/CD or change-management process

---

## 13. Monitoring and Observability

This is where many candidates stay too shallow. In production you need:
- load history
- copy failures
- pipe usage
- pipe health
- freshness
- file-level troubleshooting

### 13.1 COPY_HISTORY

Snowflake provides `COPY_HISTORY` as a table function and also via `ACCOUNT_USAGE`. It covers both `COPY INTO` and Snowpipe-related load history. The table function has shorter retention, while `ACCOUNT_USAGE.COPY_HISTORY` provides longer historical visibility. :contentReference[oaicite:27]{index=27}

Example:

    SELECT *
    FROM TABLE(
      COPY_HISTORY(
        TABLE_NAME => 'RAW_ORDERS',
        START_TIME => DATEADD('day', -1, CURRENT_TIMESTAMP())
      )
    );

Use it to answer:
- did file X load?
- when did it load?
- was there an error?
- how many rows were parsed / loaded?

### 13.2 PIPE_USAGE_HISTORY

Use this to inspect Snowpipe resource usage and operational history.

    SELECT *
    FROM SNOWFLAKE.ACCOUNT_USAGE.PIPE_USAGE_HISTORY
    WHERE PIPE_NAME ILIKE '%PIPE_ORDERS%'
      AND START_TIME >= DATEADD('day', -7, CURRENT_TIMESTAMP());

Use it for:
- Snowpipe cost analysis
- usage trends
- ingestion behavior over time

### 13.3 SHOW PIPES / DESCRIBE PIPE

    SHOW PIPES;

    DESC PIPE pipe_orders;

Use for:
- checking pipe definition
- confirming auto-ingest status
- debugging deployed pipe SQL

### 13.4 System function: pipe status

    SELECT SYSTEM$PIPE_STATUS('pipe_orders');

Good for:
- current runtime state
- paused / stale diagnosis
- quick health checks

### 13.5 Query history for ingestion jobs

    SELECT *
    FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
    WHERE QUERY_TEXT ILIKE '%COPY INTO%'
      AND START_TIME >= DATEADD('day', -1, CURRENT_TIMESTAMP());

Useful when:
- troubleshooting manual loads
- tracing failures
- finding long-running copy operations

### 13.6 File-level debugging with metadata columns

If raw tables keep:
- source filename
- row number
- last modified
- scan time

then debugging becomes much easier.

Example:

    SELECT src_filename, COUNT(*)
    FROM raw_orders
    WHERE ingested_at >= DATEADD('hour', -1, CURRENT_TIMESTAMP())
    GROUP BY 1
    ORDER BY 2 DESC;

---

## 14. Broken Files and Quarantine Pattern

Do not rely only on `ON_ERROR = CONTINUE`.

Recommended pattern:
- valid loads go into raw tables
- invalid file / row events go into quarantine and alerts

Example quarantine table:

    CREATE OR REPLACE TABLE ingestion_quarantine (
        source_prefix STRING,
        file_name STRING,
        error_message STRING,
        detected_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
    );

Then a monitoring task or orchestration layer writes failures there after inspecting load history.

Good production behavior:
- alert on failed files
- keep lineage
- allow replay
- do not silently lose data

---

## 15. Schema Drift Handling

Treat schema drift in categories:

### 15.1 Additive drift
Example:
- new nullable column added upstream

Safer handling:
- `MATCH_BY_COLUMN_NAME`
- optional schema evolution where appropriate
- downstream dbt adjustments

### 15.2 Breaking drift
Example:
- type changed
- renamed field
- semantic meaning changed

Safer handling:
- land into VARIANT or staging-safe structure
- quarantine suspicious files
- version your source contract
- avoid pretending automatic evolution can solve semantic drift

---

## 16. Best Practices by Format

### 16.1 Parquet
Best for:
- stable structured feeds
- larger scale ingestion
- efficient analytics

Recommended:
    COPY INTO raw_orders
    FROM @ext_raw_stage/orders/
    FILE_FORMAT = (FORMAT_NAME = ff_parquet)
    MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;

### 16.2 JSON
Best for:
- unstable schemas
- nested payloads
- event data

Typical landing pattern:
    CREATE OR REPLACE TABLE raw_events (
      payload VARIANT,
      src_filename STRING,
      ingested_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
    );

    COPY INTO raw_events (payload, src_filename)
    FROM (
      SELECT
        $1,
        METADATA$FILENAME
      FROM @ext_raw_stage/events/
    )
    FILE_FORMAT = (FORMAT_NAME = ff_json)
    ON_ERROR = CONTINUE;

### 16.3 CSV
Best for:
- legacy systems
- vendor exports

Risks:
- delimiter issues
- quoting issues
- header drift
- column mismatch

Be stricter with:
- file format settings
- validation
- fail-fast if the data is business-critical

---

## 17. Batch vs Snowpipe

### Batch COPY INTO
Better when:
- predictable schedules
- lower cost priority
- large files arrive in batches

### Snowpipe
Better when:
- files arrive continuously
- freshness matters
- micro-batch ingestion is acceptable

Architectural summary:
- **COPY INTO** = batch primitive
- **Snowpipe** = automated micro-batch primitive

---

## 18. Production Checklist

Before production:
- create storage integration
- validate bucket IAM / permissions
- create stages
- create file formats
- create raw tables
- test `COPY INTO` with `VALIDATION_MODE`
- decide `ON_ERROR` policy
- add metadata columns
- add monitoring queries
- decide file retention / cleanup strategy

During production:
- monitor `COPY_HISTORY`
- monitor `PIPE_USAGE_HISTORY`
- check `SYSTEM$PIPE_STATUS`
- track raw freshness
- alert on failed loads
- quarantine bad files
- support replay with immutable source files

---

## 19. Senior Interview Answer (Short)

> In Snowflake, I design ingestion around stages, file formats, COPY semantics, and observability. I prefer storage integrations for secure bucket access, keep raw loads explicit with controlled COPY options, and use Snowpipe when file-based micro-batch freshness is needed. For scale, I avoid hardcoding every pipeline and instead use metadata-driven deployment of pipes and load definitions. In production, I treat monitoring, error handling, lineage, and replayability as first-class requirements, not afterthoughts.

---

## 20. One-Line Summary

Snowflake ingestion = secure storage access + explicit parsing rules + controlled COPY behavior + automated or batch loading + strong monitoring and replay strategy.