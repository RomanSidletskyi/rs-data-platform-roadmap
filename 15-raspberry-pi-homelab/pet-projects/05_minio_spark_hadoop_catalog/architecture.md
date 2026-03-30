# Architecture

## Core Pattern

This stack has only two moving parts:

- MinIO as object storage
- Spark as compute engine and catalog client

The catalog type is `hadoop`.

That means Spark resolves tables by warehouse path conventions instead of calling a separate catalog API.

## Mental Model

This is not:

- MinIO alone creating tables
- a metadata service
- a governance layer

This is:

- Spark writing Iceberg metadata files into object storage
- Spark resolving tables through a file-based catalog model

## Why It Is Simpler

- fewer containers
- fewer ports
- no separate control plane to debug
- easier first success on a weak homelab machine

## Why It Is Architecturally Weaker

- no branch model
- no catalog API boundary
- less realistic for multi-user or multi-engine governance
- file-based object-store catalogs deserve extra caution around concurrent writers

## Recommended Usage Mode

Treat this as a single-node, single-active-writer learning lab.