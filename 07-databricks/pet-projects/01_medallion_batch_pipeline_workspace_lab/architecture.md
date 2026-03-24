# Architecture

## Components

- raw order landing zone
- Databricks bronze task
- Databricks silver task
- Databricks gold publish task
- SQL or downstream consumer over gold output

## Data Flow

1. raw landed files are ingested into bronze
2. silver normalizes schema and quality boundaries
3. gold publishes a business-facing aggregate
4. downstream consumers query only the governed gold output

## Trade-Offs

- notebook exploration is useful early
- production jobs should be isolated from personal workspace state
- bronze should preserve traceability while gold should optimize consumption