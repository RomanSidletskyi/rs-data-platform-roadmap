# Trade-Offs And Recommendation

## What Became Easier

- fetching one order with embedded business context
- serving application-shaped responses without join assembly
- customer order history reads when the document is centered on orders

## What Became Harder

- updating duplicated product or customer attributes everywhere they appear
- keeping large embedded arrays bounded over time
- running broad analytical workloads compared with normalized SQL plus warehouse patterns

## Recommendation

Use the document model when:

- order-centric operational reads dominate
- response shape matters more than update normalization
- duplicated snapshots are acceptable by design

Stay relational when:

- cross-entity reporting is dominant
- strong consistency and normalized updates matter most
- the system is still fundamentally transactional and join-heavy

The migration is justified only if the target workload genuinely values simpler document reads more than it values normalized updates.
