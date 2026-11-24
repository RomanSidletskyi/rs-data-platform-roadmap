"""P05 target architecture: python architecture.py (needs Graphviz)."""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "_shared" / "diagrams"))

from diagrams import Cluster, Diagram, Edge
from diagrams.generic.database import SQL
from diagrams.onprem.client import Users
from diagrams.programming.flowchart import Action, Decision
from diagrams.saas.analytics import Snowflake

import style

OUT = Path(__file__).resolve().parent

with Diagram(
    "P05 TPC-H CDC with streams and tasks",
    filename=str(OUT / "architecture"),
    outformat="png",
    show=False,
    direction="LR",
    graph_attr=style.GRAPH,
    node_attr=style.NODE,
    edge_attr=style.EDGE,
):
    with Cluster("Source", graph_attr=style.SOURCE):
        sample = Snowflake("SNOWFLAKE_SAMPLE_DATA\nTPC-H SF1")

    with Cluster("Snowflake  P05_CDC", graph_attr=style.SNOWFLAKE):
        sim = Action("OPS.SIMULATE_DAY\nnew orders, updates,\ncancellations")
        src = SQL("SRC\ncustomer, orders,\nlineitem")
        streams = SQL("Streams\none per consumer")

        with Cluster("Task graph in schema PIPE (serverless)"):
            root = Decision("CDC_ROOT\nWHEN stream has data")
            fin = Action("FINALIZE_RUN\nreconciliation")
            dim = Action("LOAD_DIM_CUSTOMER\nMERGE, SCD1")
            fact = Action("LOAD_FACT_ORDER\naffected keys,\nrecompute")
            daily = Action("LOAD_DAILY_REVENUE\naffected dates")

        with Cluster("Targets"):
            core = SQL("CORE\nDIM_CUSTOMER,\nFACT_ORDER")
            mart = SQL("MART\nDAILY_REVENUE")

        dt = SQL("Dynamic tables\nDT_ORDER, DT_DAILY_REVENUE")

    users = Users("Analysts")

    sample >> Edge(label="1997 snapshot,\nthen one day per call") >> sim >> src
    src >> streams >> root
    root >> Edge(style="dotted", label="finalizer") >> fin
    root >> dim >> core
    root >> fact >> daily >> mart
    fact >> core
    src >> Edge(style="dashed", label="comparison") >> dt
    mart >> users
    dt >> Edge(style="dashed") >> users
