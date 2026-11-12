# Handoff: end-to-end Snowflake projects

Робочий документ для старту нової сесії. Стан на 2026-11-10. Оновлюй його після кожного завершеного проєкту.

## 0. Як почати нову сесію

Скопіюй у чат:

```text
Продовжуємо end-to-end Snowflake проєкти. Прочитай
16-cloud-databases/01-snowflake/end-to-end-projects/HANDOFF.md
і /memories/repo/snowflake-module-notes.md. Структуру повторно не аналізуй.
Наступний проєкт: P12 (робочий цикл — розділ 4, нотатки — розділ 7). Еталон структури — P11.
```

Для старту достатньо прочитати цей файл. Решту читай лише за потреби:

- [README.md](README.md) — каталог, порядок навчання, Feature Coverage;
- [_shared/project_template.md](_shared/project_template.md) — обов'язкові розділи кожного файлу;
- [_shared/conventions.md](_shared/conventions.md) — імена, шари, RBAC, layout `06_solution/`, картинки;
- [IMPLEMENTATION_NOTES.md](IMPLEMENTATION_NOTES.md) — рішення, знахідки і ризики кожного проєкту (українською);
- еталонний проєкт: [P11_global_markets_powerbi/](P11_global_markets_powerbi/README.md); для Airflow — P10, для dbt — P09, для Kafka — P14/P15.

## 1. Що зроблено

Готові 13 з 16 проєктів. У кожному є всі вісім частин, `QUICKSTART.md`, діаграми `assets/` і запис в IMPLEMENTATION_NOTES.

| # | Тека | Головне |
| --- | --- | --- |
| P01 | `P01_cricket_json_medallion` | Cricsheet JSON, internal stage, `FLATTEN`, task graph з finalizer |
| P02 | `P02_weather_eda_notebooks` | Open-Meteo, Snowflake Notebooks vs Deepnote, портативний ноутбук |
| P03 | `P03_content_analytics_streamlit` | Wikimedia pageviews, Streamlit in Snowflake, 3 ролі, AppTest |
| P04 | `P04_wikimedia_snowpipe_realtime_dwh` | Пілот. EventStreams → Blob → Snowpipe, reconciliation, replay, DT |
| P05 | `P05_tpch_streams_tasks_cdc` | TPC-H CDC simulator, streams на кожного споживача, `MERGE`, DT для порівняння |
| P06 | `P06_food_delivery_dimensional_model` | Генератор OLTP, SCD2 за hash, inferred members, accumulating fact |
| P07 | `P07_retail_snowpark_pipeline` | UCI Online Retail II, Snowpark, local testing, Python SP з IMPORTS zip |
| P08 | `P08_social_feed_azure` | Bluesky Jetstream, 4 pipe на одній черзі Event Grid, вікно dedup 2 год |
| P09 | `P09_crypto_market_dbt` | Coinbase candles + FRED, dbt, CI-схеми для PR, alerts |
| P10 | `P10_gharchive_airflow` | GH Archive, Airflow 3.4 у Docker, backfill, unload у Parquet-архів |
| P11 | `P11_global_markets_powerbi` | WFP/ECB/World Bank, Function/Lambda, Snowpark, semantic view, Power BI |
| P14 | `P14_kafka_connector_streaming` | Kafka connector, Snowpipe Streaming, DLQ, offsets |
| P15 | `P15_kafka_lake_snowpipe` | Власний lake writer, файли з offset в імені, replay із lake |

Спільне: [_shared/](_shared/) (conventions, cost_guardrails, azure_aws_mapping, data_sources, project_template, how_to_run_a_project, `kafka_lab/`, `diagrams/style.py`) і загальний setup guide у `shared/environments/setup-guide/`.

Чесний статус: жоден проєкт не запускався в живому акаунті Snowflake, Azure чи AWS. Перевірено:

- код на живих даних джерел;
- тести pytest;
- рендеринг SQL з фейковим `snow`;
- синтаксис shell-скриптів;
- Mermaid і посилання.

