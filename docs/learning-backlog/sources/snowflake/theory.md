# Snowflake Theory and Reference Sources

Цей файл — список для концептуального читання, не перелік затверджених навчальних матеріалів. Історичні статті позначені окремо від джерел для перевірки актуальної поведінки.

## Iceberg and Open Lakehouse

### Snowflake presents the Open Data Lakehouse

[Christian Lauer, Medium / CodeX](https://medium.com/codex/snowflake-presents-the-open-data-lakehouse-14f733eff632) · 2023-12-06 · `triaged`

Короткий вторинний вступ до Snowflake та Iceberg. Medium позначає сторінку як member-only; це концептуальний контекст, не сучасний інструктивний посібник.

Додаткове посилання на перегляд: [Ekky Medium reader](https://ekky.dev/app/medium/?url=https%3A%2F%2Fmedium.com%2Fcodex%2Fsnowflake-presents-the-open-data-lakehouse-14f733eff632). Це дзеркало, не незалежне джерело.

### Unifying Iceberg Tables on Snowflake

[Snowflake](https://www.snowflake.com/en/blog/unifying-iceberg-tables/) · 2023-08-31 · `historical`

Історія уніфікації Iceberg підходу та catalog ownership. Сторінка сама вказує, що інформація оновлювалася, і скеровує до новішої публікації. Не копіювати звідси поточний SQL без документаційної перевірки.

### Build an Open Data Lakehouse with Iceberg Tables

[Snowflake](https://www.snowflake.com/en/blog/build-open-data-lakehouse-iceberg-tables/) · 2023-12-04 · `historical-preview-context`

Пояснює вибір Snowflake catalog, Glue та Object Store на момент public preview. Використовувати для розуміння еволюції дизайну; поточні availability та обмеження перевіряти окремо.

### An Overview of Snowflake Apache Iceberg Tables

[Augusto Rosa, Snowflake Builders Blog on Medium](https://medium.com/snowflake/an-overview-of-snowflake-apache-iceberg-tables-d5e85864ac99) · 2024-02-08 · `historical`

Навчальний огляд таблиць Snowflake-managed та externally managed Iceberg, написаний під час preview-функцій. Приклади SQL та доступність можуть бути застарілими.

## Discovery

[Medium Snowflake topic](https://medium.com/tag/snowflake) · `discovery-only`

Пошук нових статей, не першоджерело і не конкретний матеріал для roadmap.

## Пов'язане навчання

- [Snowflake Iceberg learning review](../../topics/snowflake-iceberg-production-architecture.md) — що вже покрито й чого бракує в модулі.
- [Iceberg multi-engine architecture](../../architectures/snowflake/iceberg-multi-engine.md) — окрема системна схема та design questions.
- [Snowflake Iceberg deep dives](../../../../16-cloud-databases/01-snowflake/learning-materials/deep-dives/iceberg-and-external-tables/README.md).

Загальне правило: для актуального синтаксису, provider support і lifecycle спирайся на поточні офіційні docs, а не на ці старі статті.