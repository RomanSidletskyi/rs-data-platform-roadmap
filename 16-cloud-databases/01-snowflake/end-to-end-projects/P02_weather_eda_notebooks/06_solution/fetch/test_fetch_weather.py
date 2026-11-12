"""Offline checks for fetch_weather: python -m pytest test_fetch_weather.py"""

import urllib.parse
from datetime import date

from fetch_weather import HOURLY, build_url, with_source, year_range


def test_build_url_has_all_hourly_variables_and_utc():
    url = build_url(50.45, 30.52, date(2024, 1, 1), date(2024, 12, 31))
    query = urllib.parse.parse_qs(urllib.parse.urlparse(url).query)
    assert query["hourly"] == [",".join(HOURLY)]
    assert query["timezone"] == ["UTC"]
    assert query["start_date"] == ["2024-01-01"] and query["end_date"] == ["2024-12-31"]


def test_year_range_stops_a_week_before_today():
    assert year_range(2024, date(2026, 1, 1)) == (date(2024, 1, 1), date(2024, 12, 31))
    assert year_range(2026, date(2026, 3, 10)) == (date(2026, 1, 1), date(2026, 3, 3))
    assert year_range(2026, date(2026, 1, 3)) is None


def test_with_source_adds_lineage():
    payload = with_source({"hourly": {"time": []}}, "kyiv", "Kyiv", "Europe/Kiev", 2024)
    assert payload["_source"]["city_slug"] == "kyiv"
    assert payload["_source"]["year"] == 2024
    assert "fetched_at" in payload["_source"]
