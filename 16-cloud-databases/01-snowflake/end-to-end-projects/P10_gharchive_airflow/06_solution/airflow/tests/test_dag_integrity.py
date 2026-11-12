"""DAG integrity: both DAGs import, use interval timetables, and route every external call through a pool.

Needs Airflow and the providers installed (see ../requirements.txt); no database or connections are touched.
"""

import os
import tempfile
from pathlib import Path

import pytest

DAGS = Path(__file__).resolve().parents[1] / "dags"

# Set before Airflow is imported, so a test run never creates or reads ~/airflow.
os.environ.setdefault("AIRFLOW_HOME", tempfile.mkdtemp(prefix="p10_airflow_home_"))
os.environ.setdefault("AIRFLOW__CORE__LOAD_EXAMPLES", "False")
pytest.importorskip("airflow")


@pytest.fixture(scope="module")
def dagbag():
    from airflow.dag_processing.dagbag import DagBag

    return DagBag(dag_folder=str(DAGS))


def test_no_import_errors(dagbag):
    assert dagbag.import_errors == {}
    assert set(dagbag.dag_ids) == {"p10_gharchive_hourly", "p10_gharchive_daily"}


def test_hourly_shape(dagbag):
    dag = dagbag.dags["p10_gharchive_hourly"]
    assert type(dag.timetable).__name__ == "CronDataIntervalTimetable"
    assert dag.catchup is False and dag.max_active_runs == 4
    assert [t.task_id for t in dag.topological_sort()] == ["wait_for_hour", "land_hour", "load_raw", "build_stg", "check_hour"]
    pools = {t.task_id: t.pool for t in dag.tasks}
    assert pools["wait_for_hour"] == pools["land_hour"] == "gharchive_http"
    assert pools["load_raw"] == pools["build_stg"] == pools["check_hour"] == "snowflake_p10"
    assert dag.get_task("wait_for_hour").mode == "reschedule"


def test_daily_shape(dagbag):
    dag = dagbag.dags["p10_gharchive_daily"]
    assert type(dag.timetable).__name__ == "CronDataIntervalTimetable"
    downstream = {t.task_id: sorted(t.downstream_task_ids) for t in dag.tasks}
    assert downstream["wait_for_24_hours"] == ["build_marts"]
    assert downstream["build_marts"] == ["archive_day", "check_source_drift"]
    assert downstream["archive_day"] == ["purge_hot"]
    assert downstream["check_source_drift"] == []
    assert all(t.pool == "snowflake_p10" for t in dag.tasks)
