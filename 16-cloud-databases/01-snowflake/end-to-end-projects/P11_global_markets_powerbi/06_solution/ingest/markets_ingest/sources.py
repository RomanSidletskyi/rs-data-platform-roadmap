"""Source clients: WFP food prices on HDX, ECB exchange rates, World Bank indicators.

Every function that builds a landing key is pure, so naming and validation are tested without the network.
"""

from __future__ import annotations

import hashlib
import json
import time
import urllib.error
import urllib.request
from collections.abc import Callable
from datetime import datetime

USER_AGENT = "rs-data-platform-roadmap-p11/1.0 (learning project)"
ROOT = "markets"

# ISO3 -> HDX dataset slug. Countries whose currency the ECB publishes (INR, TRY) allow an FX cross-check.
WFP_COUNTRIES = {
    "KEN": "kenya",
    "NGA": "nigeria",
    "ETH": "ethiopia",
    "BGD": "bangladesh",
    "IND": "india",
    "TUR": "turkiye",
}
ECB_CURRENCIES = ["USD", "INR", "TRY"]
WB_INDICATORS = {
    "FP.CPI.TOTL": "Consumer price index (2010 = 100)",
    "FP.CPI.TOTL.ZG": "Inflation, consumer prices (annual %)",
    "NY.GDP.PCAP.CD": "GDP per capita (current US$)",
    "SP.POP.TOTL": "Population, total",
    "PA.NUS.FCRF": "Official exchange rate (LCU per US$, period average)",
}

HDX_PACKAGE = "https://data.humdata.org/api/3/action/package_show?id=wfp-food-prices-for-{slug}"
ECB_URL = "https://data-api.ecb.europa.eu/service/data/EXR/M.{currencies}.EUR.SP00.A?format=csvdata&detail=dataonly&startPeriod={start}"
WB_URL = "https://api.worldbank.org/v2/country/{countries}/indicator/{indicator}?format=json&per_page=1000&date={start}:{end}"

WFP_HEADER = "date,admin1,admin2,market,market_id,latitude,longitude,category,commodity,commodity_id,unit,priceflag,pricetype,currency,price,usdprice"
ECB_HEADER = "KEY,FREQ,CURRENCY,CURRENCY_DENOM,EXR_TYPE,EXR_SUFFIX,TIME_PERIOD,OBS_VALUE"

Fetch = Callable[[str], bytes]


class SourceError(RuntimeError):
    """The source answered, but not with the shape we expect. Nothing is landed."""


def http_get(url: str, attempts: int = 3, timeout: int = 120) -> bytes:
    request = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    for attempt in range(1, attempts + 1):
        try:
            with urllib.request.urlopen(request, timeout=timeout) as response:
                return response.read()
        except (urllib.error.URLError, TimeoutError, ConnectionError):
            if attempt == attempts:
                raise
            time.sleep(2 ** attempt)
    raise AssertionError("unreachable")


def content_version(body: bytes) -> str:
    """Content-addressed version: the same bytes always get the same name."""
    return hashlib.sha256(body).hexdigest()[:12]


def wfp_resource(package_json: bytes) -> tuple[str, str]:
    """Return (download URL, version) of the food prices CSV from an HDX package_show response."""
    package = json.loads(package_json)
    if not package.get("success"):
        raise SourceError("HDX package_show did not succeed")
    resources = [r for r in package["result"]["resources"] if r.get("url", "").endswith(".csv") and "food_prices" in r["url"]]
    if len(resources) != 1:
        raise SourceError(f"expected one food prices CSV, found {len(resources)}")
    modified = datetime.fromisoformat(resources[0]["last_modified"])
    return resources[0]["url"], modified.strftime("%Y%m%dT%H%M%S")


def wfp_key(iso3: str, version: str) -> str:
    return f"{ROOT}/wfp/country={iso3}/version={version}/wfp_food_prices_{iso3.lower()}.csv"


def ecb_url(currencies: list[str], start: str) -> str:
    return ECB_URL.format(currencies="+".join(currencies), start=start)


def ecb_key(body: bytes) -> str:
    return f"{ROOT}/ecb/exr_monthly/{content_version(body)}.csv"


def wb_url(countries: list[str], indicator: str, start: int, end: int) -> str:
    return WB_URL.format(countries=";".join(countries), indicator=indicator, start=start, end=end)


def wb_key(indicator: str, body: bytes) -> str:
    return f"{ROOT}/worldbank/indicator={indicator}/{content_version(body)}.json"


def check_wfp_csv(body: bytes) -> None:
    first_line = body[:400].decode("utf-8", errors="replace").splitlines()[0].strip().lstrip("\ufeff")
    if first_line != WFP_HEADER:
        raise SourceError(f"unexpected WFP header: {first_line[:120]!r}")


def check_ecb_csv(body: bytes) -> None:
    lines = body.decode("utf-8", errors="replace").splitlines()
    if not lines or lines[0].strip() != ECB_HEADER or len(lines) < 2:
        raise SourceError("unexpected ECB response: header differs or no observations")


def check_wb_json(body: bytes) -> int:
    """World Bank answers [metadata, rows]; an error is a one-element list with a message. Returns the row count."""
    try:
        payload = json.loads(body)
    except json.JSONDecodeError as error:
        raise SourceError("World Bank response is not JSON") from error
    if not (isinstance(payload, list) and len(payload) == 2 and isinstance(payload[1], list)):
        raise SourceError(f"unexpected World Bank payload: {str(payload)[:200]}")
    meta = payload[0]
    if int(meta.get("pages", 1)) > 1:
        raise SourceError("World Bank result has more than one page; raise per_page")
    return len(payload[1])
