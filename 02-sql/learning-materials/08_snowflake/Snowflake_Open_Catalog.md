# Snowflake Open Catalog

## 1. Why This Topic Matters

Teams often hear three similar phrases and mix them together:

- Snowflake-managed Iceberg
- externally managed Iceberg
- Snowflake Open Catalog

They are related, but they are not the same thing.

The first two are table-governance patterns inside Snowflake architecture.

Open Catalog is something different.

It is a managed REST catalog service for Apache Iceberg.

That means Open Catalog is not just another table flavor.

It is a catalog-layer product that can sit between multiple engines.

At architect level, this matters because the real design question is often:

- where should the Iceberg control plane live?

Open Catalog is one answer to that question.

---

## 2. What Open Catalog Is

Snowflake Open Catalog is a managed implementation of the Apache Iceberg REST catalog protocol.

Snowflake describes it as a managed service for Apache Polaris.

In practical terms, Open Catalog provides:

- a central metadata authority for Iceberg tables
- REST-compatible access for multiple query engines
- centralized RBAC for catalog, namespace, and table access
- optional credential vending for table storage access

Mental model:

- Iceberg table format defines how table metadata works
- catalog defines where the current metadata pointer is managed
- Open Catalog is one managed implementation of that catalog layer

That is why Open Catalog should be compared first to:

- Glue catalog
- REST catalog services
- Unity-like catalog layers

not first to:

- native Snowflake tables

---

## 3. Why It Sits Between Managed And Externally Managed Iceberg

Open Catalog is the bridge topic because it can participate in both directions.

### Direction 1: Open Catalog as the external catalog

In this model:

- Open Catalog is the metadata authority
- Snowflake queries a table registered in Open Catalog by creating an externally managed Iceberg table

Here Open Catalog belongs conceptually with externally managed Iceberg.

### Direction 2: Open Catalog as a sync target for Snowflake-managed Iceberg

In this model:

- Snowflake still owns the table as a Snowflake-managed Iceberg table
- Snowflake syncs that table into an external catalog in Open Catalog
- external engines can query the synced table through Open Catalog

Here Open Catalog belongs conceptually near Snowflake-managed Iceberg.

That is why Open Catalog is a bridge concept, not only a subtopic of one side.

---

## 4. Core Concepts

### 4.1 Catalog

A catalog is the top-level metadata container.

Open Catalog supports:

- internal catalogs
- external catalogs

Internal catalog means:

- Open Catalog manages the catalog itself
- engines interact through Open Catalog as the catalog authority

External catalog means:

- another provider is the source of the catalog
- tables are synced into Open Catalog
- in the current Snowflake docs, the Snowflake external catalog is the key example

### 4.2 Namespace

Open Catalog uses namespaces to organize tables.

Namespaces are closest to schemas, but Open Catalog also supports nested namespaces.

This is important because namespace structure affects:

- object naming
- interoperability
- access-control scoping
- how Snowflake database and schema names map into Open Catalog paths

### 4.3 Service principal

Open Catalog access is built around service principals, not Snowflake users.

This is a major architecture difference.

Engines connect to Open Catalog through service principals.

### 4.4 Principal roles and catalog roles

Open Catalog RBAC is two-layered:

- catalog roles hold privileges on catalogs, namespaces, and tables
- principal roles are assigned to service principals

This is not identical to Snowflake's access model.

If your team ignores this distinction, the security model will be misunderstood.

### 4.5 Credential vending

Open Catalog can vend temporary storage credentials to engines.

This is important because it can centralize:

- metadata authorization
- storage access authorization

But it also creates a strict requirement:

- table storage directories must not overlap in dangerous ways

Otherwise a principal with access to one table may reach another table's files.

---

## 5. Open Catalog Versus Other Control Planes

### Open Catalog vs Snowflake-managed Iceberg

Snowflake-managed Iceberg answers:

- Snowflake should own the table metadata control plane

Open Catalog answers:

- a shared REST-catalog control plane should exist outside any one query engine

These can work together when Snowflake-managed tables are synced into Open Catalog.

### Open Catalog vs externally managed Iceberg

Externally managed Iceberg in Snowflake is the table-registration pattern.

