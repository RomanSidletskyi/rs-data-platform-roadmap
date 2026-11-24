# Data Sources

Every project has a free real data source and a synthetic fallback. The fallback means an API outage, a rate limit, or a changed policy never blocks the learning.

## Rules

- Commit download scripts and generators, not data. Add data folders to `.gitignore`.
- Identify yourself: send a descriptive `User-Agent` with a contact where the provider asks for one (Wikimedia does).
- Respect rate limits and terms. Back off on errors and do not parallelize public endpoints aggressively.
- Check the license before publishing derived data or dashboards. Attribution is often required.
- Keep a `source_snapshot.md` note in your own work: when you pulled data, which version, and how many rows.

## Catalog

| Project | Source | Access | Format | Why it is a good fit | Synthetic fallback |
| --- | --- | --- | --- | --- | --- |
| P01 | [Cricsheet](https://cricsheet.org/downloads/) ODI matches | Download, no key | Nested JSON per match | Real deeply nested JSON, thousands of files | Not needed: static download |
| P02 | [Open-Meteo Historical API](https://open-meteo.com/en/docs/historical-weather-api) | HTTP, no key | JSON | Clean API, years of hourly weather | Seeded weather series |
| P03 | [Wikimedia REST API](https://wikimedia.org/api/rest_v1/) pageviews | HTTP, no key, `User-Agent` | JSON | Real trends for content analytics | Seeded channel metrics |
| P04 | [Wikimedia EventStreams](https://stream.wikimedia.org/?doc) `recentchange` | Server-Sent Events, no key, `User-Agent` | JSON events | Live, continuous, real edits across all wikis | `producer.py --source synthetic` |
| P05 | `SNOWFLAKE_SAMPLE_DATA.TPCH_SF1` | Shared database in every account | Tables | Zero setup, known schema | Change simulator script |
| P06 | Synthetic OLTP generator | Local | CSV deltas | SCD2 needs controlled changes, real data is worse here | Is the source |
| P07 | [UCI Online Retail II](https://archive.ics.uci.edu/dataset/502/online+retail+ii) | Download, no key | Excel | Real transactions, returns, dirty values | Seeded orders |
| P08 | [Bluesky Jetstream](https://github.com/bluesky-social/jetstream) | WebSocket, no key | JSON events | Free replacement for the Twitter feed | Seeded posts |
| P09 | Coinbase Exchange public candles endpoint, [FRED](https://fred.stlouisfed.org) daily series (SP500, NASDAQCOM, DTWEXBGS) | REST and CSV, no key | JSON, CSV | Real prices around the clock next to stock indexes; Stooq now blocks scripts | Random-walk ticker |
| P10 | [GH Archive](https://www.gharchive.org) | Hourly files, no key | Gzipped JSON | Ideal for hourly batch with backfill | Not needed: static history |
| P11 | [World Bank API](https://api.worldbank.org/v2/), [ECB data portal](https://data.ecb.europa.eu), WFP food prices on [HDX](https://data.humdata.org) | HTTP or download, no key | JSON, CSV | Many countries and markets, like the original project | Seeded indicators |
| P12 | [GBFS](https://github.com/MobilityData/gbfs) bike-share feeds plus sensor simulator | HTTP, no key | JSON | Real live telemetry plus controllable volume | Sensor simulator |
| P13 | [Synthea](https://github.com/synthetichealth/synthea) | Local generator | CSV, FHIR | Realistic patients with no real health data | Is the source |
| P14, P15 | Wikimedia EventStreams through Kafka | As P04 | JSON or Avro | Same data as P04 for a fair comparison | As P04 |
| P16 | [NYC TLC trip records](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page), Open-Meteo, taxi zones | Download, no key | Parquet, CSV | Large, real, multi-source | Sampled months |

## Notes per Source

### Wikimedia EventStreams (P04, P14, P15)

- Endpoint: `https://stream.wikimedia.org/v2/stream/recentchange`
- Each event has `meta.id` (unique event id), `meta.dt` (event time), `wiki`, `type`, `title`, `user`, `bot`, `length`, and more.
- Filter out events where `meta.domain = 'canary'`. They are synthetic monitoring events emitted by the service.
- The stream supports resuming with the `Last-Event-ID` header after a disconnect.
- Volume varies by time of day. Measure it yourself in the first milestone rather than assuming.

### Rate-limited or region-limited sources

Some public endpoints restrict access by country or volume. If a source is unavailable from your location, switch to the synthetic fallback and note it in your project log. The architecture work does not depend on which feed you use.
