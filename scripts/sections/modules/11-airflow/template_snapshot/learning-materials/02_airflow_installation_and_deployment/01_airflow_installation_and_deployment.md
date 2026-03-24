# Airflow Installation and Deployment (Architect-Level)

## 1. Installation strategy

### Why installation approach matters

Airflow installation is not just about running the tool. It defines:

- how stable your pipelines are  
- how scalable your system is  
- how easy it is to debug failures  
- how safely you can deploy changes  

A bad installation approach leads to system-wide instability even if DAGs are correct.

--------------------------------------------------

### Local vs production mindset

There are 3 different contexts:

- learning environment  
- development environment  
- production environment  

They must not be treated the same.

#### Good strategy

Separate environments clearly:

- local → for testing DAG logic  
- dev/stage → for integration  
- prod → for real pipelines  

#### Bad strategy

Use the same setup everywhere.

#### Why bad is bad

- production bugs leak into development  
- unstable deployments  
- hard to debug environment-specific issues  

--------------------------------------------------

### Why Docker-first approach

Docker allows you to:

- replicate production-like environment  
- isolate dependencies  
- control versions  
- avoid “works on my machine” problems  

#### Good strategy

Use Docker as the base for all environments.

#### Bad strategy

Install Airflow directly via pip in production.

#### Why bad is bad

- dependency conflicts  
- inconsistent environments  
- hard upgrades  

#### Example

    # bad
    pip install apache-airflow

    # good
    docker-compose up airflow

--------------------------------------------------

## 2. Simple local setup (for understanding)

### Purpose

This setup is only for:

- understanding Airflow basics  
- quick experiments  

It is not suitable for production.

#### Example

    airflow db init
    airflow users create
    airflow webserver
    airflow scheduler

#### Good strategy

Use this only to understand:

- DAG behavior  
- UI  
- scheduling  

#### Bad strategy

Use this setup for real pipelines.

#### Why bad is bad

- no scalability  
- no isolation  
- no reliability  

#### Production failure scenario

Single process Airflow:

- scheduler crash → everything stops  
- no retry system across workers  
- no parallelism  

--------------------------------------------------

## 3. Docker-based setup (recommended baseline)

### Why Docker setup is important

Docker setup simulates:

- multiple services  
- distributed execution  
- real dependencies  

#### Typical components in Docker

- webserver  
- scheduler  
- worker  
- metadata database  
- message broker  

#### Good strategy

Use Docker Compose with:

- separate containers per component  
- shared volumes for DAGs and logs  

#### Bad strategy

Run everything in one container.

#### Why bad is bad

- no isolation  
- hard debugging  
- scaling impossible  

#### Example

    services:
        scheduler:
        webserver:
        worker:
        postgres:
        redis:

--------------------------------------------------

## 4. Git-based workflow

### Why Git is critical

Airflow DAGs are code and must be:

- versioned  
- reviewed  
- tested  

#### Good strategy

Use Git for:

- DAG code  
- configuration  
- deployment  

#### Bad strategy

Edit DAGs directly on server.

#### Why bad is bad

- no history  
- no rollback  
- inconsistent environments  

#### Production failure scenario

Manual DAG change:

- breaks pipeline  
- no version to revert  
- debugging becomes impossible  

--------------------------------------------------

## 5. Project structure

### Recommended structure

    dags/
    plugins/
    logs/
    config/
    requirements/
    common/

### Explanation

- dags → workflow definitions  
- plugins → custom logic  
- logs → execution logs  
- config → configuration files  
- common → shared utilities  

#### Good strategy

Separate concerns by folder.

#### Bad strategy

Put everything in DAG files.

#### Why bad is bad

- hard to maintain  
- code duplication  
- no modularity  

--------------------------------------------------

## 6. Configuration (airflow.cfg + env vars)

### How configuration works

Airflow configuration is defined by:

- airflow.cfg  
- environment variables  

Environment variables override config file.

#### Good strategy

