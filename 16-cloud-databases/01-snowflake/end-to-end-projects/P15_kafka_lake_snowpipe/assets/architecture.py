"""P15 target architecture, Azure and AWS variants: python architecture.py (needs Graphviz)."""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "_shared" / "diagrams"))

from diagrams import Cluster, Diagram, Edge
from diagrams.aws.integration import SQS
from diagrams.aws.storage import S3
from diagrams.azure.integration import EventGridSubscriptions
from diagrams.azure.storage import DataLakeStorage, QueuesStorage
from diagrams.generic.database import SQL
from diagrams.onprem.analytics import Spark, Trino
from diagrams.onprem.client import Users
from diagrams.onprem.network import Internet
from diagrams.onprem.queue import Kafka
from diagrams.programming.language import Python
from diagrams.saas.analytics import Snowflake

import style

OUT = Path(__file__).resolve().parent


def render(cloud: str) -> None:
    title = f"P15 Kafka to lake to Snowpipe ({'Azure' if cloud == 'azure' else 'AWS'})"
    with Diagram(
        title,
        filename=str(OUT / f"architecture_{cloud}"),
        outformat="png",
        show=False,
        direction="LR",
        graph_attr=style.GRAPH,
        node_attr=style.NODE,
        edge_attr=style.EDGE,
    ):
        with Cluster("Source", graph_attr=style.SOURCE):
            wiki = Internet("Wikimedia\nEventStreams")

        with Cluster("Kafka lab", graph_attr=style.PRODUCER):
            producer = Python("wiki_to_kafka")
            topic = Kafka("wiki.recentchange")
            writer = Python("lake writer\nfiles named by offsets\ncommit after write")

        if cloud == "azure":
            with Cluster("Azure", graph_attr=style.AZURE):
                lake = DataLakeStorage("ADLS Gen2\nkafka/topic=/dt=/hour=/partition=")
                events = EventGridSubscriptions("Event Grid")
                queue = QueuesStorage("Storage Queue")
            lake >> events >> queue
        else:
            with Cluster("AWS", graph_attr=style.AWS):
                lake = S3("S3\nkafka/topic=/dt=/hour=/partition=")
                queue = SQS("SQS")
            lake >> Edge(label="ObjectCreated") >> queue

        with Cluster("Other engines", graph_attr=style.CONSUMERS):
            spark = Spark("Spark / Databricks")
            trino = Trino("Trino")

        with Cluster("Snowflake  P15_WIKI_LAKE", graph_attr=style.SNOWFLAKE):
            pipe = Snowflake("Snowpipe\nauto-ingest")
            raw = SQL("RAW\nPAYLOAD + Kafka\ncoordinates")
            stg = SQL("STG\none row per event")
            mart = SQL("MART\ndynamic table")
            ops = SQL("OPS\noffset integrity\nfile stats")

        users = Users("Ops team\ndashboard")

        wiki >> producer >> topic >> writer >> Edge(label="NDJSON.gz") >> lake
        queue >> Edge(label="notify") >> pipe
        lake >> Edge(label="read", style="dashed") >> pipe
        lake >> Edge(label="same files", style="dashed") >> spark
        lake >> Edge(style="dashed") >> trino
        pipe >> raw >> Edge(label="MERGE") >> stg >> mart >> users
        raw >> Edge(style="dotted", constraint="false") >> ops
        stg >> Edge(style="dotted") >> ops


if __name__ == "__main__":
    for target in ("azure", "aws"):
        render(target)
