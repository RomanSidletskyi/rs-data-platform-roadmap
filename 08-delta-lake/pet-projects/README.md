# Delta Lake Pet Projects

These projects should simulate production-shaped Delta Lake work rather than isolated syntax drills.

They combine:

- table design
- merge and CDC reasoning
- recovery and retention thinking
- consumer contracts
- schema change and governance trade-offs

## Project Map

1. `01_delta_batch_repairable_orders_lab`
2. `02_delta_cdc_customer_state_lab`
3. `03_delta_quality_recovery_and_retention_lab`
4. `04_delta_serving_contracts_and_schema_change_lab`

## Sibling Reference Examples

- `reference_example_delta_batch_repairable_orders_lab`
- `reference_example_delta_serving_contracts_and_schema_change_lab`

## Recommended Project Sequence

1. `01_delta_batch_repairable_orders_lab`
2. `02_delta_cdc_customer_state_lab`
3. `03_delta_quality_recovery_and_retention_lab`
4. `04_delta_serving_contracts_and_schema_change_lab`

## Expected Outcome

By the end of these labs, the learner should be able to reason about Delta Lake not only as table syntax but as a reliability, recovery, and contract layer inside a lakehouse platform.

## Practical Starter Assets

Each guided lab now includes small but real starter assets, not only instructions:

- sample JSONL datasets for valid and failure-path scenarios
- one config template describing keys, contracts, or recovery rules
- lightweight Python helpers for local validation, output preview, and starter execution plans
- one runnable local pipeline skeleton per guided lab that reads config and data together
- one `artifacts/` directory per guided lab for materialized local outputs
- one `run_lab.sh` launcher per guided lab for a one-command local run
- one SQL template showing the intended Delta write or serving pattern
- expected outputs and a local `tests/verify_*.sh` smoke check

This keeps the labs guided-first while still giving the learner something concrete to run, inspect, and extend.
