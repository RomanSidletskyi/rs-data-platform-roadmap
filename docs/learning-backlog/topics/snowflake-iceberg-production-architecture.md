# Snowflake, Iceberg, and Production Architecture

Пакет отримано 2026-11-11. Він поєднує ідеї Snowflake E2E, відкритого lakehouse/Iceberg, DuckDB, production environment design і вставлений синтетичний огляд архітектури.

## Навігація

- [Backlog actions](../roadmap.md)
- [Snowflake theory sources](../sources/snowflake/theory.md)
- [Snowflake practical examples](../sources/snowflake/examples.md)
- [Snowflake E2E project sources](../sources/snowflake/e2e-projects.md)
- [Production data platform architecture](../architectures/snowflake/production-data-platform.md)
- [Iceberg multi-engine architecture](../architectures/snowflake/iceberg-multi-engine.md)
- [Snowflake capability map](../../../16-cloud-databases/01-snowflake/learning-materials/00_snowflake_capability_map.md)
- [Snowflake architecture guides](../../../16-cloud-databases/01-snowflake/learning-materials/architecture/README.md)
- [Snowflake E2E catalog](../../../16-cloud-databases/01-snowflake/end-to-end-projects/README.md)
- [Snowflake E2E work handoff](../../../16-cloud-databases/01-snowflake/end-to-end-projects/HANDOFF.md)

## Короткий висновок

Джерела вказують на три корисні напрями: відкрита Iceberg-таблиця з кількома engines; вибір catalog і writer ownership; межі production Snowflake середовищ, compute та deployment. Це хороші теми для перевірки наявних матеріалів і для P12, але не всі посилання дають актуальні або незалежно перевірені технічні рекомендації.

Вставлений архітектурний огляд — це компіляція тверджень із посиланнями, а не встановлена першоджерельна стаття. Його тези збережено нижче переказом. Числа, твердження про «industry standard» та продуктові можливості не вважати перевіреними лише тому, що вони мають цитату.

## Основні джерела

## Джерела за призначенням

Канонічні посилання й короткі описи збережені окремо за типом матеріалу:

- [Теорія та довідкові огляди](../sources/snowflake/theory.md)
- [Практичні приклади](../sources/snowflake/examples.md)
- [E2E і production project ideas](../sources/snowflake/e2e-projects.md)
- [Production data platform architecture](../architectures/snowflake/production-data-platform.md)
- [Iceberg multi-engine architecture](../architectures/snowflake/iceberg-multi-engine.md)

Нижче залишений аналіз навчального покриття, а не повторний список усіх URL.

## Вхідний архітектурний матеріал

Надісланий production-architecture synthesis оформлений окремо, щоб не змішувати його з картками статей:

- [Production Snowflake data platform](../architectures/snowflake/production-data-platform.md)
- [Iceberg multi-engine data sharing](../architectures/snowflake/iceberg-multi-engine.md)

Це власні короткі конспекти й діаграми, не копії вихідних матеріалів. Непідтверджені цифри та загальні claims там позначені як питання для перевірки.

## Напрямки застосування

- **P12 IoT multi-engine:** ProjectPro #6 — вихідна ідея; офіційний streaming матеріал — контекст. Ключове навчання: writer/catalog ownership, Iceberg interop, latency/cost, concurrent access. Детальний наступний крок ведеться у Snowflake E2E handoff.
- **Snowflake existing materials:** зіставити теми з capability map та architecture guides; оновлювати наявні файли, а не створювати дубль-гайд.
- **Можлива вправа:** виміряти зовнішнє читання Iceberg (DuckDB або інший підтримуваний engine) проти Snowflake query на одному контрольованому наборі даних. Порівняння має враховувати compute, cloud egress/API, cache state, latency, concurrency та operational ownership.

## Детальний огляд наявних Iceberg deep dives

Огляд виконано 2026-11-11 для файлів у `16-cloud-databases/01-snowflake/learning-materials/deep-dives/iceberg-and-external-tables/`. Загальна оцінка: матеріали добре пояснюють архітектурні моделі та operational ownership; основна прогалина — не теорія, а зв'язаний, повторюваний практичний маршрут із результатами, вимірами й обома cloud providers.

