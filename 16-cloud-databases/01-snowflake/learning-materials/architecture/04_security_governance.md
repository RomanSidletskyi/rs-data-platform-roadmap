# Security and Governance Architecture

## Begin with Data and Trust Boundaries

Classify datasets and consumers before writing grants. Identify identities, operators, data owners, sensitive attributes, sharing partners, and administrative roles. Define which principals can create, read, change, share, and administer each data product.

## Role-Based Access Model

Use roles to represent job responsibilities and object ownership. Compose roles deliberately, keep administrative roles separate from daily-use roles, and grant the minimum required privileges at the narrowest sensible scope. Parent namespace usage and child object privileges are distinct. Decide how future objects receive grants and who owns grants after deployment.

Managed access schemas can centralize grant administration, which may reduce grant drift; they also require a clear release and ownership process. Test grants under real consumer roles rather than relying on an administrator session.

### Role hierarchy pattern: access roles and functional roles

```mermaid
flowchart BT
    subgraph Access["Access roles - privileges on objects"]
        AR1[SALES_MART_READ]
        AR2[SALES_RAW_WRITE]
        AR3[FINANCE_MART_READ]
    end
    subgraph Functional["Functional roles - job responsibilities"]
        FR1[ANALYST_SALES]
        FR2[ENGINEER_SALES]
        FR3[SVC_LOADER]
    end
    AR1 --> FR1
    AR1 --> FR2
    AR2 --> FR2
    AR2 --> FR3
    AR3 --> FR1
    FR1 --> SYS[SYSADMIN]
    FR2 --> SYS
    FR3 --> SYS
    SYS --> ACC[ACCOUNTADMIN]
    SEC[SECURITYADMIN] --> ACC
    USR[USERADMIN] --> SEC
```

Arrows point from a granted role to the role that receives it. Users get functional roles; functional roles get access roles; access roles hold object privileges. Roll custom roles up to `SYSADMIN` so administrators can manage the objects they create.

```sql
CREATE ROLE sales_mart_read;
GRANT USAGE ON DATABASE sales TO ROLE sales_mart_read;
GRANT USAGE ON SCHEMA sales.mart TO ROLE sales_mart_read;
GRANT SELECT ON ALL TABLES IN SCHEMA sales.mart TO ROLE sales_mart_read;
GRANT SELECT ON FUTURE TABLES IN SCHEMA sales.mart TO ROLE sales_mart_read;

CREATE ROLE analyst_sales;
GRANT ROLE sales_mart_read TO ROLE analyst_sales;
GRANT USAGE ON WAREHOUSE wh_bi TO ROLE analyst_sales;
GRANT ROLE analyst_sales TO ROLE sysadmin;
```

## Policy Layers

- **Secure views:** curated access interface and selected view protections.
- **Masking policies:** govern sensitive column values based on policy context.
- **Row access policies:** constrain visible rows.
- **Tags and classification:** make sensitivity and ownership discoverable.
- **Audit and access history:** support investigation and evidence.

These controls solve different problems and may be combined. Do not assume one policy protects paths through clones, exports, stages, other views, or broader grants.

For a complete implementation walkthrough combining a secure view, masking policy, and row access policy, see [Security Views](../deep-dives/02_security_views.md).

```mermaid
flowchart LR
    U[User with role] --> NP{Network policy and authentication}
    NP --> G{Grants on object?}
    G -- no --> DENY[Access denied]
    G -- yes --> RAP[Row access policy filters rows]
    RAP --> MP[Masking policy transforms column values]
    MP --> RES[Result]
    RES --> AH[(Access history for audit)]
```

### Example: tag-based masking and row access

```sql
CREATE MASKING POLICY governance.mask_email AS (val STRING) RETURNS STRING ->
  CASE WHEN IS_ROLE_IN_SESSION('PII_READER') THEN val
       ELSE REGEXP_REPLACE(val, '.+@', '***@')
  END;

CREATE TAG governance.pii;
ALTER TAG governance.pii SET MASKING POLICY governance.mask_email;
ALTER TABLE sales.mart.customers MODIFY COLUMN email SET TAG governance.pii = 'email';

CREATE ROW ACCESS POLICY governance.region_filter AS (row_region STRING) RETURNS BOOLEAN ->
  EXISTS (
    SELECT 1 FROM governance.region_entitlements e
    WHERE e.role_name = CURRENT_ROLE() AND e.region = row_region
  );

ALTER TABLE sales.mart.orders ADD ROW ACCESS POLICY governance.region_filter ON (region);
```

Masking, row access, and tag-based policies require Enterprise Edition or higher. Test each policy under every consumer role, including roles that query through views.

## Identity and Integrations

Separate human and service identities. Prefer supported federation or key-based methods with controlled rotation over embedded credentials. Scope external storage integrations narrowly. Network policies and private connectivity can reduce exposure but may complicate developers, automation, and failover; validate actual client paths and operational support.

## Governance Operating Model

Policies need owners, review cadence, test data, exception process, and change control. Data classification should connect to grants, masking, retention, and sharing. Lineage without ownership or incident procedures is descriptive metadata, not governance by itself.

```mermaid
sequenceDiagram
    actor A as Analyst
    participant T as Access request tool
    participant O as Data owner
    participant CI as Grants as code
    participant SF as Snowflake
    A->>T: request ANALYST_SALES
    T->>O: approve?
    O-->>T: approved, expires in 90 days
    T->>CI: pull request adding role grant
    CI->>SF: GRANT ROLE analyst_sales TO USER ...
    Note over T,SF: periodic recertification revokes unused access
```

## Trade-Offs

- Central policy improves consistency but can slow teams without a clear self-service path.
- Domain ownership improves accountability but needs shared naming, classification, and review standards.
- Fine-grained controls reduce exposure but increase testing, policy-debugging, and support effort.
- Strong network isolation narrows attack paths but can hinder integrations and recovery if untested.

## Decision Checklist

- What data classifications and consumers exist?
- Which roles own data and which roles consume it?
- Are grants for existing and future objects intentional?
- Are sensitive fields protected at every access path?
- Can a consumer's permissions be tested automatically and audited?
- Who owns exceptions, policy changes, and periodic recertification?