"""Snowpark local testing: units and transformations run without a Snowflake account.

pip install snowflake-snowpark-python pytest
python -m pytest tests/test_transforms.py
"""

from __future__ import annotations

import sys
from pathlib import Path

import pytest
from snowflake.snowpark import Session
from snowflake.snowpark.types import BooleanType, DoubleType, StringType, StructField, StructType

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from markets_pipeline import transforms as T  # noqa: E402
from markets_pipeline.pipeline import UNIT_SCHEMA  # noqa: E402
from markets_pipeline.units import parse_unit, unit_rows  # noqa: E402

WFP_COLUMNS = [
    "COUNTRY_ISO3", "SOURCE_VERSION", "DATE", "ADMIN1", "MARKET", "MARKET_ID", "LATITUDE", "LONGITUDE", "CATEGORY",
    "COMMODITY", "COMMODITY_ID", "UNIT", "PRICEFLAG", "PRICETYPE", "CURRENCY", "PRICE", "USDPRICE",
]
WFP_SCHEMA = StructType([StructField(c, StringType()) for c in WFP_COLUMNS])
ECB_SCHEMA = StructType([StructField("CURRENCY", StringType()), StructField("MONTH", StringType()), StructField("UNITS_PER_EUR", DoubleType())])


@pytest.fixture(scope="module")
def session():
    s = Session.builder.config("local_testing", True).create()
    yield s
    s.close()


def missing(value):
    """Local testing returns NaN where Snowflake returns NULL for a missing double."""
    return value is None or value != value


def wfp(iso3, version, date, unit, price, usd, currency="KES", market="Mombasa", commodity="Maize"):
    return (iso3, version, date, "Coast", market, "191", "-4.05", "39.67", "cereals and tubers", commodity, "51", unit,
            "actual", "Retail", currency, str(price), str(usd))


def test_parse_unit():
    assert parse_unit("90 KG").quantity_in_base == 90 and parse_unit("90 KG").base_unit == "KG"
    assert parse_unit("500 ML").quantity_in_base == 0.5 and parse_unit("500 ML").base_unit == "L"
    assert parse_unit("200 G").quantity_in_base == 0.2
    assert parse_unit("KG").quantity_in_base == 1 and parse_unit("L").is_comparable
    for unit in ("Unit", "30 pcs", "Head", "kWh", "Cubic meter", "100 Tubers", "", "0 KG"):
        assert not parse_unit(unit).is_comparable, unit
    assert [r[0] for r in unit_rows(["KG", "Unit", "KG"])] == ["KG", "Unit"]


def test_cleaning_drops_tag_rows_and_non_positive_prices(session):
    raw = session.create_dataframe([
        wfp("KEN", "20261104T012421", "2026-09-15", "KG", 60, 0.46),
        wfp("KEN", "20261104T012421", "#date", "#item+unit", "#value", "#value+usd"),
        wfp("KEN", "20261104T012421", "2026-10-15", "KG", 0, 0),
        wfp("TUR", "20261104T020130", "2026-10-15", "L", 90, 1.85, currency="TRY"),
    ], schema=WFP_SCHEMA)
    clean = T.clean_wfp(raw).collect()
    assert sorted((r["COUNTRY_ISO3"], r["MONTH"], r["PRICE_LOCAL"]) for r in clean) == [("KEN", "2026-09", 60.0), ("TUR", "2026-10", 90.0)]
    assert {r["MARKET_ID"] for r in clean} == {191}


def test_implied_fx_is_weighted_by_price(session):
    raw = session.create_dataframe([
        wfp("KEN", "v1", "2026-10-15", "KG", 23, 0.18),       # alone: 127.8 KES per USD, rounding error
        wfp("KEN", "v1", "2026-10-15", "90 KG", 5200, 40.0),  # alone: 130
    ], schema=WFP_SCHEMA)
    implied = T.wfp_implied_fx(T.clean_wfp(raw)).collect()[0]
    assert implied["WFP_UNITS_PER_USD"] == pytest.approx((23 + 5200) / (0.18 + 40.0))
    assert implied["WFP_FX_ROWS"] == 2


def test_fx_prefers_ecb_and_fills_with_wfp(session):
    ecb = session.create_dataframe([("USD", "2026-10", 1.12), ("INR", "2026-10", 107.0)], schema=ECB_SCHEMA)
    raw = session.create_dataframe([
        wfp("KEN", "v1", "2026-10-15", "KG", 130, 1.0),
        wfp("IND", "v1", "2026-10-15", "KG", 96, 1.0, currency="INR"),
    ], schema=WFP_SCHEMA)
    fx = {r["CURRENCY"]: r for r in T.fx_monthly(T.ecb_cross_rates(ecb), T.wfp_implied_fx(T.clean_wfp(raw))).collect()}
    assert fx["INR"]["FX_SOURCE"] == "ECB"
    assert fx["INR"]["UNITS_PER_USD"] == pytest.approx(107.0 / 1.12)
    assert fx["INR"]["ECB_WFP_DIFF_PCT"] == pytest.approx((96 / (107.0 / 1.12) - 1) * 100)
    assert fx["KES"]["FX_SOURCE"] == "WFP_IMPLIED" and fx["KES"]["UNITS_PER_USD"] == pytest.approx(130.0)
    assert fx["KES"]["USD_PER_EUR"] == pytest.approx(1.12)
    assert fx["USD"]["UNITS_PER_USD"] == pytest.approx(1.0)


def test_food_prices_per_kilogram_in_three_currencies(session):
    raw = session.create_dataframe([
        wfp("KEN", "v1", "2026-10-15", "90 KG", 5400, 41.5),
        wfp("KEN", "v1", "2026-10-15", "Unit", 20, 0.15, commodity="Eggs"),
    ], schema=WFP_SCHEMA)
    clean = T.clean_wfp(raw)
    units = session.create_dataframe(unit_rows(["90 KG", "Unit"]), schema=UNIT_SCHEMA)
    ecb = session.create_dataframe([("USD", "2026-10", 1.12)], schema=ECB_SCHEMA)
    fx = T.fx_monthly(T.ecb_cross_rates(ecb), T.wfp_implied_fx(clean))
    rows = {r["COMMODITY"]: r for r in T.food_prices(clean, units, fx).collect()}
    maize = rows["Maize"]
    kes_per_usd = (5400 + 20) / (41.5 + 0.15)
    assert maize["IS_COMPARABLE"] and maize["BASE_UNIT"] == "KG"
    assert maize["PRICE_LOCAL_PER_BASE"] == pytest.approx(60.0)
    assert maize["PRICE_USD_PER_BASE"] == pytest.approx(60.0 / kes_per_usd)
    assert maize["PRICE_EUR_PER_BASE"] == pytest.approx(60.0 / kes_per_usd / 1.12)
    assert maize["FX_SOURCE"] == "WFP_IMPLIED"
    eggs = rows["Eggs"]
    assert eggs["IS_COMPARABLE"] is False and missing(eggs["PRICE_USD_PER_BASE"]) and eggs["PRICE_LOCAL"] == 20.0


def test_unit_schema_matches_rows():
    assert [f.name for f in UNIT_SCHEMA.fields] == ["UNIT", "BASE_UNIT", "QUANTITY_IN_BASE", "IS_COMPARABLE"]
    assert isinstance(UNIT_SCHEMA.fields[3].datatype, BooleanType)
