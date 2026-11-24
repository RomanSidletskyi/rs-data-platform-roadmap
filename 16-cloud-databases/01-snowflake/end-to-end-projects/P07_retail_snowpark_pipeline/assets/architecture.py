"""P07 target architecture: python architecture.py (needs Graphviz)."""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "_shared" / "diagrams"))

from diagrams import Cluster, Diagram, Edge
from diagrams.generic.database import SQL
from diagrams.onprem.client import Users
from diagrams.onprem.network import Internet
from diagrams.programming.flowchart import Action
from diagrams.programming.language import Python
from diagrams.saas.analytics import Snowflake

import style

OUT = Path(__file__).resolve().parent

with Diagram(
    "P07 Retail Snowpark pipeline",
    filename=str(OUT / "architecture"),
    outformat="png",
    show=False,
    direction="LR",
    graph_attr=style.GRAPH,
    node_attr=style.NODE,
    edge_attr=style.EDGE,
):
    with Cluster("Source", graph_attr=style.SOURCE):
        uci = Internet("UCI Online Retail II\nExcel, 1.07M lines")

    with Cluster("Your machine", graph_attr=style.PRODUCER):
        prep = Python("prepare_months\nmonthly CSV")
        tests = Python("pytest\nSnowpark local testing")
        client = Python("run_local.py\nFile API upload,\nclient runs")

    with Cluster("Snowflake  P07_RETAIL", graph_attr=style.SNOWFLAKE):
        stage = Snowflake("RETAIL_STAGE\nmonth=YYYY-MM/")
        code = Snowflake("CODE_STAGE\nretail_pipeline.zip")
        raw = SQL("RAW.ONLINE_RETAIL")
        with Cluster("OPS"):
            task = Action("MONTHLY_RUN task\nCOPY, then CALL")
            proc = Python("SP_PROCESS_NEW_MONTHS\nSnowpark DataFrames")
        stg = SQL("STG\nSALES_LINE,\nREJECTED_LINE")
        mart = SQL("MART\nDAILY_SALES, PRODUCT_MONTHLY,\nCUSTOMER_RFM")

    users = Users("Merchandising,\nCRM")

    uci >> prep >> client >> Edge(label="session.file.put") >> stage
    tests >> Edge(style="dashed", label="tested code, package.sh") >> code
    stage >> Edge(label="COPY") >> raw
    task >> proc
    code >> Edge(label="IMPORTS") >> proc
    raw >> proc >> stg >> mart
    client >> Edge(style="dotted", label="or run from laptop") >> proc
    mart >> users
