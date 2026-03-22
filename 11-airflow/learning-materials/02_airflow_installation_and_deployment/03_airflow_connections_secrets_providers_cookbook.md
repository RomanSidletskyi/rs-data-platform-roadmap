# Airflow Connections, Secrets, and Providers Cookbook

## 1. Core concepts

### What is a Connection

A Connection in Airflow represents a reusable definition of how to connect to an external system.

It includes:

- host  
- login  
- password  
- schema / database  
- port  
- extra parameters  

Connections are referenced by `conn_id`.

#### Good strategy

Use Connections for all external systems:

- databases  
- APIs  
- cloud services  

#### Bad strategy

Hardcode credentials inside DAGs.

#### Why bad is bad

- security risk  
- no central management  
- hard to rotate credentials  

#### Example

    PostgresHook(postgres_conn_id="warehouse_db")

#### Production scenario

Credential rotation:

- connection updated once  
- all DAGs continue working  

If hardcoded:
- multiple DAGs break  
- emergency fixes required  

--------------------------------------------------

### What is a Variable

Variables store configuration values.

Examples:

- feature flags  
- thresholds  
- runtime parameters  

#### Good strategy

Use Variables for small configuration values.

#### Bad strategy

Use Variables for secrets.

#### Why bad is bad

- stored in metadata DB  
- visible in UI  
- security risk  

#### Example

    Variable.get("env")

--------------------------------------------------

### What is a Secret

Secrets are sensitive values:

- passwords  
- API keys  
- tokens  

#### Good strategy

Store secrets in:

- environment variables  
- secrets backend  

#### Bad strategy

Store secrets in DAG code or Variables.

#### Why bad is bad

- exposed credentials  
- compliance issues  

--------------------------------------------------

### What is a Provider

Providers are Airflow packages that integrate with external systems.

Examples:

- postgres provider  
- http provider  
- amazon provider  
- databricks provider  

#### Good strategy

Install only required providers.

#### Bad strategy

Install all providers blindly.

#### Why bad is bad

- dependency conflicts  
- larger image size  
- upgrade issues  

--------------------------------------------------

## 2. Storage strategy

### Where to store what

| Type        | Storage              |
|-------------|--------------------|
| config      | Variables           |
| credentials | Connections/Secrets |
| secrets     | Secrets backend     |

#### Good strategy

Separate config from secrets.

#### Bad strategy

Mix everything in one place.

#### Why bad is bad

- security issues  
- hard debugging  

--------------------------------------------------

## 3. Postgres cookbook

### Connection setup

Connection fields:

- host  
- db  
- user  
- password  

#### Example usage

    PostgresHook(postgres_conn_id="warehouse_db")

#### Good strategy

Use connection per database.

#### Bad strategy

Use one connection for all databases.

#### Why bad is bad

- unclear ownership  
- risky changes  

#### Production scenario

Single connection reused:

- credential change breaks multiple pipelines  

--------------------------------------------------

## 4. HTTP API cookbook

### Connection setup

Use HTTP connection with:

- base URL  
- auth headers  

#### Example

    HttpHook(method="GET", http_conn_id="api_service")

#### Good strategy

Handle retries and timeouts.

#### Bad strategy

Call API without retry logic.

#### Why bad is bad

- flaky pipelines  
- inconsistent results  

#### Production scenario

API temporary outage:

- without retry → pipeline fails  
- with retry → recovers automatically  

--------------------------------------------------

## 5. Databricks cookbook

### Connection setup

- host  
- token  

#### Example

    DatabricksSubmitRunOperator(
        databricks_conn_id="databricks_default"
    )

#### Good strategy

Store token in secrets backend.

#### Bad strategy

Hardcode token.

#### Why bad is bad

- security risk  
- token leaks  

#### Production scenario

Token expires:

- centralized update fixes all DAGs  

--------------------------------------------------

## 6. S3 cookbook

### Connection setup

Use AWS connection:

- access key  
- secret key  

#### Example

    S3Hook(aws_conn_id="aws_default")

#### Good strategy

Use IAM roles or managed credentials.

#### Bad strategy

Store keys in code.

#### Why bad is bad

- security risk  
- key rotation issues  

#### Production scenario

Key rotated:

- IAM role → no change needed  
- hardcoded key → failures  

--------------------------------------------------

## 7. dbt cookbook

### Running dbt

dbt runs as external process.

#### Example

    BashOperator(
        task_id="run_dbt",
        bash_command="dbt run"
    )

#### Good strategy

Store credentials in profiles.yml or env vars.

#### Bad strategy

Hardcode credentials.

#### Why bad is bad

- unsafe  
- not portable  

#### Production scenario

Moving environments:

- env-based config works  
- hardcoded breaks  

--------------------------------------------------

## 8. Providers

### What they are

Providers are integration packages.

#### Example install

    pip install apache-airflow-providers-postgres

#### Good strategy

Pin provider versions.

#### Bad strategy

Use latest without control.

#### Why bad is bad

- breaking changes  
- incompatibility  

#### Production scenario

Upgrade breaks DAG:

- version mismatch  
- operator behavior changes  

--------------------------------------------------

## 9. Secrets strategy

### Dev

- .env file  
- local secrets  

### Stage

- env vars  
- limited access  

### Prod

- secrets backend  
- strict access control  

#### Good strategy

Separate secrets by environment.

#### Bad strategy

Reuse same secrets everywhere.

#### Why bad is bad

- security risk  
- accidental production access  

--------------------------------------------------

## 10. Production anti-patterns

- hardcoded credentials  
- Variables used as secrets  
- one connection for everything  
- no retry for APIs  
- storing large data in XCom  

#### Why bad is bad

- security issues  
- unstable pipelines  
- poor maintainability  

--------------------------------------------------

## 11. Recommended patterns

### Small teams

- env vars  
- simple connections  

### Growing teams

- structured connections  
- config separation  

### Production

- secrets backend  
- strict access control  
- versioned providers  

--------------------------------------------------

## 12. Key principles

- never hardcode credentials  
- separate config and secrets  
- use connections for all integrations  
- use secrets backend in production  
- design for rotation and failure  

--------------------------------------------------