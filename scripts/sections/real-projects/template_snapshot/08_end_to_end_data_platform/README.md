# Real Project 08: End-To-End Data Platform

## Goal

Build an end-to-end platform scenario that combines ingestion, transformation, serving, governance, and operational review into one coherent architecture.

This project should feel like a platform design, not only a stack assembly exercise.

## Suggested Stack

- choose the tools justified by the design
- prefer reuse of previous real-project patterns where reasonable

## Architecture Focus

- whole-system layer responsibilities
- governance and ownership boundaries
- reliability and recovery design
- cost and complexity justification

## Suggested Deliverables

- architecture overview
- implementation slices for key layers
- explicit source-of-truth boundaries
- review notes or ADRs for major design choices
- run and validation instructions

## Review Questions

- can the platform be explained as a small set of clear responsibilities
- what is the simplest viable version of this platform
- where will it fail first under growth or incident pressure

## Read With

- `../../docs/architecture/reviews/real-project-review-exercises.md`
- `../../docs/architecture/reviews/system-shape-review-checklist.md`
- `../../docs/architecture/reviews/reliability-cost-review-checklist.md`
- `../../docs/architecture/adr/template.md`