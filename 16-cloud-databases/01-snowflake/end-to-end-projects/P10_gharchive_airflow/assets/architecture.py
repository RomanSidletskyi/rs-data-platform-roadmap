"""P10 target architecture, Azure and AWS variants: python architecture.py (needs Graphviz)."""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "_shared" / "diagrams"))

from diagrams import Cluster, Diagram, Edge
from diagrams.aws.storage import S3
from diagrams.azure.storage import BlobStorage
from diagrams.generic.database import SQL
from diagrams.onprem.client import Users
from diagrams.onprem.network import Internet
from diagrams.onprem.workflow import Airflow
from diagrams.programming.flowchart import Action
from diagrams.saas.analytics import Snowflake

import style

OUT = Path(__file__).resolve().parent


def render(cloud: str) -> None:
    azure = cloud == "azure"
    with Diagram(
        f"P10 GH Archive orchestrated by Airflow ({'Azure' if azure else 'AWS'})",
        filename=str(OUT / f"architecture_{cloud}"),
        outformat="png",
        show=False,
        direction="LR",
        graph_attr=style.GRAPH,
        node_attr=style.NODE,
        edge_attr=style.EDGE,
    ):
        with Cluster("Source", graph_attr=style.SOURCE):
            gharchive = Internet("GH Archive\none gzip file per hour")

        with Cluster("Airflow 3 (Docker, LocalExecutor)", graph_attr=style.PRODUCER):
            hourly = Airflow("p10_gharchive_hourly\nsensor, land, load,\nbuild, check")
            daily = Airflow("p10_gharchive_daily\n24 hours ready, marts,\narchive, verify, purge")

        with Cluster("Azure storage account" if azure else "S3 bucket", graph_attr=style.AZURE if azure else style.AWS):
            if azure:
                landing = BlobStorage("landing/gharchive/dt=*/\ndelete after 14 days")
                archive = BlobStorage("archive/events/dt=*/\nParquet, cool 30d, cold 90d")
            else:
                landing = S3("landing/gharchive/dt=*/\nexpire after 14 days")
                archive = S3("archive/events/dt=*/\nParquet, IA 30d, Glacier IR 90d")

        with Cluster("Snowflake  P10_GH", graph_attr=style.SNOWFLAKE):
            procs = Action("OPS procedures\nLOAD_HOUR, BUILD_HOUR,\nBUILD_DAY, ARCHIVE_DAY,\nPURGE_HOT")
            raw = Snowflake("RAW.GH_EVENT_RAW\ntransient, per hour")
            stg = SQL("STG.GH_EVENT\nhot window 30 days")
            mart = SQL("MART\nrepo and event-type\ndaily facts")
            ops = SQL("OPS\nhour and day logs,\nsource drift")
            ext = SQL("ARCHIVE.GH_EVENT_ARCHIVE\nexternal table")

        users = Users("Analysts")

        gharchive >> Edge(label="HTTPS") >> hourly >> Edge(label="upload") >> landing
        hourly >> Edge(label="CALL", style="dashed") >> procs
        daily >> Edge(label="CALL", style="dashed") >> procs
        landing >> Edge(label="COPY FORCE") >> raw >> stg >> mart >> users
        stg >> Edge(label="unload Parquet") >> archive >> ext >> users
        procs >> Edge(style="dashed") >> ops


render("azure")
render("aws")
