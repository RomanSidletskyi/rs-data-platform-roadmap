# Debugging, Security, And Common Failures

## 1. Why This Topic Matters

You should not leave this module thinking GitHub Actions is only about getting green checks.

The more important long-term skill is being able to understand why workflows fail and how to inspect them without guessing.

That is what turns CI/CD from ritual into engineering.

## 2. The First Rule Of Debugging

Do not start by editing random YAML.

Start by classifying the failure.

Ask:

- did the workflow trigger at all
- did the right job start
- did the failure happen in a specific step
- is the issue in workflow logic, runner environment, credentials, or application code

This classification step saves time.

## 3. Common Failure Areas

The most common sources of failure are:

- wrong trigger assumptions
- missing or insufficient permissions
- context or expression mistakes
- runner environment mismatch
- secret or variable scope errors
- artifact hand-off errors
- Docker login or registry permission issues
- hidden differences between branch, tag, and PR behavior

## 4. A Useful Debugging Order

When a workflow fails, inspect in this order:

1. did the correct event trigger the workflow
2. did the expected job run or get skipped
3. which exact step failed
4. what input values and conditions were active
5. whether the runner had the required tools and access
6. whether the problem is actually in the application under test

This keeps you from debugging the wrong layer.

## 5. Trigger Mistakes

Many beginner failures come from weak trigger assumptions.

Examples:

- expecting `push` behavior while testing a `pull_request` workflow
- forgetting branch filters
- assuming `workflow_dispatch` inputs exist in other event types

If the workflow never started, step debugging is irrelevant.

## 6. Condition And Context Mistakes

Another major source of bugs is misunderstanding conditions.

Examples:

- wrong branch reference value
- using the wrong `github.event` field
- mixing shell variables and GitHub expressions
- conditions that skip jobs silently when the author expected them to run

These failures often look mysterious until you check the actual event context.

## 7. Runner And Tooling Mismatch

The runner may not match your assumptions.

Examples:

- required CLI is missing
- Docker command behaves differently than expected
- network access is unavailable
- private resource is reachable only from self-hosted runner

This is why runner choice is a design concern.

## 8. Secret And Permission Failures

Security-related failures often appear as:

- authentication denied
- access forbidden
- token lacks required scope
- environment secret unavailable in current context

These are not random.

They usually indicate a clear ownership or permissions mismatch.

## 9. Artifact And State Failures

Jobs are isolated, so a common failure pattern is:

- job 1 creates a file
- job 2 expects that file to exist automatically
- job 2 fails because no artifact was uploaded or downloaded

This is not a strange platform bug.

It is a state transfer design problem.

## 10. Good Security Habits

- use explicit permissions where practical
- minimize secret exposure
- keep secret and non-secret config separate
- avoid echoing sensitive values
- attach sensitive deploy actions to intentional environment controls

## 11. Bad Security Habits

- print all environment variables while debugging
- broaden permissions until the workflow passes
- reuse one high-power secret everywhere
- let production mutation happen from weak branch policy

## 12. Why Bad Security Habits Are Dangerous

They create:

- credential leakage risk
- unclear blast radius
- workflows that pass once but are unsafe to trust
- future maintenance problems that are harder than the original bug

## 13. Debugging Mindset For Beginners

Healthy mindset:

- isolate the failing boundary
- understand the event context
- inspect exact step logs
- make one intentional change at a time

Unhealthy mindset:

- retry blindly
- add shell hacks until it passes
- change triggers, permissions, and scripts all at once

## 14. Key Takeaway

Reliable GitHub Actions work depends as much on failure analysis and security boundaries as on YAML syntax.