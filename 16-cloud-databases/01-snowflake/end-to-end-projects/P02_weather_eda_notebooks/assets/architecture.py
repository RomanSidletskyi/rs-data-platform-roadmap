"""P02 target architecture: python architecture.py (needs Graphviz)."""

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
    "P02 Weather EDA with notebooks",
    filename=str(OUT / "architecture"),
    outformat="png",
    show=False,
    direction="LR",
    graph_attr=style.GRAPH,
    node_attr=style.NODE,
    edge_attr=style.EDGE,
):
    with Cluster("Source", graph_attr=style.SOURCE):
        api = Internet("Open-Meteo\narchive API")

    with Cluster("Your machine", graph_attr=style.PRODUCER):
        fetch = Python("fetch_weather\ncity x year JSON")
        upload = Bash("upload.sh\nPUT")

    with Cluster("Snowflake  P02_WEATHER", graph_attr=style.SNOWFLAKE):
        stage = Snowflake("Internal stage")
        raw = SQL("RAW\nAPI responses")
        stg = SQL("STG\nhourly rows\n(arrays zipped by index)")
        mart = SQL("MART views\ndaily, climatology,\nanomalies")
        nb = Python("Snowflake Notebook\nweather_eda.ipynb")

    with Cluster("Same notebook elsewhere", graph_attr=style.CONSUMERS):
        local = Python("Jupyter / Deepnote\nSnowpark session")

    users = Users("Findings")

    api >> Edge(label="HTTPS") >> fetch >> upload >> Edge(label="PUT") >> stage
    stage >> Edge(label="COPY") >> raw >> Edge(label="FLATTEN") >> stg >> mart
    mart >> nb >> users
    mart >> Edge(style="dashed") >> local >> users
