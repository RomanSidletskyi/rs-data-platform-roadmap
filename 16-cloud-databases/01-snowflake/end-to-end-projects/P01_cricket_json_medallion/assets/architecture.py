"""P01 target architecture: python architecture.py (needs Graphviz)."""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "_shared" / "diagrams"))

from diagrams import Cluster, Diagram, Edge
from diagrams.generic.database import SQL
from diagrams.onprem.client import Users
from diagrams.onprem.network import Internet
from diagrams.programming.language import Bash, Python
from diagrams.saas.analytics import Snowflake

import style

OUT = Path(__file__).resolve().parent

with Diagram(
    "P01 Cricket JSON medallion",
    filename=str(OUT / "architecture"),
    outformat="png",
    show=False,
    direction="LR",
    graph_attr=style.GRAPH,
    node_attr=style.NODE,
    edge_attr=style.EDGE,
):
    with Cluster("Source", graph_attr=style.SOURCE):
        cricsheet = Internet("Cricsheet\nODI JSON archive")

    with Cluster("Your machine", graph_attr=style.PRODUCER):
        prepare = Python("prepare_batches\nyear=YYYY folders")
        upload = Bash("upload_batch.sh\nPUT, auto-compress")

    with Cluster("Snowflake  P01_CRICKET", graph_attr=style.SNOWFLAKE):
        stage = Snowflake("Internal stage\n+ directory table")
        with Cluster("Task graph (serverless)", graph_attr=style.cluster("#d8eef7")):
            load = Snowflake("LOAD_RAW\nCOPY INTO")
            silver = Snowflake("BUILD_SILVER\nstream + FLATTEN")
            gold = Snowflake("BUILD_GOLD\nfacts + dims")
        raw = SQL("Bronze RAW\nmatch VARIANT")
        stg = SQL("Silver STG\nmatch, player,\ndelivery")
        mart = SQL("Gold MART\nbatting, bowling,\nteam results")

    with Cluster("Consumers", graph_attr=style.CONSUMERS):
        users = Users("Snowsight\ndashboard")

    cricsheet >> Edge(label="zip") >> prepare >> upload >> Edge(label="PUT") >> stage
    stage >> load >> raw
    load >> Edge(style="dashed") >> silver >> Edge(style="dashed") >> gold
    raw >> Edge(label="stream") >> silver >> stg
    gold >> mart
    stg >> Edge(style="dotted") >> gold
    mart >> users
