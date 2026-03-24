# Requirements

## Functional Requirements

- write correct and readable SQL
- support KPI outputs
- support customer analytics
- support product analytics
- support funnel analysis
- support retention analysis
- document assumptions

## Non-Functional Requirements

- readable query structure
- stable grain definitions
- deterministic deduplication logic
- reusable naming conventions
- outputs that are easy to validate

## Engineering Standards

Recommended practices:

- use CTEs for readability
- define filters explicitly
- separate intermediate logic from final outputs
- comment non-obvious business rules
- make output column names stable and meaningful

## Validation Expectations

Each analytical output should be easy to verify with:

- sample row checks
- aggregate reconciliation
- business definition review
