# Architecture

## Components

- one curated internal path for engineering transformations
- one publish path for official consumer access
- several consuming engines with different access expectations
- one schema-governance review before changing published structure

## Data Flow

1. engineering jobs build internal curated outputs
2. published consumer data is materialized into a stable ADLS path
3. Databricks, SQL, and BI consumers read the published interface
4. schema-change review happens before the publish contract moves

## Trade-Offs

- internal curated paths are flexible but unsafe as public contracts
- a publish layer adds discipline and duplication cost
- multi-engine consumption increases the value of stable paths and clear ownership
