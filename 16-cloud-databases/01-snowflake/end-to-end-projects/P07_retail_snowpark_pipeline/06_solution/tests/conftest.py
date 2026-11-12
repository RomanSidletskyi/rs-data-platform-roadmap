"""Patches for functions that Snowpark local testing does not implement yet.

Each patch mirrors Snowflake semantics for the inputs the tests use. When a newer Snowpark version implements a
function, its patch can be deleted.
"""

from snowflake.snowpark import functions as F
from snowflake.snowpark.mock import ColumnEmulator, ColumnType, patch
from snowflake.snowpark.types import StringType


@patch(F.trim)
def _trim(column: ColumnEmulator, trim_string=None) -> ColumnEmulator:
    result = column.apply(lambda v: v.strip() if isinstance(v, str) else v)
    result.sf_type = ColumnType(StringType(), column.sf_type.nullable)
    return result
