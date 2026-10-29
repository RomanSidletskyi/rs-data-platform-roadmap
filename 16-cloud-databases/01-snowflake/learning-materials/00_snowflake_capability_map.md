# Snowflake Capability Map

This is the module's capability inventory and navigation page. It is designed both for a first-time learner and for someone who already knows another cloud database and wants to discover Snowflake's concepts and features.

Use the **Depth** column to choose the smallest useful next step:

- **Quick reference:** concise purpose, syntax, example, and caveat.
- **Detailed guide:** behavior, worked examples, cases, limitations, and alternatives.
- **Architecture:** placement, decision criteria, consequences, trade-offs, and operations.

Not every capability needs all three. Follow the links that exist and expand a topic when a question arises. Product names and availability can change; verify edition, cloud, region, account, and release requirements in current Snowflake documentation before implementation.

## 1. Platform and Architecture

| Capability | What it is / typical use | Prerequisites | Depth and navigation | Key trade-off / availability |
| --- | --- | --- | --- | --- |
| Organization and accounts | Administrative boundary for accounts, identity, policies, and regional deployment | Basic cloud and identity concepts | [Architecture: accounts, cloud, and region](architecture/01_platform_account_cloud_region.md) | Stronger isolation adds administration and deployment coordination |
| Cloud and region | Provider and geographic location associated with an account; affects residency, latency, integrations, and cross-region design | Account model | [Architecture: accounts, cloud, and region](architecture/01_platform_account_cloud_region.md) | Feature and replication support varies by provider, region, and release |
| Storage, compute, cloud services | Logical separation of durable data, execution resources, and coordination services | None | [Architecture: platform model](architecture/01_platform_account_cloud_region.md) | Managed service reduces infrastructure work, not governance or cost responsibility |
| Virtual warehouses | Customer-managed compute for queries and supported loading workloads | SQL and account objects | [Quick reference: warehouses](reference/03_loading_and_operations.md); [Architecture: workload and cost](architecture/02_compute_workload_cost.md) | Isolation improves workload control but can fragment spend and operations |
| Serverless compute | Provider-managed compute for selected Snowflake capabilities | Understand workload and cost attribution | [Architecture: workload and cost](architecture/02_compute_workload_cost.md) | Less sizing work, but eligibility and billing are feature-specific |
| Editions and feature availability | Service tiers and account-level applicability of selected capabilities | Account and region concepts | [Architecture: accounts, cloud, and region](architecture/01_platform_account_cloud_region.md) | Confirm current feature matrix; do not assume parity across accounts |

## 2. SQL, Types, and Functions

| Capability | What it is / typical use | Prerequisites | Depth and navigation | Key trade-off / availability |
| --- | --- | --- | --- | --- |
| Snowflake SQL and session context | Query and DDL syntax plus active role, warehouse, database, and schema | Basic SQL | [Quick reference: SQL functions](reference/01_sql_dates_and_semistructured.md); [Learning paths](01_learning_paths.md) | Implicit context is convenient but can make deployments resolve the wrong objects |
| Date and time types | Date/time values and timezone-aware representation | Basic SQL types | [Quick reference: dates and times](reference/01_sql_dates_and_semistructured.md) | Choosing the wrong timestamp type can shift or misinterpret event times |
| Semi-structured types | `VARIANT`, `OBJECT`, and `ARRAY` for flexible payloads | JSON basics | [Quick reference](reference/01_sql_dates_and_semistructured.md); [Detailed guide](deep-dives/01_semi_structured_data.md); [Snowflake semi-structured performance](deep-dives/semi_structured_performance.md) | Extraction and pruning depend on data shape and metadata eligibility; profile before changing storage |
| Scalar, conditional, and conversion functions | Common functions for transformation and safe casting | Basic SQL | [Quick reference: SQL functions](reference/01_sql_dates_and_semistructured.md) | Implicit casts and null behavior can create subtle correctness bugs |
| Window and analytical functions | Ranking, running totals, and row comparisons | Grouping and joins | [Quick reference: SQL functions](reference/01_sql_dates_and_semistructured.md) | Large partitions and incorrect window frames can increase cost or change results |

## 3. Databases, Objects, and Storage

