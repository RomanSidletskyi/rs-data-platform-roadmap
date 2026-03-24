# Architecture Note

## Target Flow

1. clickstream events arrive continuously or in replayable batches
2. Spark parses and validates event-time fields
3. a sessionization layer groups activity into user sessions
4. skew-heavy identifiers are reviewed so one key does not dominate runtime
5. session outputs are published for downstream funnel and engagement analysis

## Core Design Questions

- what session boundary is the business using?
- how much lateness should the system tolerate?
- how should skewed identifiers be detected and handled?
- what is the publication grain of the session layer?