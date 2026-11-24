# 1. Problem

## Business Context

A humanitarian research team publishes a monthly brief on food affordability in six countries. Today an analyst downloads WFP spreadsheets, converts currencies with whatever rate a website shows that day, and pastes charts into slides. Two briefs in a row used different exchange rates for the same month, and nobody could say which was right. The team wants:
- one dataset with prices per kilogram or litre, comparable across markets and countries
- every price in local currency, USD, and EUR, with the exchange rate source named
- food price changes next to general inflation and income
- a Power BI report the team refreshes without asking an engineer, and the same numbers available in SQL
- no servers to run: the sources change monthly, the pipeline should cost almost nothing on other days

## Source Data

| Source | Access | Content | Format | Cadence |
| --- | --- | --- | --- | --- |
| WFP food prices on HDX | `data.humdata.org/api/3/action/package_show?id=wfp-food-prices-for-<country>`, then the CSV URL | Monthly market prices per commodity, unit, and price type, with WFP's own USD price | CSV, full history per country | Monthly, as a new full file |
| ECB data portal | `data-api.ecb.europa.eu/service/data/EXR/M.<currencies>.EUR.SP00.A?format=csvdata&detail=dataonly` | Monthly average reference rates, units per EUR | CSV | Monthly |
| World Bank API | `api.worldbank.org/v2/country/<ISO3;...>/indicator/<id>?format=json` | CPI, inflation, GDP per capita, population, official exchange rate | JSON `[metadata, rows]` | Yearly |

All three are public and keyless. WFP data is licensed CC BY-IGO: attribute it in the report.

Measured on 2026-11-10:

| Fact | Value | Consequence |
| --- | --- | --- |
| WFP rows per country | Kenya 29,298; Türkiye 14,562; Nigeria 91,216; India 216,151 | Small: a full rebuild per change is cheap |
| WFP versioning | Each country is one CSV, replaced as a whole; HDX metadata has `last_modified` | Version the landing name by `last_modified`; latest file wins |
| WFP dates | Always the 15th of the month | The month is the grain |
| WFP units | `KG`, `90 KG`, `500 ML`, `200 G`, `L`, also `Unit`, `30 pcs`, `Head`, `kWh`, `Course` | 98.1 percent of rows (Kenya, Nigeria, India, Türkiye) can be expressed per kg or litre; the rest stay local only |
| WFP `usdprice` | Rounded to cents; 70 percent of Indian rows are below 1 USD | A single row's implied rate can be 2 percent off |
| WFP implied rate versus ECB | INR within plus or minus 0.9 percent per month, TRY within 0.15 percent (2026) | Two sources agree; the difference is measurable |
| ECB coverage | USD, INR, TRY published; KES, NGN, ETB, BDT not | ECB where it exists, WFP's implied rate elsewhere |
| World Bank coverage | 2010 to 2025, no 2026 values yet | Yearly indicators lag a year |
| First full ingestion of three countries | About 5 minutes, mostly the India CSV | Function and Lambda timeouts must allow it |

```text
WFP CSV header (current HDX export)
date,admin1,admin2,market,market_id,latitude,longitude,category,commodity,commodity_id,unit,priceflag,pricetype,currency,price,usdprice
2006-01-15,Coast,Mombasa,Mombasa,191,-4.05,39.67,cereals and tubers,Maize (white),67,90 KG,actual,Wholesale,KES,1480,20.58
```

## Functional Requirements

| ID | Requirement |
| --- | --- |
| F1 | Land each new source version exactly once, unchanged, with the version in the name; a run without changes lands nothing |
| F2 | Keep every landed version in RAW with file name, row number, file time, and load time |
| F3 | Use the newest WFP version per country; express comparable prices per kg or litre |
| F4 | One monthly exchange rate per currency: ECB where published, WFP implied otherwise; report the difference where both exist |
| F5 | Prices in local currency, USD, and EUR, with the rate source on every row |
| F6 | Yearly food price change next to CPI inflation; affordability against GDP per capita |
| F7 | The same metric definitions available in SQL (semantic view) and in Power BI (DAX), with a check that they agree |

## Non-Functional Requirements

| ID | Requirement |
| --- | --- |
| N1 | No always-on compute: function or Lambda on a schedule, Snowpipe, a task that starts only when files arrived |
| N2 | No secrets in code or settings: managed identity or execution role for storage, key pair for Power BI |
| N3 | Readers never see a half-built table |
| N4 | Power BI cost is visible on its own warehouse and does not grow with the number of viewers |
| N5 | A failing source does not stop the others, and never lands an error page as data |
| N6 | Runs without a cloud account: local ingestion and internal stages, with the same SQL |

## Out of Scope

- Streaming ingestion: the sources publish monthly (P04, P14, P15 cover streaming)
- Forecasting prices: P13 covers ML in Snowflake
- Row-level security in Power BI: P13 covers governance policies in Snowflake