| Capability | What it is / typical use | Prerequisites | Depth and navigation | Key trade-off / availability |
| --- | --- | --- | --- | --- |
| Databases, schemas, and namespaces | Organize objects, ownership, access, and lifecycle | Account basics | [Quick reference: objects](reference/02_objects_and_table_types.md); [Architecture: platform model](architecture/01_platform_account_cloud_region.md) | Naming is not security; boundaries must align with grants and ownership |
| Permanent, transient, and temporary tables | Tables with different retention, recovery, and session/lifecycle behavior | Basic SQL and retention concepts | [Quick reference: table types](reference/02_objects_and_table_types.md) | Lower retention or temporary scope can reduce recovery options |
| Views and secure views | Reusable query interfaces; secure views also support controlled data exposure | Grants and query definitions | [Quick reference](reference/02_objects_and_table_types.md); [Secure Views detailed guide](deep-dives/02_secure_views.md) | Secure views are not a substitute for complete role and policy design |
| Materialized views | Persisted query results maintained for supported workloads | Query patterns and cost | [Quick reference: objects](reference/02_objects_and_table_types.md) | Maintenance cost and eligibility can outweigh query savings |
| Micro-partitions and metadata | Internal storage units and metadata used for pruning | Query filters and table layout | [Deep dive: performance](deep-dives/05_query_performance.md) | Automatic storage does not guarantee every query prunes efficiently |
| Clustering | Co-locates data patterns to improve pruning on selected large tables | Query Profile and partition knowledge | [Deep dive: performance](deep-dives/05_query_performance.md); [Architecture: workload and cost](architecture/02_compute_workload_cost.md) | Maintenance compute and storage costs; only justified by workload evidence |
| Iceberg and external tables | Work with data whose storage or table metadata is outside ordinary managed tables | Object storage and catalog concepts | [Architecture: integration boundaries](architecture/06_sharing_and_interoperability.md) | Interoperability adds metadata, permissions, and consistency boundaries |

## 4. Ingestion and Data Movement

| Capability | What it is / typical use | Prerequisites | Depth and navigation | Key trade-off / availability |
| --- | --- | --- | --- | --- |
| Internal and external stages | Named locations for loading or unloading files | Cloud object storage concepts | [Quick reference: loading](reference/03_loading_and_operations.md); [Detailed loading guide](deep-dives/03_data_loading_patterns.md) | External access needs secure integrations and explicit cloud permissions |
| File formats | Parsing rules for CSV, JSON, Parquet, and other supported files | Stage and schema concepts | [Quick reference: loading](reference/03_loading_and_operations.md) | Loose parsing can silently accept bad data; strict parsing can block a batch |
| `COPY INTO` | Bulk file ingestion or export | Stages, file formats, load history | [Quick reference](reference/03_loading_and_operations.md); [Detailed loading guide](deep-dives/03_data_loading_patterns.md) | Throughput and simplicity versus latency, reject handling, and replay design |
| Snowpipe | Managed continuous file ingestion pattern | Stage, event notifications, monitoring | [Detailed loading guide](deep-dives/03_data_loading_patterns.md) | Lower operational polling burden, but still needs completeness and cost controls |
| Snowpipe Streaming | Low-latency row-oriented ingestion through supported interfaces | Event and offset semantics | [Detailed loading guide](deep-dives/03_data_loading_patterns.md) | Lower latency can increase operational and producer-side complexity |
| Storage integrations | Managed trust between Snowflake and external cloud storage | IAM and network basics | [Quick reference: loading](reference/03_loading_and_operations.md); [Architecture: security](architecture/04_security_governance.md) | Safer than embedded long-lived credentials, but trust scope must be narrow |
| Unload and data export | Write query or table results to external locations | Stages and file formats | [Quick reference: loading](reference/03_loading_and_operations.md) | Export creates a new data copy with its own access, retention, and audit needs |

## 5. Processing and Application Development

