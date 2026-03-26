# Architecture Case Studies

## What This Topic Is For

Case studies translate architecture theory into real-world reasoning.

This is the place where you stop asking only "what is Kafka" or "what is a lakehouse" and start asking why a company chose one shape instead of another.

## Why Case Studies Matter

Real examples force you to notice:

- what problem created the architecture
- which scaling or organizational pressure mattered most
- what trade-off was accepted deliberately
- what parts of the system are reusable and what parts are company-specific

## Suggested Case Studies

- Netflix data platform
- Uber streaming architecture
- Spotify data pipelines
- Airbnb analytics platform

## What To Look For In Each Case Study

- source-of-truth boundaries
- event or batch flow shape
- storage and serving separation
- ownership across teams
- cost, latency, and reliability trade-offs
- where the design would be overkill in a smaller company

## Common Mistakes When Reading Case Studies

- copying famous-company architecture without matching the problem size
- focusing on tools instead of problem pressure
- assuming a company blog describes the whole system instead of one slice
- confusing platform maturity with a mandatory learning path

## Good Output After Reading A Case Study

You should be able to explain:

- the main system flow in plain language
- the 2-3 most important architecture decisions
- one simpler alternative and why it would fail here
- one reason the same design would be a bad fit for a smaller team

Worked example:

- `worked_example_how_to_read_a_famous_architecture.md`

## Read Next

- `resources.md`
- `anti-patterns.md`
- `worked_example_how_to_read_a_famous_architecture.md`
- `../../case-studies/README.md`
- `../../trade-offs/README.md`

## Completion Checklist

- [ ] I analyzed at least one real architecture
- [ ] I can explain its main components
- [ ] I can identify trade-offs
