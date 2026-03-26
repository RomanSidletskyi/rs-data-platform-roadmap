# Solution

Topic checklist items:

- who owns the topic?
- what business fact does it carry?
- what key supports ordering and distribution?
- what retention and replay window is needed?
- who are the expected consumers?

Retry and DLQ recipe:

1. validate early
2. classify transient vs permanent failure
3. retry transient failures with bounds
4. route permanent or exhausted failures to DLQ
5. keep diagnostic metadata

Operational triage signals:

- consumer lag
- rebalance frequency
- sink latency
- DLQ growth
- publish or processing error rates