Use environment variables for dynamic configuration.

#### Bad strategy

Hardcode values inside DAGs.

#### Why bad is bad

- environment-specific bugs  
- security risks  
- difficult deployments  

#### Example

    AIRFLOW__CORE__EXECUTOR=CeleryExecutor

--------------------------------------------------

## 7. Variables, Connections, Secrets

### Airflow Variables

Used for:

- configuration values  
- runtime parameters  

#### Good strategy

Store small configuration values.

#### Bad strategy

Store secrets or large data.

#### Why bad is bad

- security risk  
- metadata DB overload  

--------------------------------------------------

### Airflow Connections

Used for:

- database access  
- API credentials  
- external services  

#### Example

    conn_id = "postgres_db"

#### Good strategy

Use connections for all external systems.

#### Bad strategy

Hardcode credentials in code.

#### Why bad is bad

- security issues  
- hard to rotate credentials  

--------------------------------------------------

### Environment variables

Used for:

- system-level configuration  
- secrets injection  

#### Good strategy

Store secrets in environment variables or secret manager.

#### Bad strategy

Store secrets in code or Variables.

#### Why bad is bad

- exposed credentials  
- compliance issues  

--------------------------------------------------

### Secrets backend

Used for:

- secure storage of secrets  

Examples:

- AWS Secrets Manager  
- HashiCorp Vault  

#### Good strategy

Use secrets backend in production.

#### Bad strategy

Store secrets in Airflow DB.

#### Why bad is bad

- security vulnerability  
- difficult rotation  

--------------------------------------------------

## 8. External system connections

### Databases

Airflow connects using Connections.

#### Example

    postgres_conn

### APIs

Use HTTP connections.

### Spark / Databricks

Trigger jobs externally.

#### Good strategy

Keep connections abstracted.

#### Bad strategy

Embed connection logic in tasks.

#### Why bad is bad

- duplication  
- maintenance complexity  

--------------------------------------------------

## 9. Environments (dev / stage / prod)

### Environment separation

- dev → testing  
- stage → integration  
- prod → production  

#### Good strategy

Separate environments physically.

#### Bad strategy

Use single environment.

#### Why bad is bad

- unstable deployments  
- production incidents  

--------------------------------------------------

## 10. Executors

### Types

- SequentialExecutor  
- LocalExecutor  
- CeleryExecutor  
- KubernetesExecutor  

#### Good strategy

Use distributed executors in production.

#### Bad strategy

Use SequentialExecutor in production.

#### Why bad is bad

- no parallelism  
- slow pipelines  

--------------------------------------------------

## 11. Production infrastructure

### Components

- scheduler  
- workers  
- webserver  
- metadata DB  
- broker  

### Resource thinking

- scheduler → CPU + DB latency sensitive  
- workers → CPU + memory heavy  
- DB → critical bottleneck  

#### Good strategy

Scale components independently.

#### Bad strategy

Single-node deployment.

#### Why bad is bad

- single point of failure  
- no scaling  

#### Production failure scenario

Metadata DB slow:

- scheduler slows  
- tasks delayed  
- entire system impacted  

--------------------------------------------------

## 12. Failure scenarios

### Scheduler lag

- DAGs parsed slowly  
- tasks scheduled late  

### Worker overload

- queue grows  
- tasks delayed  

### DB bottleneck

- scheduler blocked  
- state updates slow  

#### Good strategy

Monitor all components.

#### Bad strategy

Ignore system metrics.

#### Why bad is bad

- silent failures  
- SLA violations  

--------------------------------------------------

## 13. Common mistakes

- using SQLite in production  
- storing secrets in code  
- large XCom usage  
- monolithic DAGs  
- no environment separation  

--------------------------------------------------

## 14. Summary

Airflow installation defines system behavior.

Key principles:

- use Docker  
- separate environments  
- use Git  
- manage secrets properly  
- design for scalability  
- monitor system health  

--------------------------------------------------