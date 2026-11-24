"""P08 target architecture, Azure and AWS variants: python architecture.py (needs Graphviz)."""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "_shared" / "diagrams"))

from diagrams import Cluster, Diagram, Edge
from diagrams.aws.integration import SQS
from diagrams.aws.storage import S3
from diagrams.azure.integration import EventGridSubscriptions
from diagrams.azure.storage import DataLakeStorage, QueuesStorage
from diagrams.generic.database import SQL
from diagrams.onprem.client import Users
from diagrams.onprem.network import Internet
from diagrams.programming.flowchart import Action
from diagrams.programming.language import Python
from diagrams.saas.analytics import Snowflake

import style

OUT = Path(__file__).resolve().parent


def render(cloud: str) -> None:
    azure = cloud == "azure"
    with Diagram(
        f"P08 Bluesky social feed at volume ({'Azure' if azure else 'AWS'})",
        filename=str(OUT / f"architecture_{cloud}"),
        outformat="png",
        show=False,
        direction="LR",
        graph_attr=style.GRAPH,
        node_attr=style.NODE,
        edge_attr=style.EDGE,
    ):
        with Cluster("Source", graph_attr=style.SOURCE):
            jet = Internet("Bluesky Jetstream\n~500 events/s")

        with Cluster("Producer", graph_attr=style.PRODUCER):
            producer = Python("jetstream_producer\nbatch per collection,\ncursor checkpoint")

        with Cluster("Azure" if azure else "AWS", graph_attr=style.AZURE if azure else style.AWS):
            if azure:
                lake = DataLakeStorage("landing/bsky/\ncollection=*/dt=*/hour=*\nlifecycle: cool 7d, delete 30d")
                events = EventGridSubscriptions("Event Grid\none subscription")
                queue = QueuesStorage("Storage Queue\none for all pipes")
                lake >> events >> queue
            else:
                lake = S3("s3 landing/bsky/")
                queue = SQS("Snowflake-managed SQS\nshared by all pipes")
                lake >> queue

        with Cluster("Snowflake  P08_SOCIAL", graph_attr=style.SNOWFLAKE):
            pipes = Snowflake("4 pipes\npost, like, repost, follow")
            raw = SQL("RAW\n4 transient tables\npurged after 3 days")
            task = Action("PIPE.LOAD_EVENTS\n4 streams, one INSERT,\n2-hour dedup window")
            stg = SQL("STG.EVENT")
            mart = SQL("MART dynamic tables\nresolve deletes,\nengagement, 30 min lag")
            ops = SQL("OPS\nfiles, latency, cost")

        users = Users("Trend dashboard")

        jet >> producer >> Edge(label="gzip NDJSON") >> lake
        queue >> pipes >> raw >> task >> stg >> mart >> users
        pipes >> Edge(style="dashed") >> ops
        stg >> Edge(style="dashed") >> ops


render("azure")
render("aws")
