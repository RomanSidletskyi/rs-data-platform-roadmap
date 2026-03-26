# Network Debugging For Engineers

## Why This Topic Matters

Many runtime incidents are actually connectivity incidents.

## Core Commands

    ping host
    curl http://host:port
    nc -vz host port
    ss -ltnp
    lsof -i :8080
    nslookup host

## Good Strategy

- separate DNS failure from port failure from application failure
- check from the same machine that experiences the problem

## Cookbook Example

If a service does not respond:

1. resolve the name

    nslookup service.local

2. check the port

    nc -vz service.local 8080

3. check HTTP response

    curl http://service.local:8080

## Common Failure Mode

`curl: (7)` usually means the network connection or port open step failed before any real HTTP response happened.

## Key Architectural Takeaway

Networking issues should be decomposed into name resolution, reachability, port binding, and application response.