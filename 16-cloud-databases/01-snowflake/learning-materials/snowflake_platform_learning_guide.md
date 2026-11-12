# Snowflake Platform Learning Guide

This is the detailed course plan for the Snowflake module: what to study first, what capability each phase builds, how to practice, and what evidence demonstrates progress.

## How This Guide Relates to the Other Navigation Documents

There is one shared curriculum for every learner. Junior, Middle, Senior, and Architect may study at different depths, but none of the levels has a separate or restricted set of materials.

- Use the [Capability Map](00_snowflake_capability_map.md) to find the complete inventory and open any learning-material file directly.
- Use [Learning Paths](01_learning_paths.md) to see all shared topics with Junior, Middle, Senior, and Architect focus guidance for each one.
- Use this guide for the course sequence, phase goals, practice, and completion checks.

This guide intentionally does not repeat the full file catalog. Its phase links are entry points; follow them into the Capability Map and Learning Paths to discover related references, deep dives, and architecture guides.

## Course Outcomes

By the end of the first pass, you should be able to:

1. Explain Snowflake's organization/account model, cloud and region placement, and storage/compute/cloud-services architecture.
2. Navigate core objects, roles, warehouses, SQL context, stages, integrations, and data types.
3. Load and transform data with an explicit correctness, replay, and freshness model.
4. Diagnose query behavior with evidence and explain performance and cost trade-offs.
5. Apply basic security, governance, and recovery principles.
6. Compare native Snowflake capabilities with external tools and open-table patterns.
7. Present an architecture decision with assumptions, alternatives, consequences, operations, and verification criteria.

The outcome is not memorizing every feature. It is knowing how to locate the relevant material, test a claim, and make a defensible decision.

## Before You Begin

