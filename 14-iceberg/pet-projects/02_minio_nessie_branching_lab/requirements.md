# Requirements

## Functional Requirements

- one MinIO-backed warehouse path
- one Nessie-backed catalog design
- one branch-aware Spark workflow
- one explicit promotion rule from development branch to main

## Non-Functional Requirements

- keep the stack realistic for a small homelab or internal lab
- make branch governance explicit
- avoid designs that require humans to infer publish state from raw storage paths

## Architecture Requirement

The design must explain why a separate control plane is worth the complexity in this case.