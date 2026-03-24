# Architecture

This section is dedicated to architecture thinking for data platforms.

The goal is to understand not only how to use tools, but also:

- why specific components exist
- how systems are designed
- what trade-offs are involved
- how to choose between alternatives
- how to explain architecture decisions clearly

This directory is not the place for every design artifact.

Use it for architecture knowledge and architecture decisions.

Use `../system-design/` for worked system patterns.

Use `../trade-offs/` for explicit option comparison.

Use `reviews/` for architecture review checklists.

Use `adr/` for the final architecture-decision record.

Global architecture thinking in this repository means learning to answer questions such as:

- which system should own the truth
- which layer should do transport, processing, storage, or serving
- where complexity is justified and where it is wasteful
- which trade-off is being accepted deliberately
- what will break first when scale, latency, or team count grows

---

## What This Section Covers

- foundational architecture concepts
- batch and streaming patterns
- lakehouse thinking
- serving and BI architecture
- governance and reliability concepts
- architecture decisions
- links between repository modules and platform design

## What Good Architecture Thinking Looks Like

Use this directory to move beyond tool choice.

A strong architecture review should explain:

- what problem is actually being solved
- what non-functional constraints matter most
- why each major component exists
- what simpler alternative was rejected and why
- where the design is likely to fail or become expensive
- how operators will detect and recover from failure

If a design note cannot explain those points, it is probably still too tool-centric.

## New Supporting Layers

- `reviews/` gives you checklist-driven design review prompts
- `adr/` captures the final architecture choice in a concise record
- `synthesis/README.md` shows how topics, anti-patterns, examples, case studies, trade-offs, system design, reviews, and ADRs fit together

## How This Directory Fits

Use the architecture layer in this order:

1. learn concepts in the numbered topic folders
2. compare concrete system shapes in `../system-design/`
3. study decision pressure in `../trade-offs/`
4. evaluate the design with `reviews/`
5. examine or write architecture decisions in `adr/`
6. connect the result back to a module, pet project, or real project

---

## Recommended Study Order

1. Foundations
2. Batch Architecture
3. Streaming Architecture
4. Lakehouse Architecture
5. Serving and BI Architecture
6. Governance and Security
7. Scalability and Reliability
8. Cost and Performance Trade-offs
9. Case Studies

After that, move into:

10. `../system-design/`
11. `../trade-offs/`
12. `reviews/`
13. `adr/`
14. `synthesis/README.md`

## Recurring Questions To Ask In Every Topic

- what business or platform pressure creates the need for this design
- what should be centralized and what should stay local
- where should raw data be preserved before transformations narrow it
- what latency is actually required instead of assumed
- what correctness guarantees matter most
- what ownership model keeps the system understandable
- what happens during replay, rerun, or backfill
- what will drive cost fastest as usage grows

## Canonical Boundary

This directory should not contain a second copy of the system-design library.

If you need system-design patterns, use `../system-design/` as the canonical location.

---

## Architecture Thinking Template

Use this template when analyzing any design:

### Problem

What business or technical problem is being solved?

### Requirements

What are the constraints?

### Components

What are the major building blocks?

### Data Flow

How does data move through the system?

### Trade-Offs

What is gained and what is sacrificed?

### Alternatives

What could be used instead?

### Failure Points

Where can the system break?

### Observability

How will problems be detected?

### Cost Considerations

What could make this architecture expensive?

### Final Decision

Why is this architecture a good fit?

## What To Watch For

Positive signals:

- clear source-of-truth boundaries
- explicit reasoning for latency and freshness targets
- simple default paths with complexity added only where needed
- recoverability through replay, rerun, or rebuild strategy
- clear ownership across teams and layers

Warning signs:

- architecture built around tools instead of requirements
- raw and curated responsibilities mixed together
- no explanation of failure handling or observability
- unnecessary streaming or distributed compute for small workloads
- one layer becoming accidental owner of everyone else's problems
