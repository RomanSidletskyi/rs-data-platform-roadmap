"""P10 daily: once all 24 hours of a UTC day are in STG, build the marts, archive the day as Parquet, then purge.

The archive is verified by reading it back (row count and a hash of event ids) before anything is deleted.
Source drift is a separate leaf task: it turns red and alerts, but it does not block the archive.
"""

from __future__ import annotations

import os
from datetime import datetime, timedelta, timezone

from airflow.providers.common.sql.operators.sql import SQLCheckOperator, SQLExecuteQueryOperator
from airflow.providers.common.sql.sensors.sql import SqlSensor
from airflow.sdk import CronDataIntervalTimetable, dag

SNOWFLAKE_CONN = "p10_snowflake"
START = datetime.fromisoformat(os.environ.get("P10_START_DATE", "2025-01-01")).replace(tzinfo=timezone.utc)
HOT_DAYS = int(os.environ.get("P10_HOT_DAYS", "30"))
RAW_DAYS = int(os.environ.get("P10_RAW_DAYS", "2"))

DAY = "{{ data_interval_start.strftime('%Y-%m-%d') }}"
QUERY_TAG = "ALTER SESSION SET QUERY_TAG = 'p10/{{ dag.dag_id }}/{{ task.task_id }}/{{ data_interval_start.strftime('%Y%m%d') }}'"


def snowflake_call(task_id: str, call: str, **parameters) -> SQLExecuteQueryOperator:
    return SQLExecuteQueryOperator(
        task_id=task_id,
        conn_id=SNOWFLAKE_CONN,
        sql=[QUERY_TAG, call],
        parameters={"day": DAY, "run_id": "{{ run_id }}", **parameters},
        autocommit=True,
        pool="snowflake_p10",
        show_return_value_in_logs=True,
    )


@dag(
    dag_id="p10_gharchive_daily",
    schedule=CronDataIntervalTimetable("0 0 * * *", timezone="UTC"),
    start_date=START,
    catchup=False,
    max_active_runs=2,
    default_args={"owner": "p10", "retries": 1, "retry_delay": timedelta(minutes=10)},
    tags=["p10", "snowflake", "gharchive"],
    doc_md=__doc__,
)
def p10_gharchive_daily():
    # Completeness is read from the data, not from the other DAG's run states: a backfilled or re-run hour counts too.
    # Every poke resumes the warehouse if it is suspended, so poke rarely.
    wait_for_day = SqlSensor(
        task_id="wait_for_24_hours",
        conn_id=SNOWFLAKE_CONN,
        sql=f"SELECT COUNT_IF(BUILT_AT IS NOT NULL) = 24 FROM P10_GH.OPS.HOUR_LOG WHERE EVENT_DAY = '{DAY}'::DATE",
        mode="reschedule",
        poke_interval=1200,
        timeout=8 * 3600,
        pool="snowflake_p10",
    )

    build_day = snowflake_call("build_marts", "CALL P10_GH.OPS.BUILD_DAY(%(day)s::DATE, %(run_id)s)")
    archive_day = snowflake_call("archive_day", "CALL P10_GH.OPS.ARCHIVE_DAY(%(day)s::DATE, %(run_id)s)")
    purge_hot = snowflake_call(
        "purge_hot", "CALL P10_GH.OPS.PURGE_HOT(%(hot_days)s, %(raw_days)s)", hot_days=HOT_DAYS, raw_days=RAW_DAYS
    )

    check_source_drift = SQLCheckOperator(
        task_id="check_source_drift",
        conn_id=SNOWFLAKE_CONN,
        pool="snowflake_p10",
        retries=0,
        sql=f"SELECT COUNT(*) = 0 FROM P10_GH.OPS.SOURCE_DRIFT WHERE EVENT_DAY = '{DAY}'::DATE",
    )

    wait_for_day >> build_day >> archive_day >> purge_hot
    build_day >> check_source_drift


p10_gharchive_daily()
