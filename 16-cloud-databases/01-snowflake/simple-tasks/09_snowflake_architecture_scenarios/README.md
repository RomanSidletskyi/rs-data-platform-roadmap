# Task Set 09: Snowflake Architecture Scenarios

These twelve account-free scenarios turn Snowflake features into design and troubleshooting practice. The situations are intentionally realistic but incomplete: state any additional assumptions you need. There is no single correct product choice independent of requirements.

For every answer, follow this sequence:

1. State the problem and constraints.
2. Identify the likely cause or decision boundary.
3. Compare viable options.
4. Recommend an approach and explain why.
5. Record trade-offs, risks, and the evidence you would collect.

Do the scenarios before opening `solution.md`. The solutions describe strong reasoning and alternatives, not an answer key that forbids other defensible designs.

## Recommended Reading

- [Semi-structured data and performance](../../learning-materials/deep-dives/semi_structured_performance.md)
- [Query performance](../../learning-materials/deep-dives/05_query_performance.md)
- [Iceberg and external tables](../../learning-materials/deep-dives/iceberg-and-external-tables/README.md)
- [Incremental processing](../../learning-materials/deep-dives/04_incremental_processing.md)
- [Platform architecture](../../learning-materials/architecture/01_platform_account_cloud_region.md)
- [Availability and recovery](../../learning-materials/architecture/05_availability_and_recovery.md)

## Performance and Data Shape

### Scenario 1: Filters on a Nested Event Field Scan Too Much

A 2 TB event table stores `event_ts` and `customer_id` only inside a `VARIANT` payload. A daily report filters on `payload:event_ts`, but scans a large fraction of the table. The report runs every hour and joins the extracted customer ID to a customer dimension.

Propose a diagnosis and a staged improvement. State which fields you would promote to typed columns, what evidence you would inspect, and when clustering or another optimization would be justified.

### Scenario 2: `FLATTEN` Produces an Unexpected Row Explosion

A query expands `items`, then nested `discounts`, then joins customer and product dimensions. One source event can contain dozens of items and several discounts per item. The result has millions more rows than expected and spills during aggregation.

Identify the grain at each step. Propose a safer query shape or staging strategy, and explain how you would verify that the optimized result preserves business totals.

### Scenario 3: External Table or Native Serving Table?

A partner drops Parquet files into object storage. Analysts need same-day profiling, but the validated dataset becomes the source for a heavily used finance dashboard with repeated joins and a strict completeness check.

Design the boundary between file discovery and the durable serving model. Compare external tables, `COPY INTO` to native tables, and an Iceberg publish only if a real interoperability requirement exists.

## Table and Catalog Decisions

### Scenario 4: Snowflake and Spark Need the Same Curated Table

Snowflake owns transformation and publishing. A Spark ML team must read the same curated 5 TB dataset every hour. The teams want one table contract rather than two independently produced copies.

Compare a native Snowflake table with Snowflake-managed Iceberg. State who owns metadata, where storage can live, what Spark access path must be configured, and the operating cost of the open-table boundary.

### Scenario 5: Spark and Glue Already Own the Iceberg Catalog

Several engines already read and write Iceberg tables through AWS Glue. Snowflake is being added for SQL analytics, and the platform team does not want two competing metadata authorities.

Recommend a Snowflake participation pattern. Explain the catalog integration, refresh or commit boundary, data access, ownership split, and which write-support or catalog-compatibility details must be verified before implementation.

### Scenario 6: Open Catalog or Horizon Catalog?

A new Snowflake customer wants to make Snowflake-managed Iceberg tables available to an external query engine. Another team already has a Snowflake Open Catalog account and uses it for shared Iceberg tables.

Compare the two catalog paths by authority, direction of access, operational responsibility, and current onboarding availability. Recommend a path for the new customer and describe when the existing Open Catalog deployment may remain appropriate.

### Scenario 7: New Files Exist but External-Table Results Look Stale

New files are visible in object storage, but queries against an external table do not return their rows. Automatic refresh was recently reconfigured, and the data consumer also reports that a query sometimes returns its previous result.

Separate file visibility, external-table metadata registration, and persisted query results. Name the history or metadata checks and refresh action you would use, then explain how to restore a reliable freshness signal.

## Processing and Operations

### Scenario 8: Choose a Freshness and Orchestration Model

A SQL transformation should update a reporting table within ten minutes. A second workflow waits for files, calls an external API, performs a Snowflake merge, and notifies a downstream service. The team is considering dynamic tables, streams and tasks, dbt, and Airflow.

Choose a pattern for each workflow. Define which system owns schedules, retries, freshness, and incident state, and explain why one mechanism need not own both workflows.

### Scenario 9: Shared Warehouse Queues and Spend Rises

BI queries, file loading, and a nightly transformation share one warehouse. At peak time, BI queues; overnight, the warehouse stays active longer than expected. Increasing its size shortens some runs but raises spend.

Separate queueing from query execution as causes. Propose workload boundaries, suspend/scaling controls, and a measurement plan. Explain what you would not change until you have Query Profile and usage evidence.

### Scenario 10: Choose a File and Partition Layout

An external table reads many tiny Parquet files under inconsistent folders. A proposed Iceberg version partitions by `customer_id`, `event_type`, year, month, day, and hour. Consumers filter mostly by event date and occasionally by customer.

Recommend a practical first layout and explain the risks of tiny files, unstable path semantics, and over-partitioning. State what workload evidence would justify a different design.

### Scenario 11: A Multi-Engine Schema Change Breaks Consumers

Snowflake and Spark read the same Iceberg contract. The producer wants to rename a field, widen a decimal, and add a nested attribute in one release. One consumer deploys monthly; another reads columns by ordinal position.

Create a compatibility and rollout plan. Identify which changes are safe only under tested conditions, what must be versioned, and how to observe consumer adoption before removing the old contract.

### Scenario 12: Regional Recovery for an Iceberg Data Product

A regulated data product has a 15-minute RPO and a two-hour RTO. Snowflake runs in one region; the external Iceberg data is in cloud storage, and a Spark consumer uses a remote catalog. The team assumes replicating the Snowflake account is enough.

Challenge that assumption. List the data, metadata/catalog, identity, network, application, and consumer components needed for recovery. Propose a test that can demonstrate the objectives and identify cross-region cost or residency trade-offs.

## Submission Checklist

- Your recommendation follows from stated constraints rather than feature popularity.
- At least one viable alternative is compared.
- Performance and cost claims are tied to measurable evidence.
- Metadata authority and operational ownership are explicit for Iceberg scenarios.
- Recovery and data-contract changes include validation and rollback or forward-fix behavior.