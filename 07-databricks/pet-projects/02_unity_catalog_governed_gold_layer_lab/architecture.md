# Architecture

## Components

- Unity Catalog catalog and schema
- curated gold table
- SQL warehouse for consumption
- analyst and engineer permission groups

## Data Flow

1. engineering workflow publishes gold data
2. Unity Catalog governs access to the gold object
3. analysts query through SQL warehouse
4. downstream BI uses only the governed consumer-facing layer

## Trade-Offs

- stronger governance reduces accidental misuse
- more explicit contracts improve BI trust
- environment separation adds discipline but also deployment overhead