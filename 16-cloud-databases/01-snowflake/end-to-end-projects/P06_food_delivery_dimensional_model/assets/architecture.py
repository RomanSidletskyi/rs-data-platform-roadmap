"""P06 target architecture: python architecture.py (needs Graphviz)."""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "_shared" / "diagrams"))

from diagrams import Cluster, Diagram, Edge
from diagrams.generic.database import SQL
from diagrams.onprem.client import Users
from diagrams.programming.flowchart import Action
from diagrams.programming.language import Bash, Python
from diagrams.saas.analytics import Snowflake

import style

OUT = Path(__file__).resolve().parent

with Diagram(
    "P06 Food delivery dimensional model",
    filename=str(OUT / "architecture"),
    outformat="png",
    show=False,
    direction="LR",
    graph_attr=style.GRAPH,
    node_attr=style.NODE,
    edge_attr=style.EDGE,
):
    with Cluster("Your machine", graph_attr=style.PRODUCER):
        gen = Python("food_oltp.py\ndaily delta extracts")
        upload = Bash("upload_day.sh\nPUT")

    with Cluster("Snowflake  P06_FOOD", graph_attr=style.SNOWFLAKE):
        stage = Snowflake("Internal stage\nday=YYYY-MM-DD/")
        raw = SQL("RAW\n6 tables, every row\nappend-only streams")

        with Cluster("Task graph in schema PIPE"):
            load = Action("LOAD_RAW\nCOPY by column name")
            build = Action("BUILD_CORE\nSP_BUILD_CORE,\none transaction")
            fin = Action("FINALIZE_RUN\nmodel checks")

        with Cluster("CORE: star schema"):
            dims = SQL("Dimensions\nSCD2 customer, restaurant\nSCD1 menu item, courier")
            facts = SQL("Facts\nFACT_ORDER accumulating\nFACT_ORDER_ITEM")

        mart = SQL("MART\nviews, DT_DAILY_KPI")

    users = Users("Ops, finance,\nmarketing")

    gen >> upload >> Edge(label="PUT") >> stage
    stage >> load >> raw
    load >> build
    raw >> Edge(label="streams") >> build
    build >> dims
    build >> facts
    load >> Edge(style="dotted", label="finalizer") >> fin
    dims >> mart
    facts >> mart
    mart >> users
