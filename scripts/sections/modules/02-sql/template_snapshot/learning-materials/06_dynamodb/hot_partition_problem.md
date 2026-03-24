# Hot Partition Problem

A hot partition happens when too much traffic targets one partition key.

## Example

Bad key:

```text
pk = country
```

If most traffic is:

```text
USA
```

then one partition becomes overloaded.

## Symptoms

- throttling
- latency spikes
- failed writes
- inconsistent operational performance

## Solutions

- choose better partition keys
- shard hot keys
- spread writes intentionally
- redesign access pattern
