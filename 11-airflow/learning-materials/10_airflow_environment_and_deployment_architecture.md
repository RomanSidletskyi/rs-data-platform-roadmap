# Airflow Environment and Deployment Architecture

## 1. Real environment model

### DEV environment

#### Purpose
- individual engineers
- shared development sandbox

#### What is validated
- DAG parsing works
- task logic executes
- connections exist and resolve
- no obvious runtime errors

#### Data
- synthetic data
- sandbox datasets
- reduced scale subsets

#### Secrets
- dev-only credentials
- limited access tokens

#### Risks
- accidental access to production systems
- false confidence due to small datasets

---

### STAGE environment

#### Purpose
- integration validation
- production-like testing

#### What is validated
- deployment process
- scheduler behavior under realistic conditions
- provider compatibility
- secrets injection
- database connectivity
- external integrations (APIs, storage)

#### Data
- masked production data
- controlled realistic datasets

#### Secrets
- stage-specific credentials

#### Risks
- environment drift vs prod
- unrealistic load → false success

---

### PROD environment

#### Purpose
- real pipelines
- real SLAs
- real data contracts

#### What is NOT tested first time here
- DAG parsing
- dependency installation
- secrets wiring

#### Risks
- real business impact
- downstream corruption
- silent failures

---

### Good strategy

Strict isolation:

- dev != stage != prod
- separate infra, data, secrets

### Bad strategy

Single shared environment.

### Why bad is bad

- accidental data corruption
- no safe testing layer

---

## 2. Real deployment flow (end-to-end)

### Step 1. Commit code

Includes:

- DAG files
- shared Python utilities
- tests
- requirements / providers
- deployment configs

---

### Step 2. Run CI

Runs:

- linting
- formatting
- import tests
- DagBag parsing
- unit tests
- optional compatibility checks

---

### Step 3. Deploy to DEV

Deployed:

- DAG code
- Python dependencies or image
- dev config
- dev secrets

---

### Step 4. Validate in DEV

Check:

- DAG visible in UI
- no import errors
- task test works

    airflow tasks test <dag_id> <task_id> 2024-01-01

- full DAG run
- logs readable
- outputs correct

---

### Step 5. Promote to STAGE

Important:

- SAME artifact (no rebuild)
- only config/secrets change

---

### Step 6. Validate in STAGE

Check:

- scheduler stability
- secrets injected correctly
- connections valid
- outputs compatible

---

### Step 7. Promote to PROD

Requirements:

- same artifact
- prod config injected
- rollout defined
- rollback ready

---

### Good strategy

Immutable promotion.

### Bad strategy

Rebuild per environment.

### Why bad is bad

- inconsistent behavior
- hard debugging

---

## 3. Configuration differences (real examples)

### Environment variables

#### DEV

    POSTGRES_HOST=dev-postgres.internal
    S3_RAW_BUCKET=company-dev-raw
    DBT_TARGET=dev
    ALERT_SLACK_CHANNEL=#airflow-dev

#### STAGE

    POSTGRES_HOST=stage-postgres.internal
    S3_RAW_BUCKET=company-stage-raw
    DBT_TARGET=stage
    ALERT_SLACK_CHANNEL=#airflow-stage

#### PROD

    POSTGRES_HOST=prod-postgres.internal
    S3_RAW_BUCKET=company-prod-raw
    DBT_TARGET=prod
    ALERT_SLACK_CHANNEL=#airflow-prod

---

### What goes where

| Type | Purpose |
|------|--------|
| Env vars | environment config |
| Connections | external systems |
| Variables | runtime config |
| Secrets | sensitive data |

---

### Good strategy

Strict separation.

### Bad strategy

Reuse config across environments.

### Why bad is bad

- wrong systems accessed
- data corruption

---

## 4. Deployment artifact models

### Model A: DAG file deployment

Deploy:

    dags/
    plugins/
    requirements.txt

#### Use case

- small teams
- VM-based setup

#### Risks

- dependency mismatch
- environment drift
- difficult rollback

---

### Model B: Docker image

Includes:

- DAGs
- dependencies
- plugins

Excludes:

- secrets
- env config

#### Benefits

- reproducibility
- consistent behavior
- easy rollback

---

### Good strategy

Use immutable artifact (image).

### Bad strategy

Manual file sync.

### Why bad is bad

- inconsistent environments

---

## 5. CI configuration example (GitHub Actions style)

    name: airflow-ci

    on: [push]

    jobs:
      test:
        runs-on: ubuntu-latest

        steps:
        - uses: actions/checkout@v2

        - name: Setup Python
          uses: actions/setup-python@v2
          with:
            python-version: 3.9

        - name: Install deps
          run: pip install -r requirements.txt

        - name: Lint
          run: flake8 dags/

        - name: Test DAG import
          run: pytest tests/

---

### What each step does

- checkout → fetch code
- setup python → consistent runtime
- install deps → detect dependency issues
- lint → style + errors
- tests → DAG correctness

---

## 6. CD configuration example

### DEV deploy

- trigger: merge to develop
- deploy DAG/image
- run smoke tests

---

### STAGE deploy

- trigger: tag or manual
- deploy same artifact
- run integration tests

---

### PROD deploy

- manual approval
- deploy same artifact
- monitor first runs

---

### Good strategy

Controlled promotion.

### Bad strategy

Auto deploy to prod.

### Why bad is bad

- high risk

---

## 7. Separation of config, secrets, data

### Config

- bucket names
- DB schemas
- endpoints

---

### Secrets

- DB passwords
- API tokens
- cloud credentials

---

### Data

- dev uses dev datasets
- prod uses prod datasets

---

### Critical rule

Dev must never write to prod.

---

### Production scenario

Dev DAG writes to prod bucket:

- corrupts production data

---

## 8. What full CI/CD really means

- Git required
- automated validation required
- immutable artifact preferred
- staged promotion required
- rollback required
- smoke tests required

---

## 9. Real keys and parameters

### Airflow env variables

    AIRFLOW__CORE__EXECUTOR=CeleryExecutor
    AIRFLOW__DATABASE__SQL_ALCHEMY_CONN=postgresql://...
    AIRFLOW__CORE__FERNET_KEY=...
    AIRFLOW__LOGGING__REMOTE_LOGGING=True

---

### Connections

- postgres_orders
- warehouse_db
- customer_api
- aws_default
- databricks_default

---

### Variables

- alert_channel
- dbt_project_dir
- feature_flag

---

### Secrets

- API keys
- DB passwords
- tokens

---

## 10. Rollback strategy

Steps:

- revert commit
- redeploy previous artifact
- pause DAG
- validate scheduler parsing
- rerun safe intervals

---

### Good strategy

Rollback ready before deploy.

### Bad strategy

Fix manually in prod.

### Why bad is bad

- inconsistent state

---

## 11. Dangerous changes

- rename task_id
- rename dag_id
- change output path
- change interval logic
- change schedule

---

### Production scenario

Task renamed:

- state lost
- duplicate runs

---

## 12. Anti-patterns

- dev using prod DB
- shared secrets
- manual deployments
- inconsistent artifacts

---

## 13. Final checklist

- environments isolated  
- configs separated  
- secrets secured  
- artifact immutable  
- CI automated  
- CD controlled  
- rollback ready  

--------------------------------------------------