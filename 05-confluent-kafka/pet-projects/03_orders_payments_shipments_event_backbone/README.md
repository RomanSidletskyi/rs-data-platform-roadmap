# 03 Orders Payments Shipments Event Backbone

## Project Goal

Model a multi-domain event backbone for e-commerce order flow.

## Scenario

Several services publish events about one customer journey:

- orders
- payments
- shipments

The platform must keep domain ownership clear while still allowing downstream consumers to build end-to-end visibility.

## Project Type

This folder is a guided project, not a ready solution.

The starter assets here help you reason about domain boundaries, correlation keys, and downstream projections before you wire a real Kafka runtime around them.

If you want a ready implementation afterwards for comparison, use the separate sibling reference project:

- `05-confluent-kafka/pet-projects/reference_example_orders_payments_shipments_event_backbone`

## Expected Deliverables

- topic map across bounded contexts
- event contracts for at least two domains
- explanation of ownership boundaries
- consumer-group design for at least two downstream use cases
- note about schema evolution and replay impact across teams

## Starter Assets Already Provided

- `.env.example`
- `src/build_order_journey_summary.py`
- `src/check_event_backbone_contracts.py`
- `data/sample_backbone_events.jsonl`
- `data/sample_bad_backbone_events.jsonl`
- `tests/fixture_expected_order_journey_summary.json`
- `tests/fixture_expected_contract_check.txt`
- `src/README.md`
- `data/README.md`
- `tests/README.md`
- `config/README.md`
- `docker/README.md`
- `architecture.md`

## Definition Of Done

The lab demonstrates Kafka as an event backbone rather than a generic message bucket and makes multi-team contract ownership explicit.