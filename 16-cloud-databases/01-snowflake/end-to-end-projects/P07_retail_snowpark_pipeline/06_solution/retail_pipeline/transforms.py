"""Pure Snowpark DataFrame transformations. No I/O here, so every function runs in local testing mode."""

from __future__ import annotations

from snowflake.snowpark import DataFrame, Window
from snowflake.snowpark import functions as F

# Stock codes that are charges or bookkeeping entries, not products.
NON_PRODUCT_CODES = [
    "POST", "DOT", "M", "C2", "D", "S", "B", "CRUK", "PADS", "BANK CHARGES", "AMAZONFEE", "ADJUST", "ADJUST2",
]

BUSINESS_COLUMNS = ["INVOICE", "STOCK_CODE", "DESCRIPTION", "QUANTITY", "INVOICE_DATE", "PRICE", "CUSTOMER_ID", "COUNTRY"]


def classify_lines(raw: DataFrame) -> DataFrame:
    """Deduplicate and label every line: return or sale, product or fee, and a reject reason if it is unusable."""
    lines = raw.select(*BUSINESS_COLUMNS).drop_duplicates()
    code = F.upper(F.trim(F.col("STOCK_CODE")))
    is_return = F.col("INVOICE").startswith("C")
    reject_reason = (
        F.when(F.col("INVOICE").startswith("A"), F.lit("accounting_adjustment"))
        .when(F.col("PRICE") <= 0, F.lit("non_positive_price"))
        .when((F.col("QUANTITY") < 0) & ~is_return, F.lit("stock_adjustment"))
        .when((F.col("QUANTITY") > 0) & is_return, F.lit("positive_quantity_on_return"))
        .when(F.col("INVOICE_DATE").is_null(), F.lit("missing_date"))
        .otherwise(F.lit(None).cast("string"))
        # Explicit type for the whole CASE: Snowflake infers it anyway, Snowpark local testing needs it.
        .cast("string")
    )
    return (
        lines.with_column("STOCK_CODE", code)
        .with_column("DESCRIPTION", F.upper(F.trim(F.col("DESCRIPTION"))))
        .with_column("IS_RETURN", is_return)
        .with_column("LINE_TYPE", F.when(code.isin(NON_PRODUCT_CODES), F.lit("fee")).otherwise(F.lit("product")))
        .with_column("REVENUE", F.col("QUANTITY") * F.col("PRICE"))
        .with_column("SALE_DATE", F.to_date(F.col("INVOICE_DATE")))
        .with_column("REJECT_REASON", reject_reason)
    )


def accepted(classified: DataFrame) -> DataFrame:
    return classified.filter(F.col("REJECT_REASON").is_null()).drop("REJECT_REASON")


def rejected(classified: DataFrame) -> DataFrame:
    return classified.filter(F.col("REJECT_REASON").is_not_null())


def daily_sales(lines: DataFrame) -> DataFrame:
    """Per day and country. Returns reduce net revenue; fees are reported apart from product revenue."""
    product = F.col("LINE_TYPE") == "product"
    return lines.group_by("SALE_DATE", "COUNTRY").agg(
        F.count_distinct(F.when(~F.col("IS_RETURN"), F.col("INVOICE")).cast("string")).alias("INVOICES"),
        F.count_distinct(F.col("CUSTOMER_ID")).alias("CUSTOMERS"),
        F.sum(F.when(product & ~F.col("IS_RETURN"), F.col("QUANTITY")).otherwise(F.lit(0))).alias("UNITS_SOLD"),
        F.sum(F.when(product & ~F.col("IS_RETURN"), F.col("REVENUE")).otherwise(F.lit(0))).alias("GROSS_REVENUE"),
        F.sum(F.when(product & F.col("IS_RETURN"), F.col("REVENUE")).otherwise(F.lit(0))).alias("RETURNS_REVENUE"),
        F.sum(F.when(product, F.col("REVENUE")).otherwise(F.lit(0))).alias("NET_REVENUE"),
        F.sum(F.when(~product, F.col("REVENUE")).otherwise(F.lit(0))).alias("FEE_REVENUE"),
    )


def product_monthly(lines: DataFrame) -> DataFrame:
    products = lines.filter(F.col("LINE_TYPE") == "product")
    return products.group_by(F.date_trunc("month", F.col("SALE_DATE")).alias("MONTH_START"), "STOCK_CODE").agg(
        F.max("DESCRIPTION").alias("DESCRIPTION"),
        F.sum(F.when(~F.col("IS_RETURN"), F.col("QUANTITY")).otherwise(F.lit(0))).alias("UNITS_SOLD"),
        F.sum(F.when(F.col("IS_RETURN"), -F.col("QUANTITY")).otherwise(F.lit(0))).alias("UNITS_RETURNED"),
        F.sum("REVENUE").alias("NET_REVENUE"),
    )


def customer_rfm(lines: DataFrame, as_of_column: str = "AS_OF") -> DataFrame:
    """Recency, frequency, monetary per known customer, scored 1 to 5 within the population.

    The input needs an AS_OF column (the same date on every row): the day the scores are computed for.
    """
    known = lines.filter(F.col("CUSTOMER_ID").is_not_null() & (F.col("LINE_TYPE") == "product"))
    base = known.group_by("CUSTOMER_ID").agg(
        F.max(F.when(~F.col("IS_RETURN"), F.col("SALE_DATE")).cast("date")).alias("LAST_PURCHASE"),
        F.count_distinct(F.when(~F.col("IS_RETURN"), F.col("INVOICE")).cast("string")).alias("FREQUENCY"),
        F.sum("REVENUE").alias("MONETARY"),
        F.max(as_of_column).alias("AS_OF"),
    ).filter(F.col("FREQUENCY") > 0)
    scored = base.with_column("RECENCY_DAYS", F.datediff("day", F.col("LAST_PURCHASE"), F.col("AS_OF")))
    return (
        scored.with_column("R_SCORE", F.ntile(F.lit(5)).over(Window.order_by(F.col("RECENCY_DAYS").desc())))
        .with_column("F_SCORE", F.ntile(F.lit(5)).over(Window.order_by(F.col("FREQUENCY"))))
        .with_column("M_SCORE", F.ntile(F.lit(5)).over(Window.order_by(F.col("MONETARY"))))
        .with_column(
            "SEGMENT",
            F.when((F.col("R_SCORE") >= 4) & (F.col("F_SCORE") >= 4), F.lit("champions"))
            .when((F.col("R_SCORE") >= 3) & (F.col("F_SCORE") >= 3), F.lit("loyal"))
            .when(F.col("R_SCORE") >= 4, F.lit("new_or_returning"))
            .when((F.col("R_SCORE") <= 2) & (F.col("F_SCORE") >= 3), F.lit("at_risk"))
            .otherwise(F.lit("hibernating")),
        )
    )