Open Catalog is one possible external catalog behind that pattern.

So the relationship is:

- externally managed Iceberg = Snowflake-side access pattern
- Open Catalog = possible remote control plane that Snowflake connects to

### Open Catalog vs Glue

Both can act as external metadata authorities.

Open Catalog is stronger when:

- you want a REST-native, multi-engine service with centralized RBAC and service-principal model

Glue is often the natural choice when:

- AWS-centered Spark or lakehouse tooling already uses Glue as the platform default

---

## 6. Main Architecture Modes

## 6.1 Mode A: Query Open Catalog tables from Snowflake

This is the read path.

Open Catalog owns the table registration.

Snowflake creates an externally managed Iceberg table that points to Open Catalog.

Representative integration example:

```sql
CREATE OR REPLACE CATALOG INTEGRATION open_catalog_int
  CATALOG_SOURCE = POLARIS
  TABLE_FORMAT = ICEBERG
  CATALOG_NAMESPACE = 'analytics'
  REST_CONFIG = (
    CATALOG_URI = 'https://org-account.snowflakecomputing.com/polaris/api/catalog'
    CATALOG_NAME = 'central_catalog'
  )
  REST_AUTHENTICATION = (
    TYPE = OAUTH
    OAUTH_CLIENT_ID = 'my-client-id'
    OAUTH_CLIENT_SECRET = 'my-client-secret'
    OAUTH_ALLOWED_SCOPES = ('PRINCIPAL_ROLE:ALL')
  )
  ENABLED = TRUE;
```

Representative table registration:

```sql
CREATE ICEBERG TABLE analytics.orders_oc
  CATALOG = 'OPEN_CATALOG_INT'
  EXTERNAL_VOLUME = 'LAKEHOUSE_EXT_VOL'
  CATALOG_TABLE_NAME = 'orders'
  AUTO_REFRESH = TRUE;
```

Representative query:

```sql
SELECT order_date, COUNT(*) AS orders_cnt
FROM analytics.orders_oc
GROUP BY order_date
ORDER BY order_date;
```

Important nuance:

- in this pattern, the Snowflake table is a read-only externally managed representation of the Open Catalog table

### 6.2 Mode B: Sync Snowflake-managed Iceberg to Open Catalog

This is the publish path.

Snowflake remains the producer authority for the table.

Open Catalog becomes the external access layer for other engines.

Representative catalog integration:

```sql
CREATE OR REPLACE CATALOG INTEGRATION my_open_catalog_int
  CATALOG_SOURCE = POLARIS
  TABLE_FORMAT = ICEBERG
  REST_CONFIG = (
    CATALOG_URI = 'https://org-account.snowflakecomputing.com/polaris/api/catalog'
    CATALOG_NAME = 'snowflake_sync_catalog'
  )
  REST_AUTHENTICATION = (
    TYPE = OAUTH
    OAUTH_CLIENT_ID = 'my-client-id'
    OAUTH_CLIENT_SECRET = 'my-client-secret'
    OAUTH_ALLOWED_SCOPES = ('PRINCIPAL_ROLE:ALL')
  )
  ENABLED = TRUE;
```

Representative sync configuration:

```sql
ALTER DATABASE analytics_db
  SET CATALOG_SYNC = 'MY_OPEN_CATALOG_INT';
```

Representative table creation:

```sql
CREATE OR REPLACE ICEBERG TABLE analytics_db.curated.orders_publish (
  order_id NUMBER,
  order_date DATE,
  net_amount NUMBER(18,2)
)
CATALOG = 'SNOWFLAKE'
EXTERNAL_VOLUME = 'LAKEHOUSE_EXT_VOL';
```

Important nuance:

- changes made in Snowflake are synchronized to Open Catalog
- other engines can query through Open Catalog
- synced Snowflake-managed tables are read-only in Open Catalog

### 6.3 Mode C: Open Catalog as a multi-engine governance plane

This is the broader platform model.

In this mode you think less about one table and more about:

- one central REST catalog service
- multiple engines using service principals
- centralized access control and possibly credential vending

This is the mode where Open Catalog behaves like a true platform product, not only a connector.

