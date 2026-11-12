# Architecture Brief: Reliable File Ingestion

## Candidate Flow

```text
Source export -> object storage -> manifest and notification
             -> Snowflake stage -> raw load history -> validation/quarantine
             -> typed curated table -> freshness/completeness status
```

Figure of the candidate flow (explanatory; the ingestion pattern is still your decision):

```mermaid
flowchart LR
    SRC["Source export"] --> OBJ["Object storage<br/>retained for recovery window"]
    OBJ --> MAN["Manifest and<br/>notification"]
    OBJ --> STG["Snowflake stage"]
    MAN --> CTRL["Batch control<br/>expected vs loaded"]
    STG --> LOAD["Load step<br/>COPY INTO or Snowpipe?"]
    LOAD --> RAW["Raw table<br/>plus load history"]
    LOAD --> QUAR["Quarantine<br/>rejected rows or files"]
    RAW --> VAL{"Validation"}
    VAL -- pass --> CUR["Typed curated table"]
    VAL -- fail --> QUAR
    CUR --> STAT["Freshness and<br/>completeness status"]
    CTRL --> STAT
```

## Reliability Contract

For every batch, record source, batch ID, file identity, schema version, expected count, arrival time, load result, rejected rows, target batch, and replay attempts. Preserve source files for a defined recovery window. Make the curated transformation deterministic for a given input batch.

## Pattern Selection

Scheduled `COPY INTO` is a reasonable starting point when daily files and a daily freshness target are acceptable. Snowpipe may fit supported continuous file arrivals. Lower-latency row delivery may require Snowpipe Streaming or a broader event-ingestion platform. The final choice depends on measured volume, delivery guarantees, ordering, replay, and regional availability.

## Failure Cases

| Failure | Expected response |
| --- | --- |
| Missing file | Mark delivery incomplete and alert source owner |
| Malformed file | Quarantine or fail visibly; retain evidence |
| Duplicate delivery | Detect by stable delivery/source identifiers and apply replay rule |
| Corrected file | Version the delivery and document replacement semantics |
| Partial transform | Retry deterministically and reconcile target counts |

Example replay path to adapt (batch ID is illustrative). It shows two rows of the table above: a partial transform retry and a resent delivery.

```mermaid
sequenceDiagram
    participant SRC as Source
    participant STO as Storage
    participant CTL as BatchControl
    participant RAW as RawTable
    participant CUR as CuratedTable
    SRC->>STO: deliver batch B42 files and manifest
    STO->>RAW: load files with file name and batch ID
    RAW->>CTL: record row counts and rejects
    CTL->>CTL: loaded plus rejected equals expected
    RAW->>CUR: transform batch B42
    Note over RAW,CUR: transform fails midway
    CTL->>CUR: retry as delete-insert or MERGE scoped to B42
    CUR-->>CTL: target counts reconcile
    SRC->>STO: resend B42 under a new file name
    STO->>CTL: same batch and record IDs detected
    CTL-->>SRC: replay rule applied, no double count
```

The retry is safe because it is scoped by batch identity, not by "whatever is new in the stage".

## Review

Confirm who owns source completeness, cloud permissions, load monitoring, quarantine resolution, and consumer communication. Measure end-to-end freshness rather than only load-command duration.