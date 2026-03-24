# Architecture Case Study Anti-Patterns

## Why This Note Exists

Case studies are useful only if they improve judgment rather than encourage cargo-cult copying.

## Anti-Pattern 1: Copying Famous Architecture Blindly

Why it is bad:

- teams import complexity without importing the real problem pressure
- platform maturity is confused with mandatory design shape

Better signal:

- the case is translated into local constraints before any reuse decision is made

## Anti-Pattern 2: Focusing On Tools Instead Of Decisions

Why it is bad:

- the lesson becomes "use Kafka" rather than "solve multi-consumer low-latency replayable flow"
- reusable design reasoning is lost

Better signal:

- each case is reduced to problem, trade-off, and alternative shapes

## Anti-Pattern 3: Assuming One Blog Post Describes The Whole System

Why it is bad:

- architecture conclusions are drawn from one slice without context
- teams overgeneralize from partial information

Better signal:

- the case is read as one perspective, not as total platform documentation

## Anti-Pattern 4: No Simpler Alternative Analysis

Why it is bad:

- readers admire the system instead of evaluating it
- complexity is treated as proof of quality

Better signal:

- every case is paired with one simpler alternative and one reason it would or would not work

## Review Questions

- what business or organizational pressure forced this architecture shape
- which parts are reusable principles and which are company-specific
- what smaller-company version of this design would be responsible