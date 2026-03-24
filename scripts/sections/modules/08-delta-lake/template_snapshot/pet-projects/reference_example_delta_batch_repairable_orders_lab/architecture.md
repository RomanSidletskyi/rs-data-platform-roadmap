# Architecture

## Components

- bronze raw orders table
- silver cleaned orders table
- gold aggregated sales output
- bounded repair path for one affected date window

## Data Flow

1. raw order files land in bronze
2. cleaned data is written to silver with deterministic rules
3. gold aggregates are built from silver
4. if a defect is found, only the affected period is repaired and re-published

## Why This Is A Strong Reference

It shows that Delta Lake operations are designed around safe recovery boundaries, not only around successful first writes.
