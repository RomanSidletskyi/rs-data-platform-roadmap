# Workflows, Events, Jobs, And Runners

## 1. Why Beginners Get Confused Here

Workflow YAML becomes much easier when you stop reading it as markup and start reading it as an execution graph.

Most beginner confusion comes from not knowing:

- what starts execution
- what runs in parallel
- what runs in sequence
- where the code is actually running

This file fixes that foundation.

## 2. Workflow

A workflow is a YAML file inside `.github/workflows/`.

It defines automation that GitHub can run.

A repository may have:

- one workflow for pull request validation
- one workflow for Docker release
- one workflow for manual maintenance tasks
- one workflow for nightly checks

Good repositories usually have several focused workflows instead of one giant file.

## 3. Event

An event is what starts a workflow.

Common events:

- `push`
- `pull_request`
- `workflow_dispatch`
- `schedule`
- `release`

Architecturally, the event answers the question:

Why is this automation running right now?

Examples:

- `pull_request` means "validate proposed change before merge"
- `push` to `main` often means "run post-merge automation"
- `workflow_dispatch` means "human-triggered controlled action"
- `schedule` means "time-based maintenance or periodic validation"

## 4. Job

A job is a major unit of execution within the workflow.

Jobs can run:

- independently
- in parallel
- or after another job using `needs`

Each job gets its own fresh runner environment unless you are using a different advanced setup.

That means files created in one job do not automatically appear in another job.

This is why artifacts matter later.

## 5. Step

A step is one action or one shell command inside a job.

Examples:

- checkout the repo
- set up Python
- install dependencies
- run tests
- upload an artifact

Steps run in order inside a job.

If one step fails, later steps in that job normally stop unless explicitly configured otherwise.

## 6. Action

An action is a reusable unit someone has packaged for use inside workflows.

Common examples:

- `actions/checkout`
- `actions/setup-python`
- `docker/login-action`

When you write `uses: ...`, you are calling an action.

When you write `run: ...`, you are running shell commands directly.

That distinction matters.

Use actions for reusable capability.

Use `run` for repository-specific commands.

## 7. Runner

A runner is the machine that executes a job.

Typical runner choices:

- GitHub-hosted runner such as `ubuntu-latest`
- self-hosted runner in your own infrastructure

The runner determines things like:

- operating system
- available tools
- performance characteristics
- network reachability
- security and trust boundary

This is architectural, not cosmetic.

If your job requires access to private network resources, runner choice becomes a real system design decision.

## 8. A Workflow As A Graph

Look at this example:

```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "lint"

  test:
    runs-on: ubuntu-latest
    needs: lint
    steps:
      - uses: actions/checkout@v4
      - run: echo "test"
```

This is not just text.

It describes a graph:

1. the workflow starts
2. `lint` runs first
3. `test` waits for `lint`
4. if `lint` fails, `test` does not start

## 9. Parallelism And Dependency Boundaries

If two jobs do not depend on each other, they can run in parallel.

That is useful when you want faster feedback.

Example:

- job 1: lint
- job 2: unit tests
- job 3: Docker build validation

But parallelism should follow meaning.

Do not split jobs only to look advanced.

Each job should represent a meaningful boundary.

## 10. Good Job Boundaries

Useful job splits often look like:

- `validate` for static checks
- `test` for runtime tests
- `build` for packaging
- `deploy` for controlled release steps

Why this works:

- failures are easier to localize
- reruns are easier to reason about
- deployment risk stays separate from code validation

## 11. Bad Job Boundaries

Weak job design often looks like:

- one job doing validation, packaging, and deployment together
- unrelated jobs split only for style, not meaning
- jobs depending on hidden files instead of explicit artifact passing

## 12. Why Runner Thinking Matters

A lot of beginner pain comes from treating `ubuntu-latest` like magic.

It is not magic.

It is just a runner environment.

Questions to ask:

- does it already have the CLI I need
- does it have Docker available
- can it reach private resources
- is it safe for the credentials this job uses

If the answer is "no", you need a different design.

## 13. Common Beginner Misunderstandings

Misunderstanding 1:

"A workflow is the same as a job."

No. A workflow can contain several jobs.

Misunderstanding 2:

"Files created in one job are automatically available in another."

No. Jobs are isolated unless you explicitly pass artifacts or outputs.

Misunderstanding 3:

"A runner already knows my repo state."

No. You normally need `actions/checkout` if the job needs repository files.

## 14. Beginner Checklist

When reading a workflow, identify these in order:

1. what event triggers it
2. what jobs exist
3. which jobs depend on which others
4. what runner each job uses
5. what output each job is supposed to produce

If you cannot answer those five questions, the workflow is not yet clear.

## 15. Key Takeaway

Most GitHub Actions confusion disappears once you understand that workflows are event-driven graphs executed on explicit runner environments.