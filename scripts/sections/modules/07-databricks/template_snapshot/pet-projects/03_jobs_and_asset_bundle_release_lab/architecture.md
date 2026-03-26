# Architecture

## Components

- source repository
- Databricks asset or job definition
- lower environment deployment target
- production deployment target
- release approval path

## Data Flow

1. code and job config are reviewed in source control
2. lower environment validates the change
3. deployable assets are promoted intentionally
4. production jobs run from versioned state

## Trade-Offs

- more explicit deployment flow reduces UI convenience
- reproducibility improves incident recovery and auditability
- environment-specific config must be managed carefully