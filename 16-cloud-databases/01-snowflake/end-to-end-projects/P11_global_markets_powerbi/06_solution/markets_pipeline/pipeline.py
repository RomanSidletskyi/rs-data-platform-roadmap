"""I/O around the transforms: read the RAW views, rebuild CORE tables beside the live ones, then swap.

Runs as a client from a laptop or as the stored procedure CORE.SP_BUILD_MARKETS (handler: markets_pipeline.pipeline.build).
"""

from __future__ import annotations

import json

from snowflake.snowpark import DataFrame, Session
from snowflake.snowpark.types import BooleanType, DoubleType, StringType, StructField, StructType

from . import transforms as T
from .units import unit_rows

CORE_TABLES = ("CORE.UNIT_MAP", "CORE.FX_MONTHLY", "CORE.FOOD_PRICE")
UNIT_SCHEMA = StructType([
    StructField("UNIT", StringType()),
    StructField("BASE_UNIT", StringType()),
    StructField("QUANTITY_IN_BASE", DoubleType()),
    StructField("IS_COMPARABLE", BooleanType()),
])


def consume_arrivals(session: Session) -> int:
    """Record which files arrived since the last build. Reading a stream inside DML advances its offset."""
    rows = 0
    for source, stream in (("WFP", "RAW.WFP_STREAM"), ("ECB", "RAW.ECB_STREAM"), ("WORLDBANK", "RAW.WB_STREAM")):
        result = session.sql(
            f"INSERT INTO OPS.ARRIVALS (SOURCE, SRC_FILE, ROWS_LOADED, RECORDED_AT) "
            f"SELECT '{source}', SRC_FILE, COUNT(*), CURRENT_TIMESTAMP() FROM {stream} GROUP BY SRC_FILE"
        ).collect()
        rows += result[0][0] if result else 0
    return rows


def replace_table(session: Session, frame: DataFrame, table: str) -> int:
    """Build beside, then swap: readers see the old table or the new one, never an empty or half-written one."""
    staging = f"{table}__NEXT"
    session.sql(f"CREATE OR REPLACE TABLE {staging} LIKE {table}").collect()
    frame.write.save_as_table(staging, mode="append", column_order="name")
    session.sql(f"ALTER TABLE {table} SWAP WITH {staging}").collect()
    session.sql(f"DROP TABLE {staging}").collect()
    return session.table(table).count()


def build(session: Session) -> str:
    arrivals = consume_arrivals(session)

    clean = T.clean_wfp(session.table("RAW.WFP_PRICE_LATEST_V"))
    units = [row["UNIT"] for row in clean.select("UNIT").distinct().collect()]
    unit_map = session.create_dataframe(unit_rows(units), schema=UNIT_SCHEMA)

    fx = T.fx_monthly(T.ecb_cross_rates(session.table("RAW.ECB_FX_V")), T.wfp_implied_fx(clean))
    prices = T.food_prices(clean, unit_map, fx)

    counts = {
        "arrived_files": arrivals,
        "unit_map": replace_table(session, unit_map, "CORE.UNIT_MAP"),
        "fx_monthly": replace_table(session, fx, "CORE.FX_MONTHLY"),
        "food_price": replace_table(session, prices, "CORE.FOOD_PRICE"),
    }
    session.sql(
        "INSERT INTO OPS.BUILD_LOG (BUILT_AT, DETAILS) SELECT CURRENT_TIMESTAMP(), PARSE_JSON(?)",
        params=[json.dumps(counts)],
    ).collect()
    return json.dumps(counts)
