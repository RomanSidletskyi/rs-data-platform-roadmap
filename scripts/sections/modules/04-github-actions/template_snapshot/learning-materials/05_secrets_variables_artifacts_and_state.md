# Secrets, Variables, Artifacts, And State

## 1. Why This Topic Is A Big Deal

Many weak CI/CD designs do not fail because the syntax is wrong.

They fail because nobody is fully clear about:

- where values come from
- which values are sensitive
- where outputs live between jobs
- which state is temporary and which state is important

In other words, the problem is ownership.

This file is about learning to ask:

Who owns this value and who is allowed to read it?

## 2. The Main Buckets You Need To Know

In GitHub Actions, the most important value and state buckets are:

- `secrets`
- `vars`
- `env`
- artifacts
- cache
- temporary runner filesystem

If you mix these carelessly, workflows become fragile and risky.

## 3. Secrets

Use secrets for sensitive values.

Typical examples:

- API tokens
- cloud access keys
- passwords
- registry credentials
- private webhook secrets

The rule is simple:

if disclosure would create security risk, treat it as a secret.

## 4. Variables

Use variables for non-secret configuration.

Typical examples:

- deployment region
- image name
- default environment label
- non-sensitive feature flags
- repository-level config choices

Variables help avoid hardcoding, but they do not provide secrecy.

## 5. `env`

`env` is how you expose values into the workflow, job, or step environment.

It is a delivery mechanism, not a security classification.

That means a secret may appear in `env`, but it is still conceptually a secret.

Likewise, a variable may appear in `env`, but it is still conceptually non-secret config.

This distinction matters.

Do not confuse the transport layer with the ownership type.

## 6. Artifacts

Artifacts are for outputs that need to survive beyond a single job or need to be inspected later.

Typical examples:

- test reports
- generated documentation
- packaged build outputs
- release metadata
- validation reports

Artifacts are especially useful because jobs are isolated from each other.

If one job produces something meaningful and another job needs it, artifacts are often the right bridge.

## 7. Cache

Cache is for speed optimization.

Typical examples:

- Python dependencies
- package manager caches
- toolchain cache

Cache is not a durable business output store.

Do not use cache as if it were a release artifact.

That is a common beginner mistake.

## 8. Temporary Runner Filesystem

Each job runs on a runner and can create local files during execution.

Those files are useful inside that job.

But unless you explicitly upload them as artifacts or pass structured outputs, they are usually lost after the job ends.

That is why “it worked in one step” is not enough.

You need to know whether the output should survive beyond that local execution context.

## 9. A Simple Decision Table

Use this mental model:

- secret -> sensitive credential or token
- variable -> non-secret configuration
- env -> runtime injection layer
- artifact -> traceable output shared or preserved after execution
- cache -> speed optimization for dependencies or tools
- runner file -> temporary local working state

## 10. Good Strategy

- keep secret ownership explicit
- know whether a value comes from `env`, `vars`, `secrets`, artifact store, or cache
- use artifacts for traceable hand-off between jobs
- treat cache as performance optimization only
- document what each workflow input and output actually means

## 11. Bad Strategy

- treating cache as durable state
- hiding business outputs inside temporary runner files
- mixing secret and non-secret config in one unclear layer
- putting secrets into logs
- allowing deployment jobs to depend on unclear mutable local state

## 12. Why Bad Is Bad

These mistakes lead to:

- unpredictable reruns
- weak deploy traceability
- hidden failure boundaries
- security review problems
- secret sprawl across jobs and environments

## 13. Example Classification

Here are example values and where they belong:

- `REGISTRY_PASSWORD` -> secret
- `DEPLOY_REGION` -> variable
- `IMAGE_NAME` -> variable
- generated `release_manifest.json` -> artifact
- pip dependency cache -> cache
- `/tmp/generated.txt` used only inside one job -> temporary runner file

## 14. Why This Is An Architectural Topic

At small scale, unclear state just feels messy.

At larger scale, unclear state causes real production risk.

Questions you should ask:

- if this job fails, what output do I still need
- if another job needs this file, how will it get it
- if I rerun this workflow tomorrow, which parts are reproducible
- if a secret leaks into logs, how serious is the blast radius

Those are architecture questions.

## 15. Shared References In This Repository

This repository already contains useful supporting references:

- `shared/environments/use-github-env.md`
- `shared/environments/who-reads-what.md`

Read those alongside this file when you want a stronger ownership model.

## 16. Key Takeaway

Strong GitHub Actions design depends on knowing exactly which system owns each value and each piece of state.