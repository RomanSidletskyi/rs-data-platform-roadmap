# Mistakes Log

Use a mistakes log when you want failure modes to become system improvements.

## What To Record

- the mistake
- why it happened
- what signal was missed
- what rule or checklist should prevent it next time

## Example Entry

- mistake: accepted an AI rewrite of a design note that removed an important contract assumption
- why it happened: optimized for smoother prose, not decision fidelity
- missed signal: the rewritten note became shorter but also less explicit about downstream consumers
- prevention rule: compare rewritten technical notes line by line for lost assumptions

## Why This Works

Repeated mistakes often come from missing operating rules, not from missing intelligence.

Once the rule is explicit, the same failure becomes less likely.

## Rule

Do not log mistakes for guilt.

Log them to design better constraints.