| Capability | What it is / typical use | Prerequisites | Depth and navigation | Key trade-off / availability |
| --- | --- | --- | --- | --- |
| `MERGE` and incremental SQL | Insert/update target rows based on source changes | Keys, deduplication, transaction basics | [Detailed incremental guide](deep-dives/04_incremental_processing.md) | Flexible control, but correctness depends on stable keys and replay semantics |
| Streams | Track change metadata for supported table changes | DML and change-processing concepts | [Quick reference: processing](reference/04_processing_and_recovery.md); [Detailed incremental guide](deep-dives/04_incremental_processing.md) | Consumption/offset behavior must be understood to avoid missed or repeated work |
| Tasks and task graphs | Schedule and connect SQL or procedure execution | SQL, roles, warehouse/serverless compute | [Quick reference: processing](reference/04_processing_and_recovery.md); [Detailed incremental guide](deep-dives/04_incremental_processing.md) | Native orchestration has boundaries for cross-system workflows and observability |
| Dynamic tables | Declarative transformation with a target freshness objective | SQL dependencies and freshness needs | [Detailed incremental guide](deep-dives/04_incremental_processing.md) | Less procedural control; supported query patterns and refresh behavior matter |
| Stored procedures and Snowflake Scripting | Encapsulate procedural logic near data | SQL and execution roles | [Quick reference: processing](reference/04_processing_and_recovery.md) | In-database logic can simplify calls but create platform-specific coupling |
| UDFs and UDTFs | Reusable scalar or table-returning logic | SQL or supported language runtime | [Quick reference: processing](reference/04_processing_and_recovery.md) | Reuse versus debugging, governance, and runtime constraints |
| Snowpark | Develop data processing with supported languages and APIs | Language runtime and deployment basics | [Architecture: integration boundaries](architecture/06_sharing_and_interoperability.md) | Co-located execution versus language, packaging, and operational constraints |
| Notebooks, Streamlit, and container services | Develop data applications and selected workloads in the Snowflake ecosystem | Application and deployment basics | [Capability map: applications and AI](#10-applications-and-ai) | Convenience versus service availability, security, and lifecycle complexity |

## 6. Performance, Concurrency, and Cost

| Capability | What it is / typical use | Prerequisites | Depth and navigation | Key trade-off / availability |
| --- | --- | --- | --- | --- |
| Query History and Query Profile | Inspect execution, scans, operators, queueing, and spill | SQL workload basics | [Deep dive: query performance](deep-dives/05_query_performance.md) | Profiles explain symptoms; tuning still requires workload context |
| Warehouse sizing and scaling | Change compute capacity or concurrency strategy | Virtual warehouses | [Quick reference: operations](reference/03_loading_and_operations.md); [Architecture: workload and cost](architecture/02_compute_workload_cost.md) | Faster or more concurrent work may cost more; sizing is not a substitute for query design |
| Result and local data caches | Reuse prior results or locally available data under eligible conditions | Query behavior | [Deep dive: query performance](deep-dives/05_query_performance.md) | Cache-dependent performance can differ from cold or changed-data runs |
| Search Optimization Service | Improve supported selective lookup patterns | Query profile evidence | [Deep dive: query performance](deep-dives/05_query_performance.md) | Additional service cost and eligibility constraints |
| Resource monitors and budgets | Set usage thresholds, alerts, and guardrails | Cost attribution | [Quick reference: operations](reference/03_loading_and_operations.md); [Architecture: workload and cost](architecture/02_compute_workload_cost.md) | Guardrails do not replace ownership, budgets, and usage review |
| Metering and usage views | Attribute and analyze consumption | Account usage and roles | [Architecture: workload and cost](architecture/02_compute_workload_cost.md) | Attribution quality depends on tagging, naming, and ownership discipline |

## 7. Security, Governance, and Privacy

| Capability | What it is / typical use | Prerequisites | Depth and navigation | Key trade-off / availability |
| --- | --- | --- | --- | --- |
| Users, roles, grants, and ownership | Control authentication and object privileges | Account and object hierarchy | [Quick reference: objects](reference/02_objects_and_table_types.md); [Architecture: security](architecture/04_security_governance.md) | Flexible role hierarchies need clear ownership and periodic review |
| Managed access schemas and future grants | Centralize grant administration and govern future objects | Grant and ownership model | [Architecture: security](architecture/04_security_governance.md) | Central control reduces grant drift but adds deployment coordination |
| Authentication and network controls | Protect human and service access | Identity provider and network concepts | [Architecture: security](architecture/04_security_governance.md) | Strong controls can affect developer access and integration operations |
| Masking and row access policies | Apply column- or row-level data protection | Data classification and roles | [Architecture: security](architecture/04_security_governance.md) | Central policy improves consistency but requires careful testing and observability |
| Tags, classification, lineage, and audit | Discover, classify, trace, and review data use | Ownership and metadata standards | [Architecture: security](architecture/04_security_governance.md) | Metadata is only useful when maintained and linked to operating processes |
| Secrets and external integrations | Connect securely to external services | Identity, IAM, and network basics | [Architecture: security](architecture/04_security_governance.md) | Reduce credential exposure while limiting trust and rotation scope |

## 8. Recovery, Sharing, and Interoperability

| Capability | What it is / typical use | Prerequisites | Depth and navigation | Key trade-off / availability |
| --- | --- | --- | --- | --- |
| Time Travel and `UNDROP` | Query or recover eligible historical object state within retention | Table lifecycle and retention | [Quick reference: recovery](reference/04_processing_and_recovery.md); [Architecture: availability](architecture/05_availability_and_recovery.md) | Retention improves recovery options but has cost and eligibility boundaries |
| Zero-copy cloning | Create a fast logical clone for testing or analysis | Object and grant lifecycle | [Quick reference: recovery](reference/04_processing_and_recovery.md); [Architecture: availability](architecture/05_availability_and_recovery.md) | Clones can expose sensitive data and diverge in storage/cost over time |
| Fail-safe | Provider-managed recovery for eligible data after Time Travel | Recovery concepts | [Architecture: availability](architecture/05_availability_and_recovery.md) | Not a customer-operated backup or general-purpose historical query feature |
| Replication and failover | Replicate supported objects and support continuity across accounts/regions | Account, region, RPO/RTO | [Architecture: availability](architecture/05_availability_and_recovery.md) | Additional cost and operational design; feature support varies |
| Secure Data Sharing and listings | Share governed data without ordinary consumer-managed copies | Roles, objects, provider/consumer model | [Architecture: sharing](architecture/06_sharing_and_interoperability.md) | Reduces copy pipelines but introduces provider/consumer contract and availability dependency |
| Marketplace and reader patterns | Discover, publish, or provide access to data products | Sharing and governance | [Architecture: sharing](architecture/06_sharing_and_interoperability.md) | Distribution convenience versus commercial, support, and lifecycle obligations |
| Clean rooms | Collaborate on governed data analysis under defined controls | Privacy and sharing model | [Architecture: sharing](architecture/06_sharing_and_interoperability.md) | Useful privacy controls do not replace legal, identity, and output review |
| External data and Iceberg interoperability | Work across Snowflake and external storage/catalog ecosystems | Object storage, formats, and catalogs | [Iceberg and External Tables comparison](deep-dives/iceberg-and-external-tables/README.md); [Architecture: sharing](architecture/06_sharing_and_interoperability.md) | Open interoperability versus multi-system metadata, access, and reliability complexity |

## 9. Development and Operations

| Capability | What it is / typical use | Prerequisites | Depth and navigation | Key trade-off / availability |
| --- | --- | --- | --- | --- |
| Snowflake CLI, drivers, connectors, and APIs | Connect tools and applications to accounts | Auth and SQL | [Quick reference: operations](reference/03_loading_and_operations.md) | Standard integrations speed delivery but introduce version and credential management |
| Git integration and CI/CD | Version, test, and promote Snowflake changes | Git and deployment basics | [Architecture: operations](architecture/07_operations_and_lifecycle.md) | Repeatability versus environment and secret-management complexity |
| Terraform and infrastructure as code | Manage supported account resources declaratively | Cloud and IaC basics | [Architecture: operations](architecture/07_operations_and_lifecycle.md) | Drift reduction versus provider coverage and state-management responsibility |
| Monitoring, alerts, and incident response | Detect failures, cost anomalies, and freshness gaps | Ownership and service objectives | [Architecture: operations](architecture/07_operations_and_lifecycle.md) | More telemetry helps only when routed to owners with runbooks |
| Environments and schema lifecycle | Promote code and manage dev/test/prod changes | Object and account model | [Architecture: operations](architecture/07_operations_and_lifecycle.md) | Strong separation improves safety but increases coordination and resource footprint |

## 10. Applications and AI

| Capability | What it is / typical use | Prerequisites | Depth and navigation | Key trade-off / availability |
| --- | --- | --- | --- | --- |
| Streamlit in Snowflake | Build data applications close to Snowflake data | SQL and application basics | [Architecture: integration boundaries](architecture/06_sharing_and_interoperability.md) | Short path to an app versus platform coupling and deployment constraints |
| Snowpark Container Services | Run selected containerized applications or workloads in Snowflake-managed infrastructure | Containers, roles, service concepts | [Architecture: integration boundaries](architecture/06_sharing_and_interoperability.md) | Reduced data movement versus service operations and regional/edition constraints |
| Cortex AI and LLM functions | Use supported model and AI capabilities near governed data | Data privacy and model behavior | Verify current account documentation; architecture discussion in [operations](architecture/07_operations_and_lifecycle.md) | Model availability, cost, data handling, and governance are release/region-specific |
| Cortex Search, Analyst, and agents | Build supported search, natural-language analytics, or agent workflows | Search, semantic modeling, governance | Verify current account documentation; architecture discussion in [sharing](architecture/06_sharing_and_interoperability.md) | Capability and maturity evolve quickly; validate suitability, output controls, and cost |
| Notebooks and developer workspaces | Explore, prototype, and develop data workloads | SQL or supported language basics | [Learning Paths](01_learning_paths.md) | Fast iteration versus reproducibility, review, and productionization requirements |

## Capability Map Maintenance

When adding a capability, record its purpose, prerequisites, recommended depth, trade-off, and availability caveat. Add a link only when the target material exists. Mark fast-changing features with a last-verified date in their detailed material and re-check official documentation before production recommendations.