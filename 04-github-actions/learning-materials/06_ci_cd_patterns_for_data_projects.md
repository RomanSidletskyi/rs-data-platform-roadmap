# CI/CD Patterns For Data Projects

## 1. Why Data Repositories Need Intentional CI/CD

Data repositories are often more mixed than simple application repositories.

One repo may contain:

- Python code
- SQL or dbt models
- Docker assets
- workflow definitions
- environment config
- deployment metadata

That means one generic copied pipeline is rarely the best answer.

The shape of CI/CD should match repository responsibilities.

## 2. The Main Pipeline Families

Most healthy delivery setups split into several kinds of automation:

- pull request validation
- post-merge build or package flow
- release preparation
- protected deploy or promotion flow
- scheduled validation or maintenance flow

Not every repository needs all of them.

But most non-trivial repositories need more than one.

## 3. Pull Request Validation

This is usually the first and most important CI layer.

Its purpose is not to deploy.

Its purpose is to validate proposed change before merge.

Typical checks:

- formatting and lint checks
- tests
- static validation
- dependency resolution check
- Docker build validation if relevant
- workflow or config validation if relevant

What this stage should produce:

- fast feedback
- visible quality gate
- low blast radius

## 4. Post-Merge Build Or Packaging

Some repositories need a second automation path after code is merged.

Typical responsibilities:

- build a package
- produce a Docker image
- create release metadata
- publish documentation or artifacts

This is different from pull request validation because now the code state is accepted branch state, not speculative review state.

## 5. Controlled Deploy

Deploy automation is where operational risk becomes real.

Typical characteristics of a healthy deploy flow:

- runs only from trusted branch or tag state
- depends on earlier validation or build jobs
- uses protected environments where appropriate
- makes version or artifact identity explicit
- preserves enough information for rollback reasoning

## 6. Scheduled Validation

Schedules are useful for:

- drift checks
- recurring health checks
- dependency refresh validation
- long-running but non-urgent quality checks

But schedules should not become a dumping ground for unclear automation.

Use them when time-based execution has real meaning.

## 7. Data-Project Specific Patterns

### Pattern A - Python Utility Repository

Often needs:

- PR test and lint workflow
- optional packaging or release workflow

### Pattern B - Dockerized Batch Or Service Repository

Often needs:

- PR image build validation
- main-branch publish workflow
- optional deploy workflow

### Pattern C - dbt Repository

Often needs:

- PR validation
- state-aware build strategy
- environment-targeted deployment after merge

### Pattern D - Airflow Repository

Often needs:

- DAG validation in CI
- packaging or artifact creation
- controlled environment promotion

## 8. A Good Split Of Responsibilities

In a broader data platform, a useful high-level split often looks like this:

- GitHub Actions -> CI/CD and repository automation
- Airflow -> orchestration of runtime pipelines
- Databricks or Spark platform -> compute-heavy execution
- dbt -> transformation logic and tests

This split prevents GitHub Actions from becoming a forced replacement for tools with different jobs.

## 9. Good Strategy

- separate PR CI from release or deploy automation
- keep production deploy gated and intentional
- align workflows with repository responsibilities
- keep runtime orchestration in the right platform
- use artifacts and environments to preserve traceability

## 10. Bad Strategy

- every push triggers all heavy workflows
- one workflow mixes validation, release, and infrastructure mutation
- deploys happen from weakly controlled states
- GitHub Actions is used as a substitute for every other system

## 11. Why Bad Is Bad

These mistakes cause:

- higher cost
- slower feedback
- more fragile automation
- weaker production trust
- harder rollback and incident analysis

## 12. Design Questions To Ask

Before writing a pipeline, ask:

- what kind of repository is this
- what needs validation before merge
- what needs to be built only after merge
- what is the deploy boundary
- does this workflow mutate production or only validate code
- which artifacts must be traceable

## 13. Key Takeaway

CI/CD for data projects should be shaped around repository risk boundaries, not around copying a generic pipeline template blindly.