"""Snowpark local testing: transformations run without a Snowflake account.

pip install snowflake-snowpark-python pytest
python -m pytest tests/test_transforms.py
"""

from __future__ import annotations

import sys
from datetime import date, datetime
from decimal import Decimal
from pathlib import Path

import pytest
from snowflake.snowpark import Session
from snowflake.snowpark import functions as F
from snowflake.snowpark.types import DateType, DecimalType, LongType, StringType, StructField, StructType, TimestampType

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from retail_pipeline import transforms as T  # noqa: E402

SCHEMA = StructType([
    StructField("INVOICE", StringType()),
    StructField("STOCK_CODE", StringType()),
    StructField("DESCRIPTION", StringType()),
    StructField("QUANTITY", LongType()),
    StructField("INVOICE_DATE", TimestampType()),
    StructField("PRICE", DecimalType(12, 3)),
    StructField("CUSTOMER_ID", LongType()),
    StructField("COUNTRY", StringType()),
])


def line(invoice, code, qty, price, customer=13085, when=datetime(2010, 12, 1, 9, 0), country="United Kingdom", desc=" glass ball "):
    return (invoice, code, desc, qty, when, Decimal(str(price)), customer, country)


@pytest.fixture(scope="module")
def session():
    s = Session.builder.config("local_testing", True).create()
    yield s
    s.close()


@pytest.fixture(scope="module")
def raw(session):
    rows = [
        line("489434", "85048", 12, 6.95),
        line("489434", "85048", 12, 6.95),                      # exact duplicate
        line("489434", "post", 1, 18.0),                         # fee, lower case code
        line("C489449", "85048", -2, 6.95),                      # return
        line("489450", "21733", -12, 0, customer=None),          # stock adjustment with zero price
        line("A506401", "B", 1, -53594.36, customer=None),       # accounting adjustment
        line("489451", "22111", 3, 4.25, customer=None),         # guest sale
        line("489452", "22111", 2, 4.25, customer=12346, when=datetime(2010, 11, 1, 10, 0)),
        line("489453", "22111", 1, 4.25, customer=12347, when=datetime(2010, 12, 5, 10, 0), country="Germany"),
    ]
    return session.create_dataframe(rows, schema=SCHEMA)


def test_classify_deduplicates_and_labels(raw):
    classified = {(r["INVOICE"], r["STOCK_CODE"]): r for r in T.classify_lines(raw).collect()}
    assert len(classified) == 8
    assert classified[("489434", "POST")]["LINE_TYPE"] == "fee"
    assert classified[("C489449", "85048")]["IS_RETURN"] is True
    assert classified[("489450", "21733")]["REJECT_REASON"] == "non_positive_price"
    assert classified[("A506401", "B")]["REJECT_REASON"] == "accounting_adjustment"
    assert classified[("489434", "85048")]["DESCRIPTION"] == "GLASS BALL"


def test_accepted_and_rejected_partition_the_lines(raw):
    classified = T.classify_lines(raw)
    assert T.accepted(classified).count() + T.rejected(classified).count() == classified.count()
    assert T.rejected(classified).count() == 2


def test_daily_sales_separates_returns_and_fees(raw):
    lines = T.accepted(T.classify_lines(raw))
    uk = {r["SALE_DATE"]: r for r in T.daily_sales(lines).filter(F.col("COUNTRY") == "United Kingdom").collect()}
    day = uk[date(2010, 12, 1)]
    assert day["UNITS_SOLD"] == 15                                     # 12 + 3, duplicate removed
    assert float(day["GROSS_REVENUE"]) == pytest.approx(12 * 6.95 + 3 * 4.25)
    assert float(day["RETURNS_REVENUE"]) == pytest.approx(-2 * 6.95)
    assert float(day["NET_REVENUE"]) == pytest.approx(12 * 6.95 + 3 * 4.25 - 2 * 6.95)
    assert float(day["FEE_REVENUE"]) == pytest.approx(18.0)
    assert day["INVOICES"] == 2                                        # returns are not invoices


def test_product_monthly_counts_returned_units(raw):
    lines = T.accepted(T.classify_lines(raw))
    rows = {(r["MONTH_START"], r["STOCK_CODE"]): r for r in T.product_monthly(lines).collect()}
    ball = rows[(date(2010, 12, 1), "85048")]
    assert ball["UNITS_SOLD"] == 12 and ball["UNITS_RETURNED"] == 2
    assert ("POST" not in {code for _, code in rows})


def test_rfm_scores_known_customers_only(raw):
    lines = T.accepted(T.classify_lines(raw)).with_column("AS_OF", F.lit(date(2010, 12, 10)).cast(DateType()))
    rfm = {r["CUSTOMER_ID"]: r for r in T.customer_rfm(lines).collect()}
    assert set(rfm) == {13085, 12346, 12347}
    assert rfm[12346]["RECENCY_DAYS"] == 39
    assert all(1 <= r["R_SCORE"] <= 5 and r["SEGMENT"] for r in rfm.values())
