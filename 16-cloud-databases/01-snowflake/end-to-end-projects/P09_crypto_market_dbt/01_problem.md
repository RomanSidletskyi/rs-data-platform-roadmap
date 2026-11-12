# 1. Problem

## Business Context

A small investment research team publishes a weekly note on digital assets. Analysts currently copy prices from websites into spreadsheets, and two analysts recently quoted different volatility numbers for the same week. The team wants one governed source of truth in Snowflake:
- hourly prices for the main crypto assets, never more than two hours old
- daily closes next to the stock market and the dollar
- 30-day volatility and 60-day correlation with the S&P 500, computed one way, tested, and documented
- an email when prices stop updating or a coin moves more than 3 percent in an hour

The transformation logic will grow and several people will change it. Changes must be reviewed and tested before they reach the numbers the note quotes.

## Source Data

| Source | Endpoint | Content | Format | Frequency |
| --- | --- | --- | --- | --- |
| Coinbase Exchange | `api.exchange.coinbase.com/products/<id>/candles` | Hourly candles for BTC-USD, ETH-USD, SOL-USD | JSON arrays `[time, low, high, open, close, volume]`, newest first, at most 300 per request | Continuous, 24/7 |
| FRED (St. Louis Fed) | `fred.stlouisfed.org/graph/fredgraph.csv?id=<series>` | `SP500`, `NASDAQCOM`, `DTWEXBGS` (broad dollar index) | CSV `observation_date,<series>` | US business days |

Both are public, keyless, and free. Measured on a real extraction (20 days of candles, FRED since 2023):

| Fact | Value | Consequence |
| --- | --- | --- |
| Candles per product for 20 days | 482 rows, 481 unique hours | Request windows overlap by one candle: the API's `end` is inclusive |
| Hourly gaps for BTC, ETH, SOL | 0 | A gap of hours means the extractor stopped, not the market |
| FRED lines per series since 2023 | about 1,004 | Small: a full re-download per day is cheaper than incremental logic |
| Empty FRED values | 37 to 40 per series | Market holidays; must be dropped, not treated as zero |
| Coinbase JSON per window of 300 candles | about 30 KB | Raw volume is tiny; the design is about correctness, not scale |

```text
Coinbase envelope written by the extractor
{"product": "BTC-USD", "granularity": 3600, "window_start": "...", "window_end": "...",
 "fetched_at": "<UTC time of the request>", "candles": [[<epoch seconds>, <low>, <high>, <open>, <close>, <base volume>], ...]}

FRED CSV
observation_date,SP500
2023-01-03,3824.14
2023-01-16,           <- holiday, empty value
```

## Functional Requirements

| ID | Requirement |
| --- | --- |
| F1 | Keep every API response and CSV line as delivered, with file name and load time |
| F2 | One typed row per product and hour; overlaps and re-fetches resolved, latest fetch wins |
| F3 | Hourly fact with hourly return and the gap since the previous candle |
| F4 | One daily price table for all assets: crypto closes at UTC midnight, indexes at their official close |
| F5 | Daily returns between consecutive observations of the same asset (calendar days for crypto, trading days for indexes) |
| F6 | 30-observation annualized volatility per asset; 60-day correlation of each coin with the S&P 500 on shared days |
| F7 | Email when the newest candle is older than 3 hours, and when an hourly return exceeds 3 percent |

## Non-Functional Requirements

| ID | Requirement |
| --- | --- |
| N1 | Every change is built and tested in an isolated environment before it merges |
| N2 | Production builds are automated, hourly, and never run twice at the same time |
| N3 | Automation uses service users with key-pair auth and least privilege; no passwords anywhere |
| N4 | The main fact has a declared schema; a change that breaks it fails before it reaches consumers |
| N5 | An hourly run costs under a minute of an XS warehouse |
| N6 | Whether data is missing or wrong can be read from freshness results and stored test failures, without reading code |

## Out of Scope

- Tick or order book data (P14 and P15 cover streaming)
- Trading signals or advice: the marts describe history
- A BI tool: the exposure documents the dashboard contract; P11 builds the Power BI side
