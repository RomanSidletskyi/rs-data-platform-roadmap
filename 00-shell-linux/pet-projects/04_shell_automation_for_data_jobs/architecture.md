# Architecture

## Components

- job entrypoint
- logs
- archive directory
- summary report

## Data Flow

1. run one job
2. capture logs
3. archive outputs
4. report success or failure

## Trade-Offs

- shell is strong for orchestration glue
- heavy transformation logic should stay outside shell