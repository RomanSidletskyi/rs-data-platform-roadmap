# Workspace, Control Plane, And Compute Plane

## Why This Topic Matters

Managed platforms are easier to use when the learner understands which responsibilities live in the platform control plane and which live in the compute environment.

Without that, teams get confused about security, networking, runtime failures, and storage access.

## Core Idea

Databricks usually separates:

- a control plane that manages workspace metadata, orchestration, and platform services
- a compute plane where jobs and queries actually execute

This distinction matters because it affects:

- security boundaries
- network architecture
- where data is processed
- who owns which operational controls

## Workspace Layer

The workspace is where teams interact with:

- notebooks
- jobs
- SQL queries
- repos
- permissions and shared objects

This is the human-facing operating surface.

It is not the full data-processing story.

## Compute Plane

The compute plane is where clusters, job compute, or warehouses execute workloads.

This is where:

- Spark tasks run
- notebooks attach to compute
- ETL pipelines consume resources
- SQL warehouses execute analytical queries

## Real Example

An engineer edits a notebook in the workspace.

The code itself lives in a collaborative surface.

But when the engineer attaches that notebook to a cluster and runs a medallion transformation, the data processing happens on managed compute, not inside the browser UI.

That distinction seems obvious once learned, but many operational misunderstandings come from forgetting it.

## Architecture Questions To Ask

1. Which parts of this workflow are workspace metadata?
2. Which parts require governed compute?
3. Which identities are interacting with the workspace versus storage?
4. Where does network and secret configuration actually matter?

## Good Strategy

- explain Databricks as layered platform surfaces, not one monolithic product box
- connect workspace behavior to compute execution explicitly
- use the control-plane versus compute-plane distinction when reasoning about security and operations

## Key Architectural Takeaway

Databricks becomes easier to design and operate once you separate the collaborative workspace layer from the actual compute environment where data workloads run.