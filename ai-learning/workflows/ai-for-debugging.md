# AI For Debugging

## Goal

Use AI to structure debugging, not to jump straight to random fixes.

## Scenario

You have a bug, failed test, broken pipeline step, or suspicious output.

The main danger is not that AI will be useless.

The main danger is that AI will offer a plausible fix before the actual cause is isolated.

## Workflow

1. Capture the exact failing behaviour.
2. Reduce the problem to the smallest reproducible case.
3. Ask AI for likely root causes and quick tests for each hypothesis.
4. Run the tests yourself.
5. Apply the smallest fix that addresses the real cause.
6. Re-run the failing path and nearby checks.

## Example Prompt

```text
I have a pipeline regression where duplicate customer events appear only after replay. Here is the failing behavior, the current merge logic, and the expected invariant. Propose 3 likely root causes, the smallest test for each one, and the signal that would confirm or reject each hypothesis.
```

## Validation

Before accepting a fix, confirm:

- the failure is reproducible before the change
- the chosen hypothesis is supported by evidence
- the fix changes the failing path for the right reason
- adjacent behavior still holds after the change

## Failure Modes

- accepting the first plausible fix
- asking for code changes before isolating the failing invariant
- testing only the happy path after the fix

## Why This Works

This workflow forces AI to act as a hypothesis generator and debugging assistant, not as a random patch generator.

That preserves causal reasoning.

## Real Example

Problem:

Replayed customer events created duplicates in a silver table even though the pipeline claimed idempotent behavior.

Useful AI question:

- what conditions would make a merge-based deduplication step fail only on replay and not on first ingestion

Code-backed case:

```python
def apply_events(existing_ids, incoming_events):
	output = []
	for event in incoming_events:
		if event["event_id"] not in existing_ids:
			output.append(event)
			existing_ids.add(event["event_id"])
	return output
```

AI can help ask the right debugging questions:

- is `existing_ids` loaded from a trustworthy state before replay starts
- can `event_id` change format between first ingestion and replay
- is deduplication happening before or after schema normalization

This turns debugging from guesswork into hypothesis testing.

## Failure Mode To Avoid

Do not accept the first plausible fix if the cause has not been verified.
