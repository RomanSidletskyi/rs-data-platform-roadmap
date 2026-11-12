"""Offline checks for the extractor: python -m pytest test_extract_markets.py"""

from datetime import datetime, timedelta, timezone

from extract_markets import MAX_CANDLES, envelope, floor_hour, windows

T0 = datetime(2026, 11, 1, tzinfo=timezone.utc)


def test_windows_cover_range_without_gaps_or_overlap():
    end = T0 + timedelta(days=30)
    result = windows(T0, end, 3600)
    assert result[0][0] == T0 and result[-1][1] == end
    assert all(a[1] == b[0] for a, b in zip(result, result[1:]))
    assert all((w[1] - w[0]) <= timedelta(hours=MAX_CANDLES) for w in result)


def test_short_range_is_one_window():
    assert windows(T0, T0 + timedelta(hours=5), 3600) == [(T0, T0 + timedelta(hours=5))]


def test_floor_hour():
    assert floor_hour(datetime(2026, 11, 1, 13, 59, 7, tzinfo=timezone.utc)) == datetime(2026, 11, 1, 13, tzinfo=timezone.utc)


def test_envelope_keeps_candles_as_delivered():
    candles = [[1794336300, 1.0, 2.0, 1.5, 1.7, 3.0]]
    doc = envelope("BTC-USD", 3600, T0, T0 + timedelta(hours=1), candles)
    assert doc["candles"] is candles and doc["product"] == "BTC-USD" and doc["granularity"] == 3600
    assert "fetched_at" in doc
