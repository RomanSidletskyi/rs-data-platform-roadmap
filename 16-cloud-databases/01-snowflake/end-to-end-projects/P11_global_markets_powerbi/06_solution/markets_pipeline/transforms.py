"""Pure Snowpark DataFrame transformations. No I/O, so every function runs in Snowpark local testing."""

from __future__ import annotations

from snowflake.snowpark import DataFrame
from snowflake.snowpark import functions as F
from snowflake.snowpark.types import DoubleType, LongType



def clean_wfp(snapshot: DataFrame) -> DataFrame:
    """Typed rows with a positive local price from the newest snapshot per country (RAW.WFP_PRICE_LATEST_V).

    Older HDX exports had a second header row of HXL tags (#date, ...); it must not become a price.
    """
    # TRY_CAST: a tag row or a stray text value becomes NULL instead of failing the whole build.
    typed = snapshot.select(
        F.col("COUNTRY_ISO3"),
        F.col("SOURCE_VERSION"),
        F.substring(F.col("DATE"), 1, 7).alias("MONTH"),
        F.col("MARKET_ID").try_cast(LongType()).alias("MARKET_ID"),
        F.col("MARKET"),
        F.col("ADMIN1"),
        F.col("LATITUDE").try_cast(DoubleType()).alias("LATITUDE"),
        F.col("LONGITUDE").try_cast(DoubleType()).alias("LONGITUDE"),
        F.col("CATEGORY"),
        F.col("COMMODITY_ID").try_cast(LongType()).alias("COMMODITY_ID"),
        F.col("COMMODITY"),
        F.col("UNIT"),
        F.col("PRICEFLAG").alias("PRICE_FLAG"),
        F.col("PRICETYPE").alias("PRICE_TYPE"),
        F.col("CURRENCY"),
        F.col("PRICE").try_cast(DoubleType()).alias("PRICE_LOCAL"),
        F.col("USDPRICE").try_cast(DoubleType()).alias("WFP_USD_PRICE"),
        F.col("DATE").startswith("#").alias("_IS_TAG_ROW"),
    )
    # Filter once, after all columns exist (Snowpark local testing misaligns columns computed after a filter).
    return typed.filter(~F.col("_IS_TAG_ROW") & (F.col("PRICE_LOCAL") > 0)).drop("_IS_TAG_ROW")


def wfp_implied_fx(prices: DataFrame) -> DataFrame:
    """Local units per USD implied by WFP, weighted by price: sum of local prices over sum of USD prices.

    WFP rounds usdprice to cents, so a 0.24 USD row alone can be 2 percent off; the weighted ratio is not.
    """
    usable = prices.filter(F.col("WFP_USD_PRICE") > 0)
    return usable.group_by("CURRENCY", "MONTH").agg(
        (F.sum("PRICE_LOCAL") / F.sum("WFP_USD_PRICE")).alias("WFP_UNITS_PER_USD"),
        F.count(F.lit(1)).alias("WFP_FX_ROWS"),
    )


def ecb_cross_rates(ecb: DataFrame) -> DataFrame:
    """ECB publishes units per EUR. Cross through USD for every currency, and keep USD per EUR for EUR prices."""
    usd = ecb.filter(F.col("CURRENCY") == "USD").select(F.col("MONTH"), F.col("UNITS_PER_EUR").alias("USD_PER_EUR"))
    return ecb.join(usd, "MONTH").select(
        F.col("CURRENCY"),
        F.col("MONTH"),
        F.col("USD_PER_EUR"),
        (F.col("UNITS_PER_EUR") / F.col("USD_PER_EUR")).alias("ECB_UNITS_PER_USD"),
    )


def fx_monthly(ecb_cross: DataFrame, implied: DataFrame) -> DataFrame:
    """One rate per currency and month. ECB wins where it publishes the currency; WFP's implied rate fills the rest."""
    keys = ecb_cross.select("CURRENCY", "MONTH").union(implied.select("CURRENCY", "MONTH"))
    usd_per_eur = ecb_cross.filter(F.col("CURRENCY") == "USD").select("MONTH", "USD_PER_EUR")
    joined = (
        keys.join(ecb_cross.select("CURRENCY", "MONTH", "ECB_UNITS_PER_USD", F.lit("ECB").alias("_ECB")), ["CURRENCY", "MONTH"], "left")
        .join(implied, ["CURRENCY", "MONTH"], "left")
        .join(usd_per_eur, "MONTH", "left")
    )
    diff_pct = (F.col("WFP_UNITS_PER_USD") / F.col("ECB_UNITS_PER_USD") - 1) * 100
    return joined.select(
        F.col("CURRENCY"),
        F.col("MONTH"),
        F.coalesce(F.col("ECB_UNITS_PER_USD"), F.col("WFP_UNITS_PER_USD")).alias("UNITS_PER_USD"),
        F.col("USD_PER_EUR"),
        F.coalesce(F.col("_ECB"), F.lit("WFP_IMPLIED")).alias("FX_SOURCE"),
        F.col("ECB_UNITS_PER_USD"),
        F.col("WFP_UNITS_PER_USD"),
        diff_pct.alias("ECB_WFP_DIFF_PCT"),
    )


def food_prices(clean: DataFrame, unit_map: DataFrame, fx: DataFrame) -> DataFrame:
    """Prices per kilogram or litre in local currency, USD, and EUR. Units that are counts keep their local price only."""
    joined = clean.join(unit_map, "UNIT", "left").join(fx.select("CURRENCY", "MONTH", "UNITS_PER_USD", "USD_PER_EUR", "FX_SOURCE"), ["CURRENCY", "MONTH"], "left")
    comparable = F.coalesce(F.col("IS_COMPARABLE"), F.lit(False))
    per_base = F.when(comparable, F.col("PRICE_LOCAL") / F.col("QUANTITY_IN_BASE"))
    per_base_usd = per_base / F.col("UNITS_PER_USD")
    return joined.select(
        F.col("COUNTRY_ISO3"),
        F.col("MONTH"),
        F.col("MARKET_ID"),
        F.col("MARKET"),
        F.col("ADMIN1"),
        F.col("LATITUDE"),
        F.col("LONGITUDE"),
        F.col("CATEGORY"),
        F.col("COMMODITY_ID"),
        F.col("COMMODITY"),
        F.col("UNIT"),
        F.col("PRICE_TYPE"),
        F.col("PRICE_FLAG"),
        F.col("CURRENCY"),
        F.col("PRICE_LOCAL"),
        F.col("WFP_USD_PRICE"),
        comparable.alias("IS_COMPARABLE"),
        F.col("BASE_UNIT"),
        per_base.cast("double").alias("PRICE_LOCAL_PER_BASE"),
        per_base_usd.cast("double").alias("PRICE_USD_PER_BASE"),
        (per_base_usd / F.col("USD_PER_EUR")).cast("double").alias("PRICE_EUR_PER_BASE"),
        F.col("FX_SOURCE"),
        F.col("SOURCE_VERSION"),
    )
