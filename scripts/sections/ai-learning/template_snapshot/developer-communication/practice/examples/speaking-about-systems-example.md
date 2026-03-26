# Speaking About Systems Example

## Scenario

Explain a simple data pipeline to a reviewer or interviewer.

## Weak Version

We have a pipeline with ingestion, validation, transformation, and publishing.

It basically moves data through those steps and makes it usable downstream.

## Why This Is Weak

- it names components without explaining why they exist
- the listener gets no clear flow or boundary
- no trade-off is mentioned
- it is too generic to support a real discussion

## Strong Version

This pipeline exists to turn raw customer event files into validated analytics-ready tables without letting broken input silently leak downstream.

At a high level, it has four stages.

First, ingestion lands raw files in bronze storage exactly as received so we keep replayability.

Second, validation checks schema shape and required fields before we do any business transformation.

Third, transformation normalizes the records into the model used by downstream consumers.

Fourth, publishing writes the curated output and exposes a stable contract for analytics jobs.

The main trade-off is that we fail earlier now.

That means bad files stop the pipeline sooner, which can reduce short-term throughput, but the system becomes easier to trust and debug because invalid data does not get partially transformed and mixed with good output.

If I were reviewing this design, the first thing I would check is whether the validation boundary is strict only for truly required fields and still tolerant to safe schema evolution.

## Why This Is Strong

- it gives the listener a fast mental model
- it keeps the component flow simple enough to say aloud
- it includes one meaningful trade-off instead of only describing boxes and arrows