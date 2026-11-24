"""P03 Wikipedia content analytics: a Streamlit in Snowflake app over P03_CONTENT.MART.

In Snowflake the app runs with the rights of its owner role (P03_APP_OWNER), which can read MART only.
Locally: SNOW_CONNECTION=<connection with role P03_APP_OWNER> streamlit run streamlit_app.py
"""

from __future__ import annotations

import datetime as dt
import os

import pandas as pd
import streamlit as st

TOP_N = 25
MAX_SEARCH_LENGTH = 100


@st.cache_resource
def get_session():
    try:
        from snowflake.snowpark.context import get_active_session

        return get_active_session()
    except Exception:
        from snowflake.snowpark import Session

        return Session.builder.config("connection_name", os.environ.get("SNOW_CONNECTION", "p03")).create()


def query(sql: str, params: list | None = None) -> pd.DataFrame:
    # Bind parameters: user input never becomes part of the SQL text.
    return get_session().sql(sql, params=params or []).to_pandas()


# Cached results are shared by all reruns for ten minutes; data only changes when the pipeline reloads.
@st.cache_data(ttl=600)
def load_projects() -> pd.DataFrame:
    return query("SELECT DISTINCT PROJECT, LABEL FROM P03_CONTENT.MART.PROJECT_DAILY ORDER BY PROJECT")


@st.cache_data(ttl=600)
def load_freshness() -> pd.DataFrame:
    return query("SELECT LAST_LOAD_AT, FIRST_DAY, LAST_DAY FROM P03_CONTENT.MART.V_FRESHNESS")


@st.cache_data(ttl=600)
def load_project_daily(project: str) -> pd.DataFrame:
    return query(
        "SELECT DAY, VIEWS, VIEWS_MA7, VIEWS_CHANGE FROM P03_CONTENT.MART.PROJECT_DAILY WHERE PROJECT = ? ORDER BY DAY",
        [project],
    )


@st.cache_data(ttl=600)
def load_top(project: str, day: dt.date, limit: int) -> pd.DataFrame:
    return query(
        """
        SELECT CONTENT_RANK AS RANK, TITLE, VIEWS, SHARE_OF_PROJECT, URL
        FROM P03_CONTENT.MART.ARTICLE_DAILY
        WHERE PROJECT = ? AND DAY = ? AND CONTENT_RANK <= ?
        ORDER BY CONTENT_RANK
        """,
        [project, day.isoformat(), limit],
    )


@st.cache_data(ttl=600)
def load_trending(project: str, day: dt.date, min_views: int) -> pd.DataFrame:
    return query(
        """
        SELECT TITLE, VIEWS, ROUND(AVG_VIEWS_PRIOR_7) AS AVG_PRIOR_7, ROUND(TREND_RATIO, 1) AS TREND_RATIO,
               DAYS_IN_TOP_PRIOR_7, STATUS, URL
        FROM P03_CONTENT.MART.TRENDING
        WHERE PROJECT = ? AND DAY = ? AND VIEWS >= ?
        ORDER BY STATUS = 'returning' DESC, TREND_RATIO DESC NULLS LAST
        LIMIT 15
        """,
        [project, day.isoformat(), min_views],
    )


@st.cache_data(ttl=600)
def search_articles(project: str, text: str) -> pd.DataFrame:
    return query(
        """
        SELECT DAY, TITLE, VIEWS, CONTENT_RANK
        FROM P03_CONTENT.MART.ARTICLE_DAILY
        WHERE PROJECT = ? AND TITLE ILIKE '%' || ? || '%'
        ORDER BY DAY
        LIMIT 2000
        """,
        [project, text],
    )


st.set_page_config(page_title="Wikipedia content analytics", layout="wide")
st.title("Wikipedia content analytics")

projects = load_projects()
if projects.empty:
    st.warning("No data in MART yet. Run the load script, then reload this page.")
    st.stop()

freshness = load_freshness().iloc[0]
first_day = pd.to_datetime(freshness["FIRST_DAY"]).date()
last_day = pd.to_datetime(freshness["LAST_DAY"]).date()

with st.sidebar:
    label_by_project = dict(zip(projects["PROJECT"], projects["LABEL"]))
    project = st.selectbox("Project", list(label_by_project), format_func=label_by_project.get)
    day = st.date_input("Day", value=last_day, min_value=first_day, max_value=last_day)
    st.caption(f"Data {first_day} to {last_day}. Last load {freshness['LAST_LOAD_AT']}.")

daily = load_project_daily(project)
today_row = daily[pd.to_datetime(daily["DAY"]).dt.date == day]
top = load_top(project, day, TOP_N)

col1, col2, col3 = st.columns(3)
if not today_row.empty:
    row = today_row.iloc[0]
    change = None if pd.isna(row["VIEWS_CHANGE"]) else f"{int(row['VIEWS_CHANGE']):,}"
    col1.metric("Pageviews (users)", f"{int(row['VIEWS']):,}", change)
    col2.metric("7-day average", f"{int(row['VIEWS_MA7']):,}")
if not top.empty:
    col3.metric("Top article", top.iloc[0]["TITLE"], f"{int(top.iloc[0]['VIEWS']):,} views", delta_color="off")

tab_top, tab_trending, tab_traffic, tab_search = st.tabs(["Top articles", "Trending", "Project traffic", "Article search"])

with tab_top:
    st.dataframe(
        top,
        hide_index=True,
        column_config={
            "SHARE_OF_PROJECT": st.column_config.NumberColumn("Share of project", format="%.3f"),
            "URL": st.column_config.LinkColumn("Link"),
        },
    )
    st.caption("Main page and special pages are excluded; rank is among content articles only.")

with tab_trending:
    if day < first_day + dt.timedelta(days=7):
        st.info("Trending needs seven earlier days of data; pick a later day.")
    else:
        min_views = st.slider("Minimum views", 1000, 50000, 5000, step=1000)
        st.dataframe(
            load_trending(project, day, min_views),
            hide_index=True,
            column_config={"URL": st.column_config.LinkColumn("Link")},
        )
        st.caption(
            "Trend ratio = views today / average views on earlier days in the top list. "
            "Days outside the top list are unknown, so the baseline is biased upward and ratios are conservative."
        )

with tab_traffic:
    chart = daily.assign(DAY=pd.to_datetime(daily["DAY"])).set_index("DAY")[["VIEWS", "VIEWS_MA7"]]
    st.line_chart(chart)

with tab_search:
    text = st.text_input("Title contains", max_chars=MAX_SEARCH_LENGTH).strip()
    if text:
        found = search_articles(project, text)
        if found.empty:
            st.write("No article with this text in any daily top list.")
        else:
            titles = found["TITLE"].value_counts().index.tolist()[:10]
            title = st.selectbox("Article", titles)
            series = found[found["TITLE"] == title].assign(DAY=lambda df: pd.to_datetime(df["DAY"])).set_index("DAY")
            st.bar_chart(series["VIEWS"])
            st.caption("Only days on which the article was in the top list are shown.")
