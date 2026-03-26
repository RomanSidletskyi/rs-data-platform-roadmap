# Architecture Notes

## Project

`07_kafka_databricks_powerbi`

## Intended System Shape

Mixed-latency analytical platform:

    Kafka -> Raw Landing -> Stream / Batch Processing -> Curated Marts -> Power BI

## Main Responsibilities

- low-latency ingestion
- raw history preservation
- curated reporting outputs
- separation between operational freshness and business-trust serving

## Key Design Questions

- which paths truly need low latency
- where does curated reporting diverge from live operational views
- how does replay or rebuild work after downstream bugs

## First Risks To Watch

- everything treated as real time whether needed or not
- dashboards consume unstable streaming outputs directly
- no clear distinction between operational projection and curated truth

## Candidate ADRs

- `Use Hybrid Streaming And Batch For Mixed-Latency Analytics`
- `Serve BI From Curated Outputs Rather Than Live Stream Projections`

## Review Pairing

- `../../docs/architecture/reviews/streaming-platform-review-checklist.md`
- `../../docs/architecture/reviews/lakehouse-serving-review-checklist.md`
- `../../docs/architecture/adr/template.md`