# CDC Integration Recipe

## Goal

Use CDC safely without confusing raw database changes with curated business contracts.

CDC is powerful because it can turn database updates into an event stream quickly.

But teams often misuse CDC by exposing raw row changes as if they were polished domain APIs.

## Recipe

1. Capture changes from the source database.
2. Publish raw CDC topics with clear naming and ownership.
3. Decide which consumers can use raw CDC directly.
4. Create curated downstream topics if business semantics need cleanup.

## How To Think About CDC

CDC usually represents storage-level change, not automatically business meaning.

Examples of raw CDC events:

- order row inserted
- payment row updated
- customer record deleted

Useful, yes.

But often too close to database internals for broad downstream consumption.

## Strong Pattern

### Raw integration feed

- topic: `cdc.orders_raw`
- audience: ingestion or platform teams that understand source-table semantics

### Curated business feed

- topic: `sales.order_events`
- audience: downstream consumers that need cleaner, business-oriented contracts

This separation gives flexibility without forcing all consumers to depend on low-level table details.

## Example

- raw CDC topic: `cdc.orders_raw`
- curated topic: `sales.order_events`

## Good Questions To Ask

- does this consumer really need raw database changes?
- will source-table schema churn break many downstream users?
- are deletes and updates represented in a way consumers can interpret safely?
- should we preserve raw CDC only as internal plumbing and expose cleaner topics downstream?

## Anti-Patterns

- making raw CDC the public interface for many teams without governance
- treating source-table names as stable business-domain contracts
- exposing noisy storage mutations when consumers actually need business events

## Rule

Raw row changes are an integration feed, not automatically a clean business API.