| Питання | Що вже є | Оцінка / прогалина |
| --- | --- | --- |
| Відмінність Iceberg від звичайної Snowflake table | `README.md`, `Snowflake_table_type_decision_guide.md`, `Snowflake_managed_Iceberg.md` порівнюють native table, Snowflake-managed Iceberg, externally managed Iceberg та external table за format, catalog, storage, lifecycle і use case. | Концептуально добре й без твердження, що Iceberg завжди кращий. Потрібен один практичний сценарій із однаковою таблицею/запитами, де learner побачить відмінності в DDL, файлах, metadata й операціях. |
| Як зберігаються дані | Managed guide описує Parquet `data/`, Iceberg `metadata/`, snapshots/manifests, metadata pointer, Snowflake-managed storage проти external volume, compaction, snapshot expiry, target file size, clustering і orphan files. External tables мають окремий опис file registration та refresh. | Теорія сильна. Не вистачає вправи, де після CREATE/INSERT/MERGE звіряються Snowflake object, metadata location, cloud object paths і зміна snapshot. Recovery/retention межі треба підсумувати в короткій матриці. |
| Обробка: читання, запис, зміни | Managed guide має INSERT/OVERWRITE/MERGE, write-as-snapshot mental model, schema/partition evolution і publish pattern. Externally managed guide пояснює read, refresh, catalog-linked database, REST write path, autocommit/compatibility caveats, deletes, maintenance і failure modes; є два cookbook-и. | Для архітектурного читання детально. Практичні cookbook-и переважно S3/REST приклади; немає наскрізної лабораторії, яка запускає writer і reader та перевіряє результат/refresh після кожної операції. Write capability залежить від конкретного catalog і конфігурації, тому треба навчати через compatibility gates, а не загальну обіцянку. |
| Швидкодія | Decision guide дає якісну оцінку (native tables зазвичай простіші для Snowflake-only serving; external tables залежать від файлів; Iceberg додає interoperability overhead). Managed guide пояснює file size, compaction, clustering, partitioning, pruning-related concepts та зовнішні transfer costs. | Критичний пропуск: немає apples-to-apples benchmark native table vs Snowflake-managed Iceberg vs externally managed Iceberg/external table. Усі рейтинги позначати якісними; не стверджувати «Iceberg швидше/дешевше» без вимірів. Потрібні Query Profile, bytes scanned, execution/refresh latency, credits і object-store витрати. |
| AWS та Azure / різні engines | Матеріали концептуально розрізняють Snowflake catalog, external catalog, Glue, Open Catalog, Horizon Catalog та Unity-style path; описують Spark/Trino й catalog-linked DB. | Пошук `AZURE`, `ADLS` та Azure storage configuration у цій теці не знайшов прикладів. Більшість SQL і cloud setup snippets орієнтовані на S3/AWS. Потрібна чесна provider/catalog matrix: Azure та AWS не обов'язково мають однакові catalog, auth, write, refresh чи external-engine шляхи. Не позначати шлях supported, доки його не підтверджують актуальні docs і тест конкретної конфігурації. |
| Навчальний маршрут | README починає з decision guide, далі йдуть предметні пояснення, cookbook-и та architecture tasks. | Це theory-first, хоча практична перевага учня — examples-first. Залишити наявні deep dives як reference/theory, але додати практичний entrypoint: спочатку runnable scenario, спостереження й перевірки, потім пояснення під капотом і архітектурна модель. |

### Кандидати на доповнення

- Почати навчальний маршрут з порівняльного реального прикладу, а потім пояснити його через наявну теорію. Це бажаний напрямок, не нова затверджена програма.
- Додати вимірювання native table проти Snowflake-managed/external Iceberg; зараз у матеріалах є якісні твердження, але не контрольований benchmark.
- Додати перевірений AWS/Azure приклад або чітко зафіксувати, якщо конкретна інтеграція недоступна/не підтримана. Поточні приклади переважно S3.
- Пов'язати Iceberg multi-engine пояснення з P12, який вже є у Snowflake E2E roadmap; не створювати дубль проєкту.

Перш ніж вносити зміни в навчальний модуль, звірити capability map, наявні guides і спеціалізований P12 handoff.

## Перевірено в цій сесії

- Відкрито метадані та зміст ProjectPro #6, двох Snowflake Iceberg blog posts, Snowflake streaming blog, Medium Iceberg огляду, Dataminded DuckDB статті та Armely architecture article.
- Перечитано локальний `README.md`, decision guide, managed/external Iceberg guides, external-table guide, Open Catalog guide й обидва cookbook-и; у цій теці не знайдено Azure/ADLS storage examples або native-vs-Iceberg benchmark.
- Спроба отримати актуальні офіційні Snowflake/Apache docs через web extraction завершилася помилкою витягання сторінок; тому цей план визначає перевірку документації як обов'язковий етап, а не заявляє поточну сумісність.
- Не вдалося перевірити вміст DataEngineerThings URL: перегляд перенаправив на Medium identity gate.
- Інші посилання з citation-списку ще не відкривалися.
- Жоден із поточних синтаксисів, лімітів чи прикладів тут не пройшов live account validation.