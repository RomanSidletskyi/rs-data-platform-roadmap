# Requirements

## Functional Requirements

- maintain a deduplicated clean staging layer
- maintain at least one reusable intermediate metrics layer
- maintain at least one serving mart with a defined freshness expectation
- document where non-dynamic orchestration is still required

## Non-Functional Requirements

- freshness targets must be explainable
- warehouse choice must be visible
- design should stay operable during incidents or cost spikes
- correctness under late-arriving data must be considered

## Decision Questions

- which tables deserve 5-minute lag and which do not?
- when should a model move back to scheduled batch?
- where does dynamic refresh add clarity, and where does it hide cost?