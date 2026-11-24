# Snowflake Practical Examples

Невеликі технічні приклади й labs. Перед повторенням перевіряй версії API, форматів і catalog paths: runnable приклад може застаріти швидше, ніж його пояснення.

## Iceberg with DuckDB

### Quack, Quack, Ka-Ching: Querying Snowflake from DuckDB

[Jonathan Merlevede, Dataminded](https://medium.com/datamindedbe/quack-quack-ka-ching-cut-costs-by-querying-snowflake-from-duckdb-f19eff2fdf9d) · 2024-05-15, updated 2024-10 · `triaged-needs-revalidation`

Практичний сценарій читання Snowflake-managed Iceberg даних зовнішнім DuckDB engine. Корисний для дослідження interoperability та повної вартості, а не як доказ, що DuckDB завжди дешевший.

**Важливе застарівання:** автор додав update, що Snowflake перестав генерувати описаний `version-hint.txt` після 2024_05 bundle, через що частина початкового workflow стала непридатною. Не запускай старі кроки, доки їх не перероблено й не перевірено за актуальними Snowflake та DuckDB docs.

Порівнювати слід однакові результати й ураховувати warehouse credits, storage/API/egress, передачу credentials, кеші, latency та операційну підтримку.

## Пов'язане навчання

- [Snowflake Iceberg learning review](../../topics/snowflake-iceberg-production-architecture.md) — benchmark gaps і план перевірки.
- [Iceberg multi-engine architecture](../../architectures/snowflake/iceberg-multi-engine.md) — writer/catalog/readers і спільне сховище.
- [Наявні Iceberg deep dives](../../../../16-cloud-databases/01-snowflake/learning-materials/deep-dives/iceberg-and-external-tables/README.md).