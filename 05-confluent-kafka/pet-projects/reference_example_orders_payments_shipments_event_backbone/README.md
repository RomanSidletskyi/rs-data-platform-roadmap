# Reference Example - Orders Payments Shipments Event Backbone

This folder contains a ready implementation kept as a reference example.

Its purpose is:

- self-checking after attempting the guided project
- comparing how multi-domain ownership can stay explicit while downstream consumers still correlate a full order journey
- preserving a reusable event-backbone pattern for future platform modules

You should attempt the guided project first:

- `05-confluent-kafka/pet-projects/03_orders_payments_shipments_event_backbone`

Only after that should you compare your implementation with this reference example.

## What This Reference Example Demonstrates

- three bounded contexts publishing facts into one platform-level event backbone
- downstream order-journey summarization without collapsing domains into one source topic
- simple contract validation that catches ownership and schema-shape problems early
- fixture-driven validation for both projection logic and contract-review output

## Folder Overview

- `.env.example` for local topic and contract placeholders
- `src/build_order_journey_summary.py` for downstream cross-domain summarization
- `src/check_event_backbone_contracts.py` for simple ownership and contract validation
- `data/sample_backbone_events.jsonl` as replayable valid multi-domain input
- `data/sample_bad_backbone_events.jsonl` as intentionally broken review input
- `tests/fixture_expected_order_journey_summary.json` and `tests/fixture_expected_contract_check.txt` as deterministic expectations
- `tests/verify_backbone_assets.sh` for smoke validation
- `architecture.md` for target system reasoning

## How To Run

Build the downstream order journey summary:

```bash
python3 src/build_order_journey_summary.py data/sample_backbone_events.jsonl
```

Run the contract check against bad sample events:

```bash
python3 src/check_event_backbone_contracts.py data/sample_bad_backbone_events.jsonl
```

Run the smoke check:

```bash
/bin/sh tests/verify_backbone_assets.sh
```

## What To Compare

When comparing this reference example with your own implementation, focus on:

- whether your design keeps source-domain ownership separate from downstream correlation logic
- whether your contracts make `order_id` the cross-domain business key without pretending all domains are one schema
- whether your validation checks semantic ownership mistakes rather than only syntax