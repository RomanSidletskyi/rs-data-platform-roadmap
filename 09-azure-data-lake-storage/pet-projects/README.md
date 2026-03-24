# Azure Data Lake Storage Pet Projects

These projects simulate ADLS work as storage-platform design rather than Azure portal clicking.

They combine:

- namespace and boundary design
- identity and ACL reasoning
- replay, retention, and cleanup trade-offs
- publish contracts for downstream consumers
- storage decisions across several compute or analytics engines

## Project Map

1. `01_adls_namespace_and_landing_zone_lab`
2. `02_adls_identity_acl_and_publish_boundary_lab`
3. `03_adls_replay_lifecycle_and_cleanup_lab`
4. `04_adls_multi_engine_contracts_and_consumption_lab`

## Sibling Reference Examples

- `reference_example_adls_namespace_and_landing_zone_lab`
- `reference_example_adls_multi_engine_contracts_and_consumption_lab`

## Recommended Project Sequence

1. `01_adls_namespace_and_landing_zone_lab`
2. `02_adls_identity_acl_and_publish_boundary_lab`
3. `03_adls_replay_lifecycle_and_cleanup_lab`
4. `04_adls_multi_engine_contracts_and_consumption_lab`

## Expected Outcome

By the end of these labs, the learner should be able to design ADLS storage as a governed platform boundary with explicit namespace, access, lifecycle, and consumer decisions.

## Practical Starter Assets

Each guided lab includes small local starter assets rather than instructions alone:

- one config template with storage, ownership, or lifecycle decisions
- one small JSON or JSONL dataset representing storage objects or access requirements
- lightweight Python helpers for boundary checks, plan generation, and local previews
- one runnable local pipeline skeleton per guided lab
- one `artifacts/` directory per guided lab for materialized local outputs
- one `run_lab.sh` launcher per guided lab
- one SQL or policy-style template that expresses the intended downstream contract
- expected outputs and a local `tests/verify_*.sh` smoke check

This keeps the labs guided-first while still giving the learner something concrete to inspect, run, and extend.
