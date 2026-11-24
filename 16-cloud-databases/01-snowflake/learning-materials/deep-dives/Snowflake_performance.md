# Snowflake Performance

This legacy URL is retained for existing bookmarks. Its earlier rules of thumb have been superseded because scan ratios, function predicates, clustering, spill, cache, and warehouse sizing must be interpreted in workload context.

Use the [Snowflake query performance and optimization course](query-performance/README.md) for the current evidence-first guidance, examples, alternatives, cost trade-offs, production cases, and exercises with solutions.

For these specific topics, start with:

- [Clustering and pruning](query-performance/10_clustering_and_pruning.md) — micro-partitions, keys, automatic clustering, measurement, and costs.
- [Search Optimization](query-performance/11_search_optimization.md) — search access paths, selective lookups, configuration, measurement, and costs.
- [Clustering vs Search Optimization](query-performance/08_architecture_decisions.md#5-clustering-search-optimization-or-no-additional-structure) — choosing based on the workload.