Ризики першого запуску описані в кінці кожного розділу IMPLEMENTATION_NOTES.

## 2. Що залишилось

| # | Проєкт | Рівень | Фокус | Дані | Ідея зі статті |
| --- | --- | --- | --- | --- | --- |
| P12 | IoT multi-engine | 4 Advanced | Databricks і Snowflake разом, Iceberg як спільний шар | GBFS + симулятор сенсорів | #6 |
| P13 | Healthcare governed ML | 4 Advanced | Masking, row access, tags, classification, Snowpark ML vs SageMaker | Synthea | #5 |
| P16 | Capstone: NYC mobility platform | Capstone | Governed platform, CI/CD, IaC, cost, recovery | NYC TLC, Open-Meteo, taxi zones | нова |

Порядок: P12 → P13 → P16. P16 спирається на патерни всіх попередніх проєктів, тому вона остання.

## 3. Обов'язкова структура проєкту

```text
P<nn>_<snake_name>/
  README.md                      pitch, Target Architecture (png + AWS + Mermaid у <details>),
                                 Reference From the Source Article, Skills, Prerequisites, Navigation, cost warning
  QUICKSTART.md                  нумеровані кроки, у кожному "Done when" з командою перевірки і посиланням на крок 05
  01_problem.md                  контекст, дані (зразок, обсяг), FR, NFR, метрики, out of scope
  02_architecture_decisions.md   options з діаграмами, trade-offs, Why / Why Not, ADR-001..., latency, failure modes, cost model
  03_snowflake_approach.md       об'єкти, вибір фічі і відкинута фіча, erDiagram, automation graph, object inventory
  04_alternative_stacks.md       mapping table, діаграма на кожну альтернативу, коли вона виграє, learning roadmap
  05_snowflake_step_by_step.md   фази → кроки: what / why / verify / common errors, посилання на скрипти 06
  06_solution/
    README.md                    run order, expected results, design notes
    p<nn>.env.example            усі змінні з плейсхолдерами
    run_sql.sh                   sed плейсхолдерів <...> з p<nn>.env → .rendered/ → snow sql -f
    core/00_account_setup.sql    ролі P<nn>_OWNER/READER, WH, resource monitor P<nn>_RM, DB, сервісні юзери TYPE=SERVICE
    core/01_...sql ... 90_pause.sql
    azure/  aws/                 провіжн-скрипти (bash, set -euo pipefail), integration і stage SQL, IAM JSON
    <python package>/ або producer/ або ingest/   код із тестами
    tests/data_quality_checks.sql (кожна перевірка повертає 0 рядків, коли все добре) + failure_drills.md (D1–D7)
    teardown.sql
  07_build_it_yourself.md        Brief, Rules, Milestones M0..M7 (goal, deliverables, acceptance, hints без коду),
                                 Stretch, Portfolio and Interview
  assets/architecture.py         бібліотека diagrams + _shared/diagrams/style.py → architecture_{azure,aws}.png
```

Стандарти змісту:

