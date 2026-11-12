# Learning Paths

This page explains how to study the Snowflake curriculum at different levels. It is not a second catalog: the [Capability Map](00_snowflake_capability_map.md) is the complete, direct-link index of every learning-material file.

## One Shared Curriculum, Four Lenses

Every learner can use every material in the module. **Junior, Middle, Senior, and Architect are not separate syllabi and do not determine access.** They describe the depth, priorities, and evidence of understanding to aim for when studying the same topics.

| Lens | Primary question | Recommended way to use the materials |
| --- | --- | --- |
| Junior | What is this, and how does a basic example work? | Learn terminology and mental models; follow examples; practice the basic task; explain each object's role. |
| Middle | How do I build and operate this reliably? | Implement a working pattern; validate correctness; handle retries, replay, permissions, and common failures. |
| Senior | How do I make this correct, observable, performant, and cost-effective? | Review the full topic set; prioritize diagnostics, behavior boundaries, edge cases, alternatives, and evidence-based trade-offs. Revisit foundations when needed. |
| Architect | Why does this belong in this platform, and what are the system-wide consequences? | Review the full topic set; prioritize requirements, account and workload boundaries, contracts, governance, RPO/RTO, operating model, and decision rationale. |

These are recommended focuses, not restrictions. A Junior can explore architecture topics; a Senior can take a full beginner-style pass through unfamiliar areas. Use **review** to refresh a known concept, **prioritize** to indicate where to spend more time, and **optional deep dive** only when the topic is not required for the learner's current goal. No topic is omitted from a level's view of the shared curriculum.

## Shared Curriculum Matrix

