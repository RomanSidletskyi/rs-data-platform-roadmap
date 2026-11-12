"""I/O around the transforms: read months from RAW, write STG and MART idempotently.

The same code runs from a laptop (client session) and inside Snowflake as a stored procedure
(handler: retail_pipeline.pipeline.process_new_months).
"""

from __future__ import annotations

from snowflake.snowpark import Session
from snowflake.snowpark import functions as F

from . import transforms as T

RAW = "RAW.ONLINE_RETAIL"
STG_LINE = "STG.SALES_LINE"
STG_REJECT = "STG.REJECTED_LINE"
DAILY = "MART.DAILY_SALES"
PRODUCT = "MART.PRODUCT_MONTHLY"
RFM = "MART.CUSTOMER_RFM"


def pending_months(session: Session) -> list[str]:
    """Months with raw rows loaded after the month was last processed (or never processed)."""
    rows = session.sql(
        """
        SELECT r.MONTH
        FROM RAW.ONLINE_RETAIL r
        LEFT JOIN OPS.MONTH_STATUS s ON s.MONTH = r.MONTH
        GROUP BY r.MONTH, s.PROCESSED_AT
        HAVING s.PROCESSED_AT IS NULL OR MAX(r.LOADED_AT) > s.PROCESSED_AT
        ORDER BY r.MONTH
        """
    ).collect()
    return [row["MONTH"] for row in rows]


def run_month(session: Session, month: str) -> dict[str, int]:
    """Replace one month in STG and MART. Delete and insert in one transaction, so a rerun gives the same result."""
    classified = T.classify_lines(session.table(RAW).filter(F.col("MONTH") == month)).with_column("MONTH", F.lit(month))
    session.sql("BEGIN").collect()
    try:
        for table in (STG_LINE, STG_REJECT):
            session.sql(f"DELETE FROM {table} WHERE MONTH = ?", params=[month]).collect()
        session.sql(f"DELETE FROM {DAILY} WHERE TO_CHAR(SALE_DATE, 'YYYY-MM') = ?", params=[month]).collect()
        session.sql(f"DELETE FROM {PRODUCT} WHERE TO_CHAR(MONTH_START, 'YYYY-MM') = ?", params=[month]).collect()

        T.accepted(classified).write.save_as_table(STG_LINE, mode="append", column_order="name")
        T.rejected(classified).write.save_as_table(STG_REJECT, mode="append", column_order="name")

        lines = session.table(STG_LINE).filter(F.col("MONTH") == month)
        T.daily_sales(lines).write.save_as_table(DAILY, mode="append", column_order="name")
        T.product_monthly(lines).write.save_as_table(PRODUCT, mode="append", column_order="name")

        counts = {
            "accepted": lines.count(),
            "rejected": session.table(STG_REJECT).filter(F.col("MONTH") == month).count(),
        }
        session.sql(
            """
            MERGE INTO OPS.MONTH_STATUS t
            USING (SELECT ? AS MONTH, ? AS ACCEPTED, ? AS REJECTED) s ON t.MONTH = s.MONTH
            WHEN MATCHED THEN UPDATE SET PROCESSED_AT = CURRENT_TIMESTAMP(), ACCEPTED = s.ACCEPTED, REJECTED = s.REJECTED
            WHEN NOT MATCHED THEN INSERT (MONTH, PROCESSED_AT, ACCEPTED, REJECTED)
              VALUES (s.MONTH, CURRENT_TIMESTAMP(), s.ACCEPTED, s.REJECTED)
            """,
            params=[month, counts["accepted"], counts["rejected"]],
        ).collect()
        session.sql("COMMIT").collect()
    except Exception:
        session.sql("ROLLBACK").collect()
        raise
    return counts


def refresh_rfm(session: Session) -> int:
    """RFM needs all history, so it is recomputed in full after the monthly runs."""
    lines = session.table(STG_LINE)
    as_of = lines.agg(F.max("SALE_DATE")).collect()[0][0]
    if as_of is None:
        return 0
    rfm = T.customer_rfm(lines.with_column("AS_OF", F.lit(as_of)))
    session.sql("BEGIN").collect()
    try:
        session.sql(f"DELETE FROM {RFM}").collect()
        rfm.write.save_as_table(RFM, mode="append", column_order="name")
        session.sql("COMMIT").collect()
    except Exception:
        session.sql("ROLLBACK").collect()
        raise
    return session.table(RFM).count()


def process_new_months(session: Session) -> str:
    """Stored procedure handler: process every pending month in order, then refresh RFM, then log."""
    months = pending_months(session)
    results = {month: run_month(session, month) for month in months}
    customers = refresh_rfm(session) if months else 0
    summary = f"{len(months)} months processed, {customers} customers scored"
    if months:
        summary += f" ({months[0]} to {months[-1]}, {sum(r['accepted'] for r in results.values())} lines accepted)"
    session.sql(
        "INSERT INTO OPS.RUN_LOG (RUN_AT, STEP, NOTE) SELECT CURRENT_TIMESTAMP(), 'PROCESS_NEW_MONTHS', ?",
        params=[summary],
    ).collect()
    return summary