- **Prerequisites:** basic SQL (`SELECT`, filters, joins, grouping, simple DDL) and data-platform terms such as source, ingestion, transformation, warehouse, and consumer.
- **Account:** not required for the reading route or simple tasks. Use an account only for optional hands-on work or account-based projects.
- **Safety:** confirm the target account, role, warehouse, and region before running SQL. Use small workloads, auto-suspend, cost controls where available, and teardown steps. Never commit credentials or real customer data.
- **Starting point:** if new to Snowflake, follow all phases. If experienced, scan the full [Learning Paths matrix](01_learning_paths.md#shared-curriculum-matrix), mark topics to review or deepen, then still use the same phase sequence for any unfamiliar areas.

## Study Loop for Every Topic

Use the same loop in each phase, adapting its depth to the level guidance:

1. **Orient:** read the relevant topic row in [Learning Paths](01_learning_paths.md) and locate all related files in the [Capability Map](00_snowflake_capability_map.md).
2. **Model:** explain the capability, its components, boundaries, and neighboring concepts in your own words.
3. **Study:** start with a quick reference if useful; continue to a deep dive or architecture guide when behavior, alternatives, or operational impact matter.
4. **Apply:** complete a matching account-free task or a scoped hands-on exercise.
5. **Verify:** compare the observed result with measurable expectations; inspect errors, logs, query behavior, or costs when relevant.
6. **Reflect:** record assumptions, trade-offs, limitations, and what would make you choose another approach.

Do not treat “read” as “mastered.” A topic is learned when you can use or assess it and explain the evidence.

## Course Phases

The estimates below follow the [progress tracker](../PROGRESS.md). They describe a first pass, not a deadline. The track is shared: each learner visits every phase, but can spend more or less time based on existing knowledge.

### Phase 1 — Platform foundations and account model

**Estimated study time:** about 6 hours.

**Study:** [Platform, accounts, cloud, and region](architecture/01_platform_account_cloud_region.md), [compute, workloads, and cost](architecture/02_compute_workload_cost.md), [objects and table types](reference/02_objects_and_table_types.md), and the foundation rows in the [Learning Paths matrix](01_learning_paths.md#shared-curriculum-matrix).

**Build understanding of:** organization and accounts, account identifiers, cloud and region selection, databases and schemas, roles and grants, warehouses, storage/compute separation, environment topologies, and basic cost attribution.

**Practice:** complete [task set 01: platform and objects](../simple-tasks/01_platform_and_objects/README.md). If using an account, identify the account/region and active role, create only low-cost lab objects, and confirm cleanup.

**Checkpoint:** draw a small account/object diagram and explain what is account-level versus database/schema-level, what each boundary isolates, and what it does not.

**Level lenses:** Junior learns the vocabulary and navigates; Middle applies object and role boundaries; Senior evaluates isolation and cost; Architect compares account/cloud/region topologies against requirements.

### Phase 2 — SQL, data types, and data movement

**Estimated study time:** about 10 hours.

**Study:** [SQL, dates, and semi-structured functions](reference/01_sql_dates_and_semistructured.md), [Snowflake SQL](reference/snowflake_sql.md), [Snowflake functions](reference/snowflake_functions.md), [semi-structured data](deep-dives/01_semi_structured_data.md), [Snowflake semi-structured data](deep-dives/Snowflake_semi_structured_data.md), [loading reference](reference/03_loading_and_operations.md), [data loading patterns](deep-dives/03_data_loading_patterns.md), [Snowflake ingestion](deep-dives/Snowflake_ingestion.md), and [ingestion architecture](architecture/03_data_ingestion_processing.md).

**Build understanding of:** SQL context and type behavior, dates and timestamps, JSON/`VARIANT` and `FLATTEN`, stages and file formats, `COPY INTO`, Snowpipe options, storage integrations, unload, and replay boundaries.

**Practice:** complete [task set 02: SQL and semi-structured data](../simple-tasks/02_sql_and_semi_structured/README.md) and [task set 03: ingestion and replay](../simple-tasks/03_ingestion_and_replay/README.md). Start [P01: Cricket JSON medallion](../end-to-end-projects/P01_cricket_json_medallion/README.md) if you want a guided implementation.

**Checkpoint:** describe and verify a path from file to queryable table. Explain how malformed records, duplicate files, and reruns are handled.

**Level lenses:** Junior practices SQL and file loading; Middle designs replayable ingestion; Senior compares ingestion options using freshness, error handling, and cost; Architect sets data movement contracts and trust boundaries.

### Phase 3 — Processing, performance, and cost

**Estimated study time:** about 10 hours.

**Study:** [processing and recovery reference](reference/04_processing_and_recovery.md), [incremental processing](deep-dives/04_incremental_processing.md), [dynamic tables](deep-dives/Snowflake_dynamic_tables.md), [query performance track](deep-dives/query-performance/README.md), [Snowflake performance](deep-dives/Snowflake_performance.md), and [compute, workloads, and cost](architecture/02_compute_workload_cost.md).

**Build understanding of:** `MERGE`, streams, tasks and task graphs, dynamic tables, refresh/freshness objectives, Query Profile, pruning, caching, warehouses, concurrency, and costed optimization features. Read the nine query-performance track materials in the sequence shown in its README.

**Practice:** complete [task set 04: processing patterns](../simple-tasks/04_processing_patterns/README.md), [task set 05: performance and cost](../simple-tasks/05_performance_and_cost/README.md), and [task set 10: performance diagnosis and design](../simple-tasks/10_snowflake_performance/README.md). Use [P05: TPC-H streams, tasks, and CDC](../end-to-end-projects/P05_tpch_streams_tasks_cdc/README.md) or [P07: Retail Snowpark pipeline](../end-to-end-projects/P07_retail_snowpark_pipeline/README.md) for a larger build.

**Checkpoint:** diagnose a query or pipeline using observable evidence; explain correctness, refresh/replay behavior, and the cost implications of the fix. Compare dynamic tables with at least one alternative for a concrete workload.

**Level lenses:** Junior explains the basic execution path; Middle builds and validates an incremental pipeline; Senior diagnoses bottlenecks and compares alternatives; Architect sets workload isolation, freshness contracts, and cost ownership.

### Phase 4 — Security, governance, and recovery

**Estimated study time:** about 8 hours.

**Study:** [security and governance](architecture/04_security_governance.md), [secure views](deep-dives/02_secure_views.md), [availability and recovery](architecture/05_availability_and_recovery.md), [sharing and interoperability](architecture/06_sharing_and_interoperability.md), and the relevant quick references.

**Build understanding of:** role hierarchy, grants and ownership, managed access, masking and row access, integrations and secrets, classification and audit, Time Travel, cloning, replication, failover, sharing, and their different goals and limitations.

**Practice:** complete [task set 06: security, recovery, and architecture](../simple-tasks/06_security_recovery_architecture/README.md). For a broader design exercise, use [guided project 03: Production Snowflake platform](../pet-projects/03_production_snowflake_platform/README.md). [P13: Healthcare governed ML](../end-to-end-projects/README.md#catalog) is a planned optional extension, not a prerequisite for completing this phase.

**Checkpoint:** draw a trust/access boundary and write a recovery outline with RPO, RTO, dependencies, and a test procedure. Explain why replication, failover, sharing, and a masked query result are not interchangeable concepts.

**Level lenses:** Junior understands basic roles and recovery terms; Middle configures least privilege and verifies recovery; Senior reviews policy edge cases and failover behavior; Architect defines governance ownership, continuity design, and regulatory constraints.

### Phase 5 — Interoperability and architecture decisions

**Estimated study time:** about 8 hours.

**Study:** [Iceberg and external tables](deep-dives/iceberg-and-external-tables/README.md), [table type decision guide](deep-dives/iceberg-and-external-tables/Snowflake_table_type_decision_guide.md), [Snowflake data platform architecture](architecture/Data_platform_architecture.md), [non-functional requirements](architecture/Non_functional_requirements_NFR.md), [system-design answer patterns](architecture/system_design_ready_answers.md), and [senior architecture questions](architecture/Top_tricky_senior_questions.md).

The table-type collection includes separate guides for Snowflake-managed Iceberg, externally managed Iceberg, Open Catalog, external tables, and operational cookbooks. Use the Capability Map for direct links to each file.

**Build understanding of:** metadata/catalog ownership, native versus external table choices, cross-engine contracts, workload boundaries, requirements and NFRs, architecture trade-offs, and ADRs.

**Practice:** complete [task set 08: Snowflake open tables and refresh](../simple-tasks/08_snowflake_open_table_and_refresh/README.md) and [task set 09: architecture scenarios](../simple-tasks/09_snowflake_architecture_scenarios/README.md). Complete at least one guided project, preferably [P03: Production Snowflake platform](../pet-projects/03_production_snowflake_platform/README.md), as a design exercise or [P04: Open-table publish](../pet-projects/04_snowflake_open_table_publish/README.md) for interoperability.

**Checkpoint:** write a short decision record that states constraints, at least two viable options, the selected approach, rejected alternatives, consequences, failure modes, and a trigger for revisiting the decision.

**Level lenses:** Junior explains one component's role; Middle evaluates viable implementation patterns; Senior defends measured trade-offs and operational impact; Architect ties platform choices to NFRs, organization boundaries, ownership, and lifecycle.

### Phase 6 — Consolidation and proof of learning

**Estimated study time:** about 6 hours for task review; project time is additional.

Review the [Capability Map](00_snowflake_capability_map.md) and revisit topics marked for review in your personal notes. Do not reread everything automatically; target gaps revealed by tasks, project work, or architecture discussions.

**Practice:** solve the relevant simple tasks without first opening the solutions. Choose a guided project or an end-to-end project that combines multiple capabilities. For end-to-end work, follow the project's quickstart and cost guardrails, and stop resources when finished.

**Checkpoint:** present a design or implementation review with evidence: architecture diagram, requirements, data flow, access model, verification results, failure/recovery story, cost controls, and acknowledged limitations.

**Level lenses:** Junior demonstrates a coherent basic setup; Middle demonstrates a reliable pipeline; Senior diagnoses and improves an existing design; Architect communicates a defensible platform decision and operating model.

## Time Budget and Optional Hands-On Track

The [PROGRESS.md](../PROGRESS.md) estimates **50–70 hours for the first pass**. The phases above total roughly 48 hours including simple-task practice, before guided projects; project scope, prior knowledge, and depth account for the remainder. These estimates are planning aids, not gates.

Reading, design exercises, and simple tasks can be completed without a Snowflake account. Account-based end-to-end projects are an optional, additional track: use the [project catalog](../end-to-end-projects/README.md), [environment setup guide](../../../shared/environments/setup-guide/README.md), and per-project cost controls. They may require Azure or AWS resources and can incur charges.

## Navigation Maintenance Rule

When a learning document is added, moved, or renamed:

1. Link it directly from the [Capability Map](00_snowflake_capability_map.md).
2. Put it in the appropriate topic row in [Learning Paths](01_learning_paths.md), including Junior, Middle, Senior, and Architect focus.
3. Update this guide only if it changes the curriculum sequence, outcomes, activities, or checkpoints.
4. Keep the module README and [Learning Materials overview](README.md) consistent with these roles.
