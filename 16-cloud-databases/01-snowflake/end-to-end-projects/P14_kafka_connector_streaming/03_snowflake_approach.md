# 3. Snowflake Approach

## Layers and Objects

```mermaid
flowchart TB
    subgraph KAFKA[Kafka lab]
        T1[(wiki.recentchange: partitions 0, 1, 2)]
        CON[Snowflake sink: 3 tasks]
        DLQ[(wiki.recentchange.dlq)]
    end
    subgraph RAWS[RAW]
        CH0[channel for partition 0]
        CH1[channel for partition 1]
        CH2[channel for partition 2]
        RT[(WIKI_RECENTCHANGE_RAW: RECORD_METADATA, RECORD_CONTENT)]
    end
    subgraph STGS[STG]
        S1[WIKI_RAW_STREAM]
        TK[LOAD_WIKI_CHANGE: serverless task]
        ST[(WIKI_CHANGE)]
    end
    subgraph MARTS[MART]
        DT[EDITS_PER_MINUTE: dynamic table]
        LV[V_LIVE_LAST_5_MINUTES]
        TP[V_TOP_PAGES_LAST_HOUR]
    end
    subgraph OPSS[OPS]
        OI[V_OFFSET_INTEGRITY]
        FR[V_PIPELINE_FRESHNESS]
        LT[V_LATENCY_LAST_HOUR]
        AL[ALERT_RAW_STALE]
    end
    T1 --> CON
    CON --> DLQ
    CON --> CH0 --> RT
    CON --> CH1 --> RT
    CON --> CH2 --> RT
    RT --> S1 --> TK --> ST
    ST --> DT
    ST --> TP
    RT --> LV
    RT --> OI
    RT --> FR
    ST --> LT
    FR --> AL
```

## Object Inventory

| Object | Type | Purpose |
| --- | --- | --- |
| `P14_OWNER`, `P14_CONNECTOR`, `P14_READER` | Roles | Administer; write raw only; consume |
| `P14_KAFKA_SVC` | Service user | Identity of Kafka Connect, key-pair only |
| `P14_TRANSFORM_WH`, `P14_BI_WH`, `P14_RM` | Warehouses, monitor | Same as P04; streaming ingestion needs no warehouse |
| `RAW.WIKI_RECENTCHANGE_RAW` | Table, owned by `P14_CONNECTOR`, change tracking on | Connector target |
| Channels | Snowpipe Streaming objects (`SHOW CHANNELS`) | One per topic partition, holds the offset token |
| `STG.WIKI_RAW_STREAM`, `STG.LOAD_WIKI_CHANGE`, `STG.WIKI_CHANGE` | Stream, serverless task, table | Deduplicated staging, as in P04 |
| `MART.EDITS_PER_MINUTE` | Dynamic table | Minute aggregates |
| `MART.V_LIVE_LAST_5_MINUTES` | View over RAW | Seconds-fresh, not deduplicated |
| `OPS.V_OFFSET_INTEGRITY` | View | Duplicate and missing offsets per partition |
| `OPS.V_LATENCY_LAST_HOUR`, `OPS.V_PIPELINE_FRESHNESS`, `OPS.ALERT_RAW_STALE` | Views, alert | Evidence and alerting |

## How Channels and Offset Tokens Give Exactly-Once

```mermaid
sequenceDiagram
    participant K as Kafka partition 1
    participant C as Connector task
    participant CH as Channel for partition 1
    participant T as RAW table
    C->>CH: open channel, get last offset token
    CH-->>C: token = 41999
    C->>K: seek to offset 42000
    K-->>C: records 42000 to 42499
    C->>CH: insert rows + offset token 42499
    CH->>T: rows and token committed together
    Note over C: crash before Kafka offset commit
    C->>CH: reopen channel, get token
    CH-->>C: token = 42499
    C->>K: seek to 42500, no duplicates
```

## Feature Choices

| Need | Chosen | Rejected here | Why |
| --- | --- | --- | --- |
| Row ingestion from Kafka | Kafka connector, Snowpipe Streaming | Snowpipe file mode | Seconds, no stage housekeeping |
| Raw structure | `RECORD_CONTENT`, `RECORD_METADATA` as `VARIANT` | Schematization | Drift stays in staging |
| Connector identity | `TYPE = SERVICE` user, key-pair | Personal user | Least privilege, no password, rotatable |
| Change capture for staging | Append-only stream on raw | Timestamp watermark on `CreateTime` | Exact, transactional consumption |
| Live view | View over RAW with time filter | Dynamic table with 1-minute lag | No warehouse kept awake; honest "not deduplicated" semantics |
| Exactly-once evidence | Offset integrity view | Trust | Measurable proof per partition |

## Data Model

```mermaid
erDiagram
    WIKI_RECENTCHANGE_RAW ||--o{ WIKI_CHANGE : "deduplicated into"
    WIKI_CHANGE ||--o{ EDITS_PER_MINUTE : "aggregated into"

    WIKI_RECENTCHANGE_RAW {
        VARIANT RECORD_METADATA
        VARIANT RECORD_CONTENT
    }
    WIKI_CHANGE {
        STRING EVENT_ID PK
        TIMESTAMP_TZ EVENT_TS
        STRING WIKI
        STRING CHANGE_TYPE
        BOOLEAN IS_BOT
        NUMBER KAFKA_PARTITION
        NUMBER KAFKA_OFFSET
        TIMESTAMP_LTZ KAFKA_TS
        TIMESTAMP_LTZ CONNECTOR_PUSH_TS
        TIMESTAMP_LTZ STAGED_AT
    }
    EDITS_PER_MINUTE {
        TIMESTAMP_TZ MINUTE_TS
        STRING WIKI
        STRING CHANGE_TYPE
        BOOLEAN IS_BOT
        NUMBER CHANGE_COUNT
        NUMBER BYTES_DELTA
    }
```

`RECORD_METADATA` contains at least `topic`, `partition`, `offset`, `CreateTime` (Kafka timestamp in milliseconds), and `key`; recent connector versions add `SnowflakeConnectorPushTime`. Inspect a few rows to see what your version writes.

## What This Project Teaches About Snowflake

- Snowpipe Streaming is **row-based**: no files, no pipes, no stages; freshness in seconds.
- **Exactly-once is per offset**, built on channels and offset tokens; business deduplication is still yours.
- **Table ownership matters** for streaming targets and for streams on them.
- **Service users** are the right identity for integrations.
- The **cost profile shifts** from per-file to per-active-client and volume; measure it against P04.
