# Freshness SLA Notes

Use this file to propose different latency classes.

Suggested classes:

- operational visibility: 5 minutes
- product analytics: 15 to 30 minutes
- finance reconciliation: hourly or daily

Questions to answer:

- which stakeholders actually need freshness, and which only say they do?
- which models are narrow enough to justify low lag?
- which models are too heavy for low-lag dynamic maintenance?

Rule:

- every lag choice should map to a consumer need and a cost trade-off.