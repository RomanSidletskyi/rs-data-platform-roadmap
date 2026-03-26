# Review Communication Comparison

This guide compares weak, acceptable, and strong design-review and review-comment communication.

## Weak Pattern

```text
This should be fine.
```

Why it fails:

- no reason
- no trade-off
- no testable claim

## Acceptable Pattern

```text
I think this is better because the flow is simpler.
```

Why it is only acceptable:

- there is at least a reason
- but it is vague and not tied to risk or consequence

## Strong Pattern

```text
This option reduces operational complexity because replay and validation stay in one place.
The trade-off is lower flexibility if we later need different publish paths for multiple consumers.
The main open question is whether downstream contract stability matters more than short-term implementation speed.
```

## Rule

Strong review communication usually has four elements:

- the decision
- the reason
- the trade-off
- the open question or risk