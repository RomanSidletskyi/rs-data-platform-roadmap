# Architecture

## Components

- one ADLS storage account for the analytics environment
- one raw container for landed producer outputs
- one curated container for cleaned internal datasets
- one publish container for consumer-facing storage contracts
- one namespace policy that keeps domain and dataset names stable

## Data Flow

1. producers land source-aligned data into raw paths
2. platform processing promotes trusted outputs into curated paths
3. published consumer data is exposed through stable publish paths
4. internal landing or repair paths never become the official interface

## Trade-Offs

- stronger top-level boundaries reduce accidental coupling
- too many containers create sprawl and harder governance
- internal processing flexibility should not leak into consumer-facing paths
