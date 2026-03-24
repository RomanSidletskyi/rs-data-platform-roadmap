# Architecture Note

## Target Flow

1. source-near datasets are standardized into reusable conformed layers
2. Spark joins those layers at a clearly defined customer-centric grain
3. output contracts are documented for downstream analysts and BI models
4. rebuild boundaries and freshness rules are kept explicit

## Core Design Questions

- what is one row in the mart?
- which measures should stay event-level instead of entering the mart?
- how should history and late corrections affect the model?
- which consumer use cases justify the mart and which do not?