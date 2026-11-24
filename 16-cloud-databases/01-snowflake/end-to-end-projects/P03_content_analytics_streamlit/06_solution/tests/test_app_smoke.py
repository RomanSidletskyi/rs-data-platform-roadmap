"""Offline smoke test for the Streamlit app with a fake Snowpark session.

pip install streamlit==1.45.1 pandas pytest
python -m pytest test_app_smoke.py
"""

from __future__ import annotations

import sys
import types
from datetime import date, timedelta
from pathlib import Path

import pandas as pd
import pytest
import streamlit as st
from streamlit.testing.v1 import AppTest

APP = Path(__file__).resolve().parents[1] / "app" / "streamlit_app.py"
LAST = date(2024, 3, 30)
DAYS = [LAST - timedelta(days=n) for n in range(13, -1, -1)]


class FakeResult:
    def __init__(self, frame: pd.DataFrame):
        self.frame = frame

    def to_pandas(self) -> pd.DataFrame:
        return self.frame


class FakeSession:
    def __init__(self) -> None:
        self.calls: list[tuple[str, list]] = []

    def sql(self, sql: str, params: list | None = None) -> FakeResult:
        self.calls.append((sql, params or []))
        text = " ".join(sql.split())
        if "SELECT DISTINCT PROJECT, LABEL" in text:
            return FakeResult(pd.DataFrame({"PROJECT": ["en.wikipedia", "uk.wikipedia"], "LABEL": ["English", "Ukrainian"]}))
        if "V_FRESHNESS" in text:
            return FakeResult(pd.DataFrame({"LAST_LOAD_AT": ["2024-04-01 08:00"], "FIRST_DAY": [DAYS[0]], "LAST_DAY": [LAST]}))
        if "MART.PROJECT_DAILY" in text:
            views = [1_000_000 + 1000 * i for i in range(len(DAYS))]
            return FakeResult(pd.DataFrame({"DAY": DAYS, "VIEWS": views, "VIEWS_MA7": views, "VIEWS_CHANGE": [None] + [1000] * (len(DAYS) - 1)}))
        if "MART.TRENDING" in text:
            return FakeResult(pd.DataFrame({
                "TITLE": ["Eclipse"], "VIEWS": [90000], "AVG_PRIOR_7": [10000], "TREND_RATIO": [9.0],
                "DAYS_IN_TOP_PRIOR_7": [3], "STATUS": ["returning"], "URL": ["https://en.wikipedia.org/wiki/Eclipse"],
            }))
        if "ILIKE" in text:
            return FakeResult(pd.DataFrame({"DAY": DAYS[-3:], "TITLE": ["Eclipse"] * 3, "VIEWS": [5000, 20000, 90000], "CONTENT_RANK": [300, 40, 2]}))
        if "MART.ARTICLE_DAILY" in text:
            return FakeResult(pd.DataFrame({
                "RANK": [1, 2], "TITLE": ["Eclipse", "Moon"], "VIEWS": [90000, 50000],
                "SHARE_OF_PROJECT": [0.009, 0.005], "URL": ["https://en.wikipedia.org/wiki/Eclipse", "https://en.wikipedia.org/wiki/Moon"],
            }))
        raise AssertionError(f"unexpected query: {text}")


@pytest.fixture
def session(monkeypatch: pytest.MonkeyPatch) -> FakeSession:
    fake = FakeSession()
    context = types.ModuleType("snowflake.snowpark.context")
    context.get_active_session = lambda: fake
    snowpark = types.ModuleType("snowflake.snowpark")
    snowpark.context = context
    snowflake = types.ModuleType("snowflake")
    snowflake.snowpark = snowpark
    monkeypatch.setitem(sys.modules, "snowflake", snowflake)
    monkeypatch.setitem(sys.modules, "snowflake.snowpark", snowpark)
    monkeypatch.setitem(sys.modules, "snowflake.snowpark.context", context)
    # The app caches the session and query results; each test needs a clean process-level cache.
    st.cache_resource.clear()
    st.cache_data.clear()
    return fake


def test_app_renders_all_tabs_without_errors(session: FakeSession):
    at = AppTest.from_file(str(APP), default_timeout=30).run()
    assert not at.exception
    assert at.title[0].value == "Wikipedia content analytics"
    assert len(at.metric) == 3
    assert len(at.tabs) == 4


def test_search_text_is_bound_not_concatenated(session: FakeSession):
    at = AppTest.from_file(str(APP), default_timeout=30).run()
    malicious = "x' OR 1=1 --"
    at.text_input[0].input(malicious).run()
    assert not at.exception
    search_calls = [(sql, params) for sql, params in session.calls if "ILIKE" in sql]
    assert search_calls, "search query was not executed"
    for sql, params in search_calls:
        assert malicious not in sql
        assert malicious in params
