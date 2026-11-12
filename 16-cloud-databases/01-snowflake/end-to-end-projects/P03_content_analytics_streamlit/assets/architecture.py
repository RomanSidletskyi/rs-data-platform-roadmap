"""P03 target architecture: python architecture.py (needs Graphviz)."""

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
    "P03 Content analytics in Streamlit",
    filename=str(OUT / "architecture"),
    outformat="png",
    show=False,
    direction="LR",
    graph_attr=style.GRAPH,
    node_attr=style.NODE,
    edge_attr=style.EDGE,
):
    with Cluster("Source", graph_attr=style.SOURCE):
        api = Internet("Wikimedia\npageviews API")

    with Cluster("Your machine", graph_attr=style.PRODUCER):
        fetch = Python("fetch_pageviews\ntop lists, totals")
        upload = Bash("upload.sh\nPUT")

    with Cluster("Snowflake  P03_CONTENT", graph_attr=style.SNOWFLAKE):
        with Cluster("Data team: P03_OWNER"):
            stage = Snowflake("Internal stage")
            raw = SQL("RAW\nAPI responses")
            stg = SQL("STG\narticles, totals")
            mart = SQL("MART\nserving tables")
        with Cluster("App team: P03_APP_OWNER"):
            app = Python("Streamlit app\nowner's rights")

    viewers = Users("P03_VIEWER\nusage on app only")

    api >> Edge(label="HTTPS") >> fetch >> upload >> Edge(label="PUT") >> stage
    stage >> Edge(label="COPY") >> raw >> Edge(label="FLATTEN") >> stg >> mart
    mart >> Edge(label="SELECT on MART only") >> app
    viewers >> Edge(label="USAGE") >> app
