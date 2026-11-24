"""Offline checks for fetch_pageviews: python -m pytest test_fetch_pageviews.py"""

from datetime import date

from fetch_pageviews import aggregate_url, day_range, default_end, top_url, with_source


def test_top_url_uses_slashed_date():
    assert top_url("uk.wikipedia", date(2024, 3, 5)).endswith("/top/uk.wikipedia/all-access/2024/03/05")


def test_aggregate_url_uses_hour_suffix_and_user_agent_type():
    url = aggregate_url("en.wikipedia", date(2024, 3, 1), date(2024, 3, 30))
    assert url.endswith("/aggregate/en.wikipedia/all-access/user/daily/2024030100/2024033000")


def test_day_range_is_ascending_and_inclusive():
    days = day_range(date(2024, 3, 3), 3)
    assert days == [date(2024, 3, 1), date(2024, 3, 2), date(2024, 3, 3)]


def test_default_end_is_two_days_back():
    assert default_end(date(2024, 3, 3)) == date(2024, 3, 1)


def test_with_source_adds_lineage_and_extra_fields():
    payload = with_source({"items": []}, "top", "de.wikipedia", "https://x", day="2024-03-01")
    assert payload["_source"]["kind"] == "top"
    assert payload["_source"]["day"] == "2024-03-01"
    assert "fetched_at" in payload["_source"]
