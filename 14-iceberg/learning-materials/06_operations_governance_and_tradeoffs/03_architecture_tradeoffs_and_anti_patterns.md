# Architecture Trade-Offs And Anti-Patterns

## 1. Main Trade-Off

Iceberg gives strong table semantics in open storage.

In exchange, you accept:

- metadata complexity
- catalog choice
- maintenance work
- deeper engine compatibility analysis

That trade-off is worth it only when the platform needs it.

## 2. Good Patterns

Good Iceberg patterns usually have:

- clear ownership
- long-lived curated tables
- multi-engine value that is real, not hypothetical
- explicit maintenance and governance model

## 3. Anti-Patterns

Common anti-patterns include:

- using Iceberg for every temporary dataset
- adding multiple catalogs without a clear control-plane owner
- assuming every engine supports every operation equally
- pretending open table formats remove the need for contracts and governance

## 4. When Not To Use Iceberg

Do not use Iceberg when:

- simple warehouse-native tables solve the need better
- the dataset is short-lived and private to one pipeline step
- the organization lacks platform discipline for catalog and maintenance ownership

## 5. Architect Summary

Iceberg is best for governed, durable, engine-shared analytical tables.

It is not a universal replacement for every table or every file layout.