# 1. Problem

## Business Context

A developer-relations team tracks open-source activity: which repositories gain stars, how many pull requests get merged, how much of the activity is bots. Today an engineer downloads GH Archive files by hand when someone asks a question, so history has holes and nobody can say which numbers came from which files. The team wants:
- every hour of GH Archive loaded into Snowflake, with the gaps visible
- daily facts per repository and per event type, never more than two hours behind for the current day's hours
- any past period reloadable with one command, with the same result as the original load
- events older than a month kept cheaply outside the warehouse but still queryable
- the scheduler outside Snowflake, because the platform team already runs Airflow for other systems

## Source Data

[GH Archive](https://www.gharchive.org) publishes one gzip file per UTC hour at `https://data.gharchive.org/YYYY-MM-DD-H.json.gz` (hour without a leading zero). Each line is one public GitHub event: `id`, `type`, `actor`, `repo`, `org`, `payload`, `public`, `created_at`.

Measured on the live source on 2026-11-10 (hour 15 UTC of each day):

| Hour | Compressed | Events | Push events | Pull request payload | What changed |
| --- | --- | --- | --- | --- | --- |
| 2024-11-09 | 94 MB | 213,174 | 125,090, with commits and size | 48 fields, `merged` flag | Baseline |
| 2025-10-01 | 105 MB | 167,725 | 96,200, with commits and size | 48 fields | Last full-format day sampled |
| 2025-11-01 | 33 MB | 145,888 | 102,317, no commits or size | 5 fields: `base`, `head`, `id`, `number`, `url` | GitHub trimmed payloads; a closed pull request no longer says whether it was merged |
| 2026-01-05 | 37 MB | 153,215 | 107,569 | 5 fields | New action `merged` on pull request events |
| 2026-10-01 | 19 MB | 85,569 | 64,617 | 5 fields | Volume falling |
| 2026-11-09 | 2.5 MB | 3,470 | 0 | 5 fields | No push, create, or delete events at all |

Other facts from the same samples:

| Fact | Value | Consequence |
| --- | --- | --- |
| Publication delay | About 5 minutes after the hour ends; the current hour answers 404 | A sensor waits on 404 and fails on anything else |
| Default Python User-Agent | 403 from Cloudflare | Send a descriptive User-Agent |
| Duplicate event ids inside one hour | 0 | Deduplicate anyway; check across hours |
| Events with `created_at` outside the file hour | 0 | The file hour is a safe partition key |
| Bot share (`login` ending in `[bot]`) | 26 percent of events in November 2026 | Separate human and bot activity |
| One full-format day | About 2.4 GB gzip, 4 million events | A backfill of months is a volume project of its own |

```text
One event (trimmed format, November 2026)
{"id":"19563463331","type":"PullRequestEvent","actor":{"id":338223843,"login":"..."},
 "repo":{"id":1423064492,"name":"owner/repo"},"payload":{"action":"merged","number":152,
 "pull_request":{"url":"...","id":5225961048,"number":152,"head":{...},"base":{...}}},
 "public":true,"created_at":"2026-11-09T15:00:03Z"}
```

## Functional Requirements

| ID | Requirement |
| --- | --- |
| F1 | Land every hour file unchanged in cloud storage; one object per hour, never partial |
| F2 | Load each hour into RAW with file name and row number; reloading an hour replaces it |
| F3 | One typed STG row per event id, with a pull request outcome that is `merged`, `closed_unmerged`, or explicitly `closed_unknown` |
| F4 | Daily facts per repository (stars, forks, pushes, pull requests opened and merged, issues, releases, human actors, bot events) and per event type |
| F5 | Archive each complete day as Parquet, verified by reading it back, with a manifest |
| F6 | Old days remain queryable from the archive without loading them back |
| F7 | A daily signal when the event type mix or a field the marts depend on changes sharply |

## Non-Functional Requirements

| ID | Requirement |
| --- | --- |
| N1 | Any task can be retried, cleared, or backfilled without duplicates or manual cleanup |
| N2 | A backfill cannot overload GH Archive, the network, or the warehouse: concurrency is bounded per resource |
| N3 | The orchestrator authenticates with a key pair and can only call procedures and read logs |
| N4 | Hot data in Snowflake is limited to 30 days; nothing is deleted before its archive is verified |
| N5 | Credits per hour and per backfilled day can be read per Airflow task |
| N6 | The pipeline runs without a cloud account (internal stages) and with Azure or AWS, with the same SQL |

## Out of Scope

- Streaming ingestion: P04, P14, and P15 compare three ways to do it
- The GitHub REST API for repository metadata such as languages or topics: rate-limited and keyed
- A hosted Airflow (Astronomer, Amazon MWAA, Apache Airflow jobs in Microsoft Fabric): discussed in [04](04_alternative_stacks.md), not built
