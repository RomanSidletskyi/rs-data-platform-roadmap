# Solution

Compute questions:

- is the workload exploratory, production ETL, or analytics serving?
- does it need interactive state or isolated scheduled execution?
- who owns the cost and reliability target?

Governance rollout order:

1. define domains and environments
2. map catalogs and schemas
3. choose tables, volumes, and external locations
4. assign permissions intentionally

Cost signals:

- idle interactive compute
- oversized warehouses
- repeated full rebuilds
- mixed exploratory and production traffic
- job duration growth without business justification