- **Мова:** документи англійською, IMPLEMENTATION_NOTES і HANDOFF — українською, чат — українською.
- **Підхід:** теорія + практичні приклади + архітектурне мислення. Веди читача від розуміння платформи до самостійного обґрунтування рішень; trade-offs — головна частина, а не додаток. Для загальних правил технічного письма дотримуйся кореневого [HANDOFF](../../../HANDOFF.md#як-писати-зрозумілий-технічний-документ).
- **Azure — основний варіант, AWS — альтернатива** для хмарних частин. Обидва варіанти повні.
- **Безкоштовні реальні дані плюс synthetic fallback.** Спершу профілюй джерело наживо і запиши знахідки: формат, обсяг, сюрпризи.
- **Mermaid — у кожному розділі.** Без `;` у labels і sequence-повідомленнях.
- **Репозиторій публічний:**
  - сторонні картинки лише за посиланням із підписом `Source: ProjectPro, <a href=...>13 End-to-End Snowflake Projects...</a>. Linked for personal study, not copied into this repository.`;
  - під власною діаграмою — підпис з [conventions](_shared/conventions.md#diagrams-and-images);
  - жодних секретів: плейсхолдери на кшталт `<tenant-id>`.
- **Ресурси проєкту з префіксом `P<nn>`.** Кожен SQL-скрипт починається з `USE ROLE/DATABASE/WAREHOUSE`.
- **Вартість:** resource monitor, auto-suspend 60, `90_pause.sql` і teardown обов'язкові.

### Правила написання hands-on документації

Кожен документ проєкту має самостійно пояснювати свою задачу й очікуваний результат, але не дублювати весь курс. Пиши з розрахунком, що читач виконує роботу без усних підказок:

- **Назви мету і межі.** Уточни, яку проблему розв'язує крок/файл, що читач вже має зробити, а що свідомо не входить у цей етап.
- **Поясни модель перед інструкціями.** Поясни роль Snowflake-об'єктів та зовнішніх компонентів, їхні зв'язки й напрямок потоку даних. Розшифруй критичні терміни при першій появі.
- **Розділяй різні архітектурні потоки.** Наприклад, просування коду й DDL через DEV → TEST → PROD не є тим самим, що копіювання production-даних для тестів. Так само replication, failover і sharing мають різні цілі; не подавай один механізм як заміну іншому.
- **Для кожного кроку зберігай послідовність `what → why → how → verify → troubleshoot`.** Дай передумови й потрібний контекст виконання; поясни дію та очікувану зміну; назви точну перевірку й критерій успіху; додай ймовірну помилку та безпечний спосіб діагностики. QUICKSTART використовує компактний формат `commands → Done when → посилання на 05`.
- **Показуй реалістичні результати.** Додавай приклади вхідних даних, очікуваних таблиць/рядків, логів або метрик там, де вони допоможуть зрозуміти, що система працює. Чітко позначай умовні назви, значення й припущення.
- **Викладай альтернативи до рекомендації.** У 02 і 03 покажи реалістичні варіанти, чому обраний підхід відповідає вимогам і за яких умов рішення варто переглянути. Ураховуй freshness, correctness, replay, security, cost, failure handling та operational burden відповідно до задачі.
- **Навчай самостійної роботи.** У 07 сформулюй milestone, deliverables, measurable acceptance criteria і hints без готового коду. Спершу дай читачеві шанс спроєктувати й зібрати рішення; solution використовуй для порівняння після перевірок або як спосіб розблокуватися.
- **Не приховуй ризики першого запуску.** Відрізняй перевірене локально від того, що потребує реального Snowflake/Azure/AWS акаунта. Змінний синтаксис, edition/region support, квоти, ціни та permissions звіряй з офіційними джерелами; не обіцяй live-успіх, якщо його не перевіряли.
- **Роби diagrams і посилання частиною пояснення.** Діаграма має показувати межі, ownership, напрямок і важливі інтеграції; абзац перед/після неї пояснює, що саме треба з неї зрозуміти. Перевір відносні шляхи, заголовки-якорі, Mermaid та підписи зображень.
- **Закривай життєвий цикл.** Після запуску вкажи спостережуваність, зупинку/teardown, строки зберігання тестових даних і можливі витрати. Не залишай користувачу небезпечні ресурси чи неоднозначний cleanup.

Типова логіка читання проєкту: проблема та вимоги → архітектурні рішення й альтернативи → мапінг на Snowflake → самостійна спроба → step-by-step за потреби → reference solution → власний review. Навігація має підтримувати цей порядок і не підштовхувати читача відразу копіювати розв'язок.

## 4. Як робити наступний проєкт (робочий цикл)

1. **Дослідження.** Подивись картинку й опис ідеї у статті (див. розділ 6), рядок у `_shared/data_sources.md` і стовпець проєкту в Feature Coverage README: позначені там фічі мають реально бути в проєкті.
2. **Живе профілювання джерела** скриптом у `/tmp`: формат, обсяг, частота, дублікати, дрейф схеми. Знахідки пізніше підуть у 01, 02 та IMPLEMENTATION_NOTES.
3. **Рішення:** чернетка 02 (options, ADR). Якщо є важливий вибір на кшталт обсягу backfill, запитай користувача коротко.
4. **Код у `06_solution/`:** SQL, Python, скрипти і тести. Валідація:
   - pytest у venv у `/tmp`;
   - local testing для Snowpark;
   - `bash -n`, `python3 -m json.tool`;
   - рендеринг `run_sql.sh` з фейковим `snow`;
   - живий прогін інжесту на малому обсязі.
5. **Документи:** README, 01–05, 07, QUICKSTART, `06_solution/README.md`. Спочатку склади єдиний наскрізний сценарій і термінологію, потім пиши файли у порядку навчального маршруту; не допускай суперечностей між діаграмами, ADR, командами, solution і acceptance criteria. У кожному кроці читач має розуміти, де він працює (локально, у хмарі чи Snowflake account), що має бути створено, як побачити успіх і як безпечно прибрати ресурси.
6. **Діаграма:** `assets/architecture.py` → png (venv `/tmp/p04venv` з `diagrams`, Graphviz стоїть).
7. **Оновлення після проєкту:**
   - README каталогу: рядок → посилання і `ready`, «Written so far», Feature Coverage;
   - PROGRESS.md: секція проєкту перед `## Planned Projects`, прибрати рядок із таблиці planned;
   - IMPLEMENTATION_NOTES.md: секція українською (шлях даних, рішення, живі знахідки, quirks, що перевірено, ризики першого запуску);
   - цей HANDOFF і `/memories/repo/snowflake-module-notes.md`.
8. **Перевірки** (розділ 5), потім прибрати `__pycache__`, `.pytest_cache`, `.rendered`, `dist`, `*.env`.

## 5. Інструменти і перевірки

Машина: немає `docker`, `rg`, `node`, тому використовуй `python3` і `grep`. Venv у `/tmp` можуть зникнути після перезавантаження; тоді їх треба створити наново:

| Venv | Вміст |
| --- | --- |
| `/tmp/afvenv` | Python 3.12, `apache-airflow==3.4.0`, провайдери snowflake/azure/amazon/common-sql/standard, `snowflake-snowpark-python==1.56.0`, pytest |
| `/tmp/p04venv` | `pip install -r _shared/diagrams/requirements.txt` |
| `/tmp/dbtvenv` | dbt (P09) |

Перевірка структури репозиторію (з кореня):

```bash
./scripts/check_repo.sh structure
```

Посилання і якорі (з кореня репозиторію). Останній результат: 565 посилань, 0 битих.

```python
import re, os, glob
root = "16-cloud-databases/01-snowflake/end-to-end-projects"
def slug(t): t = re.sub(r"[^\w\- ]", "", t.strip().lower()); return t.replace(" ", "-")
def anchors(p):
    s = re.sub(r"```.*?```", "", open(p).read(), flags=re.S)
    return {slug(re.sub(r"[`*]", "", m)) for m in re.findall(r"^#+\s+(.*)$", s, re.M)}
bad = []
for p in glob.glob(root + "/**/*.md", recursive=True):
    body = re.sub(r"```.*?```", "", open(p).read(), flags=re.S)
    for l in re.findall(r"\]\(([^)\s]+)\)", body):
        if re.match(r"https?:|mailto:", l): continue
        path, _, a = l.partition("#")
        t = os.path.normpath(os.path.join(os.path.dirname(p), path)) if path else p
        if not os.path.exists(t) or (a and t.endswith(".md") and a not in anchors(t)): bad.append((p, l))
print(bad)
```

Mermaid. Останній результат: 238 блоків, 0 помилок.

1. Згенеруй `/tmp/mmcheck/blocks.json` у форматі `[{"id": "<file>#<n>", "code": "..."}]` з усіх блоків ```` ```mermaid ```` під `end-to-end-projects`.
2. Поклади поруч `/tmp/mmcheck/index.html`:

   ```html
   <!doctype html><html><body><script type="module">
   import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs';
   mermaid.initialize({startOnLoad:false});
   const blocks = await (await fetch('blocks.json')).json();
   const results = [];
   for (const b of blocks) { try { await mermaid.parse(b.code); results.push({id:b.id, ok:true}); }
     catch (e) { results.push({id:b.id, ok:false, err:String(e.message||e).slice(0,300)}); } }
   window.__results = results; document.title = 'done';
   </script></body></html>
   ```

3. `python3 -m http.server 8766 --bind 127.0.0.1 --directory /tmp/mmcheck` (async). Відкрий `http://127.0.0.1:8766/index.html` у вбудованому браузері, дочекайся `document.title === 'done'` і прочитай `window.__results` (з `ok: false`).

## 6. Джерела інформації

- **Стаття-основа:** ProjectPro, [13 End-to-End Snowflake Projects That Build Job-Ready Skills](https://www.projectpro.io/article/snowflake-projects/1168). Номер ідеї стоїть у стовпці «Source idea» каталогу. Картинки для залишку:
  - #5 Healthcare (P13): `https://dezyre.gumlet.io/images/blog/snowflake-projects/image_672009352141758194462890.png?w=768&dpr=1.0`. Оригінал: Snowflake на AWS, streams, SageMaker (XGBoost, Random Forest) прогнозує length of stay, governance.
  - #6 IoT (P12): `https://dezyre.gumlet.io/images/blog/snowflake-projects/image_283611851151758194462891.png?w=768&dpr=1.0`. Оригінал: Event Hubs → Databricks (Spark) → Snowflake, Snowpipe і COPY, streams, secure data sharing. Ця картинка вже є як референс у P14 README; у P12 її теж треба дати.
  - P16 у статті немає: це власна ідея, тому розділ «Reference From the Source Article» або пропускаємо, або пояснюємо, з яких проєктів він зібраний.
- **Дані:** [_shared/data_sources.md](_shared/data_sources.md) — GBFS (systems.csv у репо MobilityData/gbfs), Synthea (Java-генератор, CSV/FHIR), NYC TLC (Parquet за місяцями), Open-Meteo, taxi zones.
- **Фічі, які мають бути** (Feature Coverage):
  - P12: Stages/COPY, semi-structured, Snowpipe auto-ingest, Snowpipe Streaming, Snowpark, external orchestration, observability, cost;
  - P13: Stages/COPY, semi-structured, Snowpark, Notebooks or Streamlit, governance policies, cost;
  - P16: усе, крім Snowpipe Streaming: Stages/COPY, semi-structured, Snowpipe auto-ingest, streams/tasks, dynamic tables, Snowpark, Notebooks/Streamlit, dbt, external orchestration, governance, observability, cost.
- **Документація:** офіційні docs Snowflake, Azure, AWS, Databricks. Синтаксис і ліміти перевіряй перед написанням; що не перевірено наживо — у «ризики першого запуску».

## 7. Нотатки до P12, P13, P16 (пропозиції, не фінальні рішення)

### P12 IoT multi-engine (Azure primary)

- **Потік:** GBFS (`station_status`, `free_bike_status` або `vehicle_status`) + симулятор сенсорів у Python з керованим обсягом, out-of-order подіями і дублікатами.
- **Двигуни:**
  - Azure: Event Hubs (Kafka-сумісний endpoint) → Databricks Structured Streaming → Iceberg на ADLS;
  - Snowflake читає той самий Iceberg (externally managed Iceberg table через catalog integration або Snowflake-managed Iceberg + external volume) — порівняти обидва варіанти в 02;
  - паралельний «гарячий» шлях — Snowpipe Streaming прямо в Snowflake, щоб порівняти затримку і вартість;
  - AWS-варіант: Kinesis або MSK → Databricks на AWS → Iceberg на S3.
- **Головне питання проєкту:** хто владіє таблицею (writer), хто читає, де живе каталог (Unity Catalog Iceberg REST, Polaris або Open Catalog, Snowflake) і що буде при одночасному записі.
- **Перевірити наживо:**
  - ліміти Databricks Free Edition (serverless, доступ до зовнішнього сховища);
  - поточний синтаксис `CREATE ICEBERG TABLE`, `CATALOG INTEGRATION`, `EXTERNAL VOLUME`;
  - версія Snowpipe Streaming SDK (high-performance architecture).
- **Fallback без Databricks:** PySpark локально пише Iceberg (теорія — у модулях `06-spark-pyspark` і `14-iceberg` репозиторію).

### P13 Healthcare governed ML

- **Дані:** Synthea (згенерувати ~1–5 тис. пацієнтів у CSV); ціль — length of stay з `encounters`.
- **Governance:**
  - tags + tag-based masking;
  - row access policy (наприклад, за організацією чи регіоном);
  - projection policy;
  - classification (`SYSTEM$CLASSIFY` або автоматична класифікація);
  - access history для аудиту;
  - ролі: analyst, data scientist, auditor.
- **ML:** `snowflake-ml-python` (preprocessing, XGBoost, Model Registry, inference у Snowflake) проти SageMaker (експорт, навчання, повернення прогнозів). Порівняти, які дані залишають периметр.
- **Notebooks або Streamlit** для EDA і перегляду прогнозів під різними ролями (маскування видно на власні очі).
- **Перевірити:** masking і row access policies потребують Enterprise edition (trial дозволяє вибрати); поточні API `snowflake.ml`.

### P16 Capstone: NYC mobility platform

- **Дані:** NYC TLC Parquet за 2–3 місяці (обсяг за замовчуванням малий, «volume»-варіант — опційно, як у P10), Open-Meteo погодинно, taxi zones (CSV або shapefile).
- **Збирає все:**
  - Snowpipe з landing;
  - dbt-моделі з тестами;
  - streams/tasks або DT (обґрунтувати вибір);
  - Streamlit;
  - governance з P13;
  - observability і cost з P04/P09.
- **Нове:**
  - IaC: Terraform `snowflakedb/snowflake` provider + azurerm/aws;
  - CI/CD: GitHub Actions + Snowflake CLI або dbt, окремі DEV/PROD через zero-copy clone;
  - recovery: Time Travel, UNDROP, clone, опційно replication/failover;
  - runbooks;
  - budget і alerts.
- **Формат:** `07_build_it_yourself.md` писати як підсумковий іспит з review-чеклистом рівня архітектора.

## 8. Відомі пастки (коротко)

Повний список — у repo memory і IMPLEMENTATION_NOTES.

- **`QUALIFY` і вибір файлу:** `QUALIFY` вимагає віконної функції. «Останній файл» вибирай через `DENSE_RANK` з tie-break по `SRC_FILE`.
- **COPY:** COPY з неіснуючого шляху успішний з 0 файлів, тому спершу `LIST`. `INCLUDE_METADATA` працює лише з `MATCH_BY_COLUMN_NAME`; для CSV потрібен `ERROR_ON_COLUMN_COUNT_MISMATCH=FALSE`.
- **Tasks:** усі задачі графа мають спільних owner і schema. `CREATE STREAMLIT/NOTEBOOK ... FROM` потребує `ADD LIVE VERSION FROM LAST`.
- **Snowpark local testing 1.56:**
  - немає `trim`;
  - у CASE додавай `.cast()`;
  - `session.sql` не працює;
  - після left join відсутні double — це NaN, а не NULL;
  - фільтр став один раз у кінці;
  - window+filter винось у SQL view.
- **Airflow 3:** `airflow.dag_processing.dagbag`, явний `CronDataIntervalTimetable`, backfill не раніше `start_date`.
- **Блокування й мережа:**
  - мережа корпоративна: `dbt deps` і деякі pip падають з SSL; пакети клонуй з GitHub;
  - деякі сайти блокують дефолтний User-Agent (GH Archive — Cloudflare 403);
  - FRED відкидає кастомний UA, Stooq заблокований.