---

## 7. Directory Layout And Storage Discipline Matter

Open Catalog docs are very explicit about storage-layout discipline.

Rules that matter:

- a directory should contain files for one table only
- namespace hierarchy should align with directory hierarchy
- overlapping directory locations are dangerous, especially with credential vending

Why this matters:

- access control can leak across tables if paths overlap badly
- sync and discoverability become harder to reason about
- operational cleanup becomes risky

Architectural rule:

- storage layout is part of your security model, not just your file organization style

---

## 8. Security Model

Open Catalog security is important enough to study separately from SQL.

### 8.1 Service-principal-first model

Engines connect using service principals.

That means your real security units are not analysts or developers directly.

They are:

- Spark ETL principal
- Snowflake pipeline principal
- Trino BI principal
- Flink ingestion principal

This is actually good platform design because access becomes workload-oriented.

### 8.2 RBAC model

The model is:

- privileges are granted to catalog roles
- catalog roles are granted to principal roles
- principal roles are attached to service principals

Architect takeaway:

- this is a control-plane security system, not only a table registration convenience

### 8.3 Credential vending

Credential vending can remove the need to separately manage storage credentials for engines.

That is powerful.

But only if you respect path isolation.

If table directories overlap, credential vending can widen storage access accidentally.

---

## 9. When To Use Open Catalog

Open Catalog is strong when:

- you want a managed REST catalog for Iceberg
- multiple engines need a central metadata authority
- you want centralized service-principal and RBAC governance
- you want Snowflake and non-Snowflake engines to meet at the catalog layer
- you want Snowflake-managed Iceberg to be queryable by other engines through a governed external catalog

Open Catalog is weaker when:

- Snowflake-only consumption is the real use case
- native Snowflake tables solve the problem already
- the team has no operational maturity for multi-engine governance
- another catalog such as Glue already exists and is working well enough

---

## 10. When Not To Use It

Do not use Open Catalog only because it sounds more open or more modern.

Avoid it when:

- you do not need a shared catalog control plane
- there is no real multi-engine consumer story
- the team cannot maintain namespace, storage, and principal-role discipline
- you are trying to avoid making a clearer ownership decision between Snowflake-managed and externally managed designs

Open Catalog does not remove architecture decisions.

It makes them more explicit.

---

## 11. Open Catalog Versus Horizon Catalog

Snowflake docs explicitly note another pattern:

- external engines can also access Snowflake-managed Iceberg through Snowflake Horizon Catalog in some scenarios

Practical takeaway:

- Open Catalog is not the only interoperability path
- if the goal is only external querying of Snowflake-managed Iceberg, compare Open Catalog sync against Horizon access before locking the design

This is exactly the kind of architect-level comparison teams often skip.

---

## 12. Architecture Decision Heuristics

Choose Open Catalog when:

- you want a central REST catalog service
- you want Snowflake and non-Snowflake engines to share one governed catalog endpoint
- service-principal-driven governance is a feature, not a burden
- you need a bridge between Snowflake-managed publish patterns and externally managed read patterns

Prefer Snowflake-managed Iceberg without Open Catalog when:

- Snowflake remains the true owner and external-engine access is not required

Prefer externally managed Iceberg without emphasizing Open Catalog when:

- another external catalog such as Glue is already the real control plane

Prefer native Snowflake tables when:

- Snowflake is the only serious engine and simplicity is worth more than openness

---

## 13. Interview-Ready Summary

Strong short answer:

> Snowflake Open Catalog is not just another Snowflake table type. It is a managed Iceberg REST catalog service. Architecturally, it sits between Snowflake-managed and externally managed Iceberg patterns because Snowflake can either sync Snowflake-managed Iceberg tables into Open Catalog for external-engine access, or Snowflake can query tables registered in Open Catalog through externally managed Iceberg definitions. The real decision is whether the platform needs a shared catalog control plane with centralized RBAC and service-principal governance.

Architect takeaway:

- Open Catalog is about catalog-layer governance
- it is a bridge between producer-owned and external-catalog-owned Iceberg patterns
- its hardest parts are not SQL, but ownership, RBAC, storage isolation, and multi-engine operational discipline