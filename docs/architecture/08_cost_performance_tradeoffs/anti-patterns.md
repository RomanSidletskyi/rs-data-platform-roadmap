# Cost And Performance Anti-Patterns

## Why This Note Exists

Cost and performance mistakes usually come from solving imagined scale instead of real workload pressure.

## Anti-Pattern 1: Distributed Compute For Small Workloads

Why it is bad:

- operational and financial cost exceed the value of the workload
- teams debug platform complexity instead of solving the business problem

Better signal:

- compute shape matches actual data size and latency need

## Anti-Pattern 2: Partition Explosion

Why it is bad:

- metadata and small-file overhead rise sharply
- reads and writes both become operationally painful

Better signal:

- partitioning is chosen for dominant access patterns, not every imaginable filter

## Anti-Pattern 3: Over-Refreshing Everything

Why it is bad:

- cloud spend rises without proportional user value
- freshness expectations become detached from real decision cycles

Better signal:

- refresh strategy follows business timing and usage patterns

## Anti-Pattern 4: Optimizing Dashboards Against Raw Storage

Why it is bad:

- expensive low-level tuning hides serving-layer design flaws
- users still face unstable and slow consumption paths

Better signal:

- performance work starts from serving design, model shape, and consumer needs

## Review Questions

- what exact user-facing value justifies this cost
- are we paying for latency that nobody uses
- which simpler architecture would be good enough here