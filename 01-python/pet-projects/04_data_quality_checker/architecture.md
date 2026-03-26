# Architecture - 04 Data Quality Checker

## Components

- input dataset
- dataset reader
- quality rule engine or rule functions
- metrics and failure report layer

## Data Flow

1. read dataset
2. validate structural assumptions
3. execute quality checks
4. collect failures and summary metrics
5. write report output

## Trade-Offs

- more checks improve trust but slow iteration
- too many rules without prioritization make reports noisy

## What Would Change In Production

- rule configuration by environment
- alerting thresholds
- integration with orchestration or CI gates