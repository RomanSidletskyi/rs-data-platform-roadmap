# Catalog Types: Hive, Glue, REST, Nessie, Open Catalog

## 1. There Is No Single Universal Catalog Choice

Catalogs exist in different shapes because teams optimize for different environments.

Common choices include:

- Hive Metastore-based catalogs
- AWS Glue
- REST catalogs
- Nessie-style catalog and versioning layers
- Snowflake Open Catalog or other managed REST-based services

## 2. Hive Metastore Style

This is historically common in Hadoop and early lakehouse ecosystems.

It is familiar, but often less attractive in newer cloud-native architectures where teams want cleaner service boundaries.

## 3. AWS Glue

Glue is often the default in AWS-heavy environments.

It is strong when:

- S3 is the main storage
- Spark, Athena, or EMR are already central
- the organization already treats Glue as the metadata authority

It is weaker when:

- cross-platform governance needs more explicit catalog-layer behavior than the organization currently has

## 4. REST Catalogs

REST catalogs matter because they give a more explicit service interface for metadata operations.

They are strong when:

- multiple engines should talk to one standard API
- teams want clearer service boundaries around metadata

## 5. Nessie-Style Patterns

Nessie is important when teams want branch-like or version-like workflows at the catalog layer.

This can be powerful, but it is also an advanced operating model.

It is not automatically the right choice for simple analytical publishing.

## 6. Open Catalog Style Services

Managed catalog services such as Snowflake Open Catalog matter when teams want:

- a managed REST catalog layer
- centralized RBAC
- service-principal-based access
- one control plane across multiple engines

## 7. Architect Rule

Choose the catalog that matches the real control plane of the organization.

Do not create split ownership unless there is a strong reason.