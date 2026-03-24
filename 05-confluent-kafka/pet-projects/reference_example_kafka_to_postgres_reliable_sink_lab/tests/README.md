# Test Assets

Provided fixtures:

- `fixture_expected_valid_upsert_record.json`
- `fixture_expected_dlq_record.json`
- `verify_sink_decisions.sh` for a fixture-driven sink validation smoke check

Suggested checks:

- sink write success path
- retry behavior on transient DB failures
- DLQ behavior on permanent validation failures
- idempotent handling of repeated `event_id` values