# Worked Example - Replay After Sink Failure

## Scenario

A Kafka consumer writes order events into a serving database.

For two hours, the sink logic applied a wrong transformation and wrote bad values.

## Why Reliability Design Matters

- the stream kept moving
- downstream data became wrong
- the team now needs recovery, not only monitoring

## Architecture Shape

    source topics
        -> consumer application
        -> serving database
        -> replay procedure for rebuild or repair

## What Good Looks Like

- event IDs or idempotent upserts make reprocessing safe
- the affected time window can be replayed deliberately
- lag, DLQ, and sink failure signals are observable
- the team knows whether to repair in place or rebuild the target

## What Bad Looks Like

- consumer offsets advanced before safe downstream handling
- no replay plan exists despite retained events
- duplicate writes produce inconsistent serving state
- the team cannot distinguish bad records from temporary dependency failures

## Questions To Review

- is the sink idempotent
- what event window must be replayed
- can replay overload the dependency again
- what evidence proves the rebuilt data is now correct

## Key Takeaway

Reliability is not only about the pipeline staying alive. It is about the platform recovering safely when correctness is lost.