Follow the topic order below for a first end-to-end pass. Each row links to the relevant files and states a focus for all four levels. The links are a useful route into the material; the [complete Capability Map index](00_snowflake_capability_map.md#complete-learning-material-index) also exposes every file directly.

| Stage and topic | Learning materials | Junior focus | Middle focus | Senior focus | Architect focus |
| --- | --- | --- | --- | --- | --- |
| 1. Platform, accounts, cloud, and regions | [Platform architecture](architecture/01_platform_account_cloud_region.md); [objects reference](reference/02_objects_and_table_types.md) | Learn organization/account/region terms and navigate a basic account. | Apply context, roles, and object boundaries safely in more than one environment. | Review isolation choices, organization administration, replication assumptions, and failure domains. | Compare account, cloud, and region topologies against residency, operations, recovery, and cost requirements. |
| 2. Compute, workloads, and cost | [Compute and cost architecture](architecture/02_compute_workload_cost.md); [loading and operations reference](reference/03_loading_and_operations.md); [performance metrics](deep-dives/query-performance/02_metrics_reference.md) | Explain warehouses versus stored data and identify basic cost controls. | Size and isolate workloads; configure suspension and monitor consumption. | Diagnose contention and cost using query/usage evidence; compare scaling choices. | Design workload isolation, budgets, cost ownership, and service objectives. |
| 3. SQL, types, and database objects | [SQL reference](reference/snowflake_sql.md); [function reference](reference/snowflake_functions.md); [SQL/dates/semi-structured reference](reference/01_sql_dates_and_semistructured.md); [objects and table types](reference/02_objects_and_table_types.md) | Practice core SQL, session context, common types, and object names. | Use functions and table types correctly in reusable transformations. | Review subtle type, null, time-zone, and object-lifecycle behavior. | Set conventions for schemas, contracts, naming, retention, and ownership. |
| 4. Semi-structured data | [Compact reference](reference/01_sql_dates_and_semistructured.md); [Snowflake semi-structured guide](reference/01_semi_structured_data.md); [Complete Guide (Senior Cheat Sheet)](deep-dives/Snowflake_semi_structured_data.md); [performance deep dive](deep-dives/semi_structured_performance.md) | Query JSON with `VARIANT`, path notation, and `FLATTEN`; understand missing paths and empty arrays. | Normalize, type, and validate evolving payloads in a pipeline. | Diagnose pruning, shape drift, sparse data, and transformation cost. | Choose payload contracts and decide where to preserve flexibility versus model stable columns. |
| 5. Loading and ingestion | [Loading reference](reference/03_loading_and_operations.md); [loading patterns](deep-dives/03_data_loading_patterns.md); [Snowflake ingestion](deep-dives/Snowflake_ingestion.md); [ingestion architecture](architecture/03_data_ingestion_processing.md) | Load files with stages, file formats, and `COPY INTO`. | Build monitored, replayable batch or continuous file ingestion. | Compare `COPY`, Snowpipe, Snowpipe Streaming, connectors, and failure/reconciliation behavior. | Select ingestion patterns from freshness, throughput, ownership, recovery, and cost requirements. |
| 6. Incremental processing and dynamic tables | [Processing reference](reference/04_processing_and_recovery.md); [incremental processing](deep-dives/04_incremental_processing.md); [dynamic tables](deep-dives/Snowflake_dynamic_tables.md); [processing architecture](architecture/03_data_ingestion_processing.md) | Understand a simple scheduled transformation and its dependencies. | Build idempotent `MERGE` or task/stream/dynamic-table pipelines and validate refresh. | Compare dynamic tables with streams/tasks, dbt, and procedural patterns; diagnose lag and correctness. | Set transformation boundaries, freshness contracts, workload ownership, and orchestration responsibilities. |
| 7. Query performance and optimization | [Track overview](deep-dives/query-performance/README.md); [performance overview](deep-dives/05_query_performance.md); [execution plans](deep-dives/query-performance/01_execution_plan_analysis.md); [metrics](deep-dives/query-performance/02_metrics_reference.md); [table/storage](deep-dives/query-performance/03_table_and_storage_performance.md); [SQL/operators](deep-dives/query-performance/04_sql_patterns_and_operators.md); [caching](deep-dives/query-performance/05_caching.md); [optimization features/costs](deep-dives/query-performance/06_optimization_features_and_hidden_costs.md); [production casebook](deep-dives/query-performance/07_production_casebook.md); [architecture decisions](deep-dives/query-performance/08_architecture_decisions.md); [senior questions](deep-dives/query-performance/09_senior_interview_questions.md); [Snowflake performance](deep-dives/Snowflake_performance.md) | Read a basic Query Profile and recognize scans and filters. | Diagnose a slow query, measure changes, and avoid regression. | Work through the full track: isolate bottlenecks, quantify pruning/spill/queueing, and justify costed features. | Translate performance evidence into workload, data-layout, concurrency, and cost architecture decisions. |
| 8. Security, governance, and privacy | [Security architecture](architecture/04_security_governance.md); [views and data access policies walkthrough](deep-dives/02_security_views.md); [objects and grants reference](reference/02_objects_and_table_types.md) | Explain users, roles, grants, and why names alone do not secure data. | Implement least privilege, managed access, and policy-aware testing. | Review role hierarchy, masking/row policies, identity boundaries, audit, and policy failure modes. | Define governance ownership, segregation of duties, regulatory controls, and cross-account operating principles. |
| 9. Availability, recovery, and testing | [Recovery reference](reference/04_processing_and_recovery.md); [availability and recovery architecture](architecture/05_availability_and_recovery.md) | Distinguish Time Travel, cloning, and backup concepts. | Practice recovery of objects and validate a recovery procedure. | Evaluate RPO/RTO, replication lag, failover prerequisites, and data leakage/cost risks in test copies. | Design tested recovery/failback and continuity across accounts, regions, applications, and operators. |
| 10. Sharing, interoperability, Iceberg, and external tables | [Sharing architecture](architecture/06_sharing_and_interoperability.md); [Iceberg/table-type index](deep-dives/iceberg-and-external-tables/README.md); [table decision guide](deep-dives/iceberg-and-external-tables/Snowflake_table_type_decision_guide.md); [Snowflake-managed Iceberg](deep-dives/iceberg-and-external-tables/Snowflake_managed_Iceberg.md); [external tables](deep-dives/iceberg-and-external-tables/Snowflake_external_tables.md); [Open Catalog](deep-dives/iceberg-and-external-tables/Snowflake_Open_Catalog.md) and [cookbook](deep-dives/iceberg-and-external-tables/Snowflake_Open_Catalog_cookbook.md); [externally managed Iceberg](deep-dives/iceberg-and-external-tables/Snowflake_externally_managed_Iceberg.md) and [cookbook](deep-dives/iceberg-and-external-tables/Snowflake_externally_managed_Iceberg_cookbook.md) | Learn what a shared dataset and an external table are. | Query and operate a selected native/open-table pattern. | Compare metadata ownership, refresh, writes, access boundaries, and multi-engine failure behavior. | Choose table format/catalog/sharing boundaries from interoperability, governance, portability, and operating requirements. |
| 11. Development, operations, and applications | [Operations architecture](architecture/07_operations_and_lifecycle.md); [loading/operations reference](reference/03_loading_and_operations.md); [platform architecture synthesis](architecture/Data_platform_architecture.md); [query performance track](deep-dives/query-performance/README.md) | Connect with a supported client and run a repeatable small workflow. | Version, test, deploy, monitor, and operate pipelines and applications. | Review incident response, deployment safety, drift, observability, and operational toil. | Define platform lifecycle, ownership, delivery controls, and integration boundaries. |
| 12. Architecture synthesis and communication | [Data platform architecture](architecture/Data_platform_architecture.md); [NFR guide](architecture/Non_functional_requirements_NFR.md); [system-design answers](architecture/system_design_ready_answers.md); [senior architecture questions](architecture/Top_tricky_senior_questions.md); [performance architecture decisions](deep-dives/query-performance/08_architecture_decisions.md) | Explain a small Snowflake design and its main components. | Defend a working pipeline design and its operational checks. | Present evidence-based trade-offs, failure modes, and alternatives. | Produce an ADR and system design tied to NFRs, ownership, validation, and revisit triggers. |

The cells describe what to do with the linked materials, not different material sets. All links remain available at every level.

## Routes Through the Shared Curriculum

### Junior route

Follow stages 1–12 in order. Spend time on the **Junior focus** in each row, use the quick references before detailed guides, and complete matching account-free tasks before opening their solutions. Build at least one guided project. Preview advanced architecture and Iceberg material, but focus first on explaining the fundamental object and data-flow models.

### Middle route

Use the same stages 1–12. Review the foundations quickly, then focus on implementation, validation, replay, permissions, performance evidence, and operations in every topic. Complete the ingestion, processing, performance, and architecture task sets; build a project with an explicit recovery and cost check.

### Senior route

Use the same stages 1–12; do not treat the foundation or application topics as out of scope. First scan the full Capability Map and this matrix, then prioritize the **Senior focus** in every row. Use the quick references to refresh familiar details, but study detailed guides, production cases, diagnostics, architecture decisions, and failure scenarios where behavior or trade-offs are consequential. Complete the performance diagnosis/design and architecture scenario tasks, and defend choices with evidence.

### Architect route

Use the same stages 1–12; technical details remain available and matter when they affect an architecture decision. Prioritize requirements, boundaries, cross-account/regional effects, data contracts, security, cost, recovery, ownership, and the decision questions in the architecture guides. Complete the architecture scenarios and a capstone design with NFRs, ADRs, failure modes, operational ownership, and revisit triggers.

## Practice and Evidence

Use the same practice catalog at every level; choose the scope and depth appropriate to your goal:

- [Simple tasks](../simple-tasks/README.md): 10 account-free sets, from platform basics through performance and architecture. Solve first and compare with the concise solutions afterward.
- [Guided pet projects](../pet-projects/README.md): five design/build exercises, from a governed warehouse through dynamic-table and open-table patterns.
- [End-to-end projects](../end-to-end-projects/README.md): complete pipelines with working references. Start at P01 if new to Snowflake; P04 is an alternative starting point if basic SQL and file loading are already familiar. These projects require a Snowflake account and can incur cloud costs.

Completion should be demonstrated, not inferred from reading. For each topic, be able to explain the model, complete or review a relevant exercise, describe failure and cost implications, and state what evidence supports your decision. Senior and Architect learners can use an oral design review, an ADR, a diagnosis report, or a failure-mode analysis instead of repeating an introductory implementation.

## How to Use Level Recommendations

- **Learn**: build first understanding and explain the core model.
- **Apply**: implement the pattern and verify its outputs.
- **Diagnose**: reason from evidence, edge cases, failure modes, and measured behavior.
- **Design**: compare system choices against requirements and operating constraints.
- **Review**: revisit a familiar topic for current terminology or a specific decision.
- **Optional deep dive**: pursue additional detail when relevant; this label never hides the material from another level.

When a new document is added, link it directly in the [Capability Map](00_snowflake_capability_map.md), put it in the appropriate matrix row, and update that row's focus guidance for all four levels.
