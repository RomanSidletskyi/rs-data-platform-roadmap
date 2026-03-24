# Simple Tasks: Reliability, Quality, And Recovery

## Task 1: Idempotent Design

Explain what it means for a Delta load to be idempotent.

Then explain why retries can be dangerous without idempotent boundaries.

## Task 2: Restore Versus Narrow Repair

A bad write affected three days of data, but newer valid writes also exist.

Explain whether full table restore is obviously the best answer.

## Task 3: VACUUM Risk

Explain why VACUUM is not only a storage cleanup command.

## Task 4: Quality Enforcement

Describe one quality rule that should fail loudly in a silver table and explain why silent success would be harmful.
