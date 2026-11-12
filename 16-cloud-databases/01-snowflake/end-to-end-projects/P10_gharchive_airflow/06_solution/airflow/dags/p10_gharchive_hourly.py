"""P10 hourly: wait for one GH Archive hour, land the file, load RAW, build STG, check the hour.

Every task works on the run's data interval only, so a retry, a cleared task, or a backfill of the same hour
gives the same result. The Snowflake work lives in procedures; this DAG decides when and in which order.
"""

from __future__ import annotations

import os
import tempfile
from datetime import datetime, timedelta, timezone
from pathlib import Path

import requests
from airflow.providers.common.sql.operators.sql import SQLCheckOperator, SQLExecuteQueryOperator
from airflow.sdk import CronDataIntervalTimetable, Param, dag, task

import gharchive_lib as gh

SNOWFLAKE_CONN = "p10_snowflake"
LANDING = os.environ.get("P10_LANDING", "internal")  # internal | azure | aws
START = datetime.fromisoformat(os.environ.get("P10_START_DATE", "2025-01-01")).replace(tzinfo=timezone.utc)

HOUR = "{{ data_interval_start.strftime('%Y-%m-%d %H:%M:%S') }}"
QUERY_TAG = "ALTER SESSION SET QUERY_TAG = 'p10/{{ dag.dag_id }}/{{ task.task_id }}/{{ data_interval_start.strftime('%Y%m%dT%H') }}'"


def _download(url: str, target: Path) -> int:
    with requests.get(url, headers={"User-Agent": gh.USER_AGENT}, stream=True, timeout=(10, 300)) as response:
        response.raise_for_status()
        expected = int(response.headers["Content-Length"]) if "Content-Length" in response.headers else None
        with target.open("wb") as out:
            for chunk in response.iter_content(chunk_size=1 << 20):
                out.write(chunk)
    gh.check_size(expected, target.stat().st_size)
    return target.stat().st_size


def _land_internal(hour: datetime, force: bool) -> str:
    from airflow.providers.snowflake.hooks.snowflake import SnowflakeHook

    hook = SnowflakeHook(snowflake_conn_id=SNOWFLAKE_CONN)
    key = gh.landing_key(hour)
    if not gh.should_land(bool(hook.get_first(f"LIST @P10_GH.RAW.LANDING_STAGE/{key}")), force):
        return f"exists: @RAW.LANDING_STAGE/{key}"
    with tempfile.TemporaryDirectory() as tmp:
        local = Path(tmp) / gh.hour_file_name(hour)
        size = _download(gh.source_url(hour), local)
        folder = key.rsplit("/", 1)[0]
        hook.run(f"PUT 'file://{local}' @P10_GH.RAW.LANDING_STAGE/{folder}/ AUTO_COMPRESS = FALSE OVERWRITE = TRUE")
    return f"landed {size} bytes: @RAW.LANDING_STAGE/{key}"


def _land_azure(hour: datetime, force: bool) -> str:
    from airflow.providers.microsoft.azure.hooks.wasb import WasbHook

    hook = WasbHook(wasb_conn_id="p10_azure")
    container = os.environ.get("P10_AZURE_CONTAINER", "landing")
    key = gh.landing_key(hour)
    if not gh.should_land(hook.check_for_blob(container, key), force):
        return f"exists: {container}/{key}"
    with requests.get(gh.source_url(hour), headers={"User-Agent": gh.USER_AGENT}, stream=True, timeout=(10, 300)) as response:
        response.raise_for_status()
        length = int(response.headers["Content-Length"])
        # Streamed straight into a block blob; the blob becomes visible only after the final commit.
        hook.upload(container, key, response.raw, length=length, overwrite=True)
    return f"landed {length} bytes: {container}/{key}"


def _land_aws(hour: datetime, force: bool) -> str:
    from airflow.providers.amazon.aws.hooks.s3 import S3Hook

    hook = S3Hook(aws_conn_id="p10_aws")
    bucket = os.environ["P10_S3_BUCKET"]
    key = gh.landing_key(hour, root=os.environ.get("P10_S3_ROOT", "landing/"))
    if not gh.should_land(hook.check_for_key(key, bucket), force):
        return f"exists: s3://{bucket}/{key}"
    with tempfile.TemporaryDirectory() as tmp:
        local = Path(tmp) / gh.hour_file_name(hour)
        size = _download(gh.source_url(hour), local)
        hook.load_file(str(local), key, bucket_name=bucket, replace=True)
    gh.check_size(size, int(hook.head_object(key, bucket)["ContentLength"]))
    return f"landed {size} bytes: s3://{bucket}/{key}"


LANDERS = {"internal": _land_internal, "azure": _land_azure, "aws": _land_aws}


def snowflake_call(task_id: str, call: str) -> SQLExecuteQueryOperator:
    return SQLExecuteQueryOperator(
        task_id=task_id,
        conn_id=SNOWFLAKE_CONN,
        sql=[QUERY_TAG, call],
        parameters={"hour": HOUR, "run_id": "{{ run_id }}"},
        autocommit=True,
        pool="snowflake_p10",
        show_return_value_in_logs=True,
    )


@dag(
    dag_id="p10_gharchive_hourly",
    schedule=CronDataIntervalTimetable("0 * * * *", timezone="UTC"),
    start_date=START,
    catchup=False,
    max_active_runs=4,
    default_args={"owner": "p10", "retries": 2, "retry_delay": timedelta(minutes=5), "retry_exponential_backoff": True},
    params={"force_reland": Param(False, type="boolean", description="Download the hour again even if the landing file exists")},
    tags=["p10", "snowflake", "gharchive"],
    doc_md=__doc__,
)
def p10_gharchive_hourly():
    @task.sensor(poke_interval=300, timeout=3 * 3600, mode="reschedule", pool="gharchive_http")
    def wait_for_hour(data_interval_start=None) -> bool:
        url = gh.source_url(data_interval_start)
        response = requests.head(url, headers={"User-Agent": gh.USER_AGENT}, timeout=30, allow_redirects=True)
        return gh.is_published(response.status_code)

    @task(pool="gharchive_http")
    def land_hour(data_interval_start=None, params=None) -> str:
        if LANDING not in LANDERS:
            raise ValueError(f"P10_LANDING must be one of {sorted(LANDERS)}, got {LANDING!r}")
        return LANDERS[LANDING](gh.normalize_hour(data_interval_start), bool(params["force_reland"]))

    load_raw = snowflake_call("load_raw", "CALL P10_GH.OPS.LOAD_HOUR(%(hour)s::TIMESTAMP_NTZ, %(run_id)s)")
    build_stg = snowflake_call("build_stg", "CALL P10_GH.OPS.BUILD_HOUR(%(hour)s::TIMESTAMP_NTZ, %(run_id)s)")

    check_hour = SQLCheckOperator(
        task_id="check_hour",
        conn_id=SNOWFLAKE_CONN,
        pool="snowflake_p10",
        sql=f"""
            SELECT RAW_ROWS > 0,
                   BUILT_AT IS NOT NULL,
                   STG_ROWS BETWEEN RAW_ROWS * 0.999 AND RAW_ROWS,
                   OUTSIDE_HOUR <= STG_ROWS * 0.001
            FROM P10_GH.OPS.HOUR_LOG
            WHERE EVENT_HOUR = '{HOUR}'::TIMESTAMP_NTZ
        """,
    )

    wait_for_hour() >> land_hour() >> load_raw >> build_stg >> check_hour


p10_gharchive_hourly()
