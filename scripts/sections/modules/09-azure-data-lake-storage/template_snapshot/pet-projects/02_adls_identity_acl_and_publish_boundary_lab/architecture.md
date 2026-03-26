# Architecture

## Components

- one storage account resource boundary managed through Azure RBAC
- one path-level ACL design for raw, curated, and publish subtrees
- one managed identity for Azure-hosted platform workflows
- one service principal for external ingestion where managed identity is unavailable
- one analyst group with read-only access to a stable publish subtree

## Data Flow

1. ingestion identity lands producer data into a raw subtree
2. platform processing reads raw and writes curated outputs
3. publish paths expose supported read-only datasets to consumers
4. analysts never rely on internal raw or working paths

## Trade-Offs

- broad RBAC grants are easy but usually too coarse
- ACLs add precision but need a stable namespace design to stay manageable
- publish boundaries reduce accidental discovery of internal working data
