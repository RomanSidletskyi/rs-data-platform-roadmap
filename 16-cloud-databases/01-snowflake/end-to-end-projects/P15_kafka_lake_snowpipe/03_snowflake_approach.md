# 3. Snowflake Approach

## Layers and Objects

```mermaid
flowchart TB
    subgraph LAKE[Lake container: landing/kafka]
        F["topic=wiki.recentchange/dt=.../hour=.../partition=N/topic+N+first+last.ndjson.gz"]
    end
    subgraph RAWS[RAW]
        ST[LAKE_STAGE + FF_KAFKA_NDJSON]
        PI[WIKI_LAKE_PIPE]
        RT[(WIKI_RECENTCHANGE_RAW: PAYLOAD, VALUE_RAW, Kafka coordinates)]
    end
    subgraph STGS[STG]
        S1[WIKI_RAW_STREAM]
        TK[LOAD_WIKI_CHANGE]
        SG[(WIKI_CHANGE)]
    end
    subgraph MARTS[MART]
        DT[EDITS_PER_MINUTE]
        TP[V_TOP_PAGES_LAST_HOUR]
    end
    subgraph OPSS[OPS]
        OI[V_OFFSET_INTEGRITY]
        FS[V_FILE_STATS_LAST_DAY]
        FR[V_PIPELINE_FRESHNESS]
        LT[V_LATENCY_LAST_HOUR]
        AL[ALERT_RAW_STALE]
    end
    F --> ST --> PI --> RT
    RT --> S1 --> TK --> SG --> DT
    SG --> TP
    RT --> OI
    RT --> FS
    RT --> FR
    SG --> LT
    FR --> AL
```

## Object Inventory

| Object | Type | Purpose |
| --- | --- | --- |
| `P15_AZURE_STORAGE_INT`, `P15_AZURE_QUEUE_INT` | Integrations | Read `landing/kafka/`, receive storage events |
| `RAW.LAKE_STAGE`, `RAW.FF_KAFKA_NDJSON` | Stage, file format | Lake root for Kafka topics |
| `RAW.WIKI_LAKE_PIPE` | Pipe, auto-ingest | Loads one topic's folder, extracts Kafka coordinates in the `COPY` transformation |
| `RAW.WIKI_RECENTCHANGE_RAW` | Table | Payload, raw text for unparseable values, typed coordinates, file and load metadata |
| `STG.*`, `MART.*` | Stream, task, table, dynamic table, view | Same as P04 and P14 |
| `OPS.V_OFFSET_INTEGRITY` | View | Duplicate, missing, and unparseable counts per partition |
| `OPS.V_FILE_STATS_LAST_DAY` | View | Files and rows per hour: the small-file indicator |
| `tests/replay_from_lake.sql` | Script | `COPY ... FORCE = TRUE` into a replay table |

## Feature Choices

| Need | Chosen | Rejected here | Why |
| --- | --- | --- | --- |
| Load lake files continuously | Snowpipe auto-ingest | Scheduled `COPY` | Event-driven, serverless |
| Extract Kafka coordinates | `COPY` transformation into typed columns | Parse `VARIANT` later | Cheap integrity checks, clear schema |
| File reconciliation | Offset contiguity per partition | Producer manifests (P04) | Offsets are a natural, complete sequence |
| Replay | `COPY ... FORCE = TRUE` into a separate table | `ALTER PIPE REFRESH` | `REFRESH` skips files already in load metadata and only looks back 7 days |
| Querying the lake in place | Not used for the pipeline | External tables, Iceberg tables | Stretch goal; compare with module `14-iceberg` |

## Data Model

```mermaid
erDiagram
    WIKI_RECENTCHANGE_RAW ||--o{ WIKI_CHANGE : "deduplicated into"
    WIKI_CHANGE ||--o{ EDITS_PER_MINUTE : "aggregated into"
    WIKI_RECENTCHANGE_RAW {
        VARIANT PAYLOAD
        STRING VALUE_RAW
        STRING KAFKA_TOPIC
        NUMBER KAFKA_PARTITION
        NUMBER KAFKA_OFFSET
        TIMESTAMP_LTZ KAFKA_TS
        STRING SRC_FILE
        TIMESTAMP_LTZ LOADED_AT
    }
    WIKI_CHANGE {
        STRING EVENT_ID PK
        TIMESTAMP_TZ EVENT_TS
        STRING WIKI
        NUMBER KAFKA_PARTITION
        NUMBER KAFKA_OFFSET
        TIMESTAMP_LTZ KAFKA_TS
        TIMESTAMP_LTZ LOADED_AT
        TIMESTAMP_LTZ STAGED_AT
    }
    EDITS_PER_MINUTE {
        TIMESTAMP_TZ MINUTE_TS
        STRING WIKI
        STRING CHANGE_TYPE
        BOOLEAN IS_BOT
        NUMBER CHANGE_COUNT
    }
```

## What This Project Teaches About Snowflake

- Snowpipe works with **any** file producer; the quality of the files (size, naming, immutability) decides cost and correctness.
- **`COPY` transformations** can turn semi-structured envelopes into typed columns at load time.
- **Load metadata** protects against reloads; **`FORCE = TRUE`** deliberately bypasses it for replay into another table.
- Snowflake can be one consumer of an open lake rather than the only copy of the data.
