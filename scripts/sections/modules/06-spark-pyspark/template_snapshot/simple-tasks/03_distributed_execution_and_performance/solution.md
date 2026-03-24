# Solutions: Distributed Execution And Performance

## Task 1

The stage is expensive because grouping and joining large datasets are wide operations that can trigger heavy shuffle cost. The filter helps, but the main runtime risk is still data movement across the cluster.

## Task 2

Possible explanations:

- a skewed key dominates one partition
- one join side became much larger than expected
- output writing or storage layout introduced imbalance

More hardware may help only partially because the underlying problem may be uneven data shape rather than insufficient compute.

## Task 3

Caching may help if the same cleaned DataFrame is reused several times in one execution and recomputation is expensive.

Writing an intermediate dataset may be better if:

- other jobs also depend on it
- reproducibility matters
- the boundary should survive beyond one run

## Task 4

Useful triage sequence:

1. identify the newly slow stage
2. inspect whether shuffle or skew increased
3. compare data volume and key distribution changes
4. check output layout and file-shape effects
5. only then decide whether resource sizing is the real issue