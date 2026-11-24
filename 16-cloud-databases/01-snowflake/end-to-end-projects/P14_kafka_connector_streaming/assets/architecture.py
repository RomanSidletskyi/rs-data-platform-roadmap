"""P14 target architecture, local lab and managed variants: python architecture.py (needs Graphviz)."""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "_shared" / "diagrams"))

from diagrams import Cluster, Diagram, Edge
from diagrams.generic.database import SQL
from diagrams.onprem.client import Users
from diagrams.onprem.container import Docker
from diagrams.onprem.network import Internet
from diagrams.onprem.queue import Kafka
from diagrams.programming.language import Python
from diagrams.saas.analytics import Snowflake

import style

OUT = Path(__file__).resolve().parent


def render(variant: str) -> None:
    title = "P14 Kafka connector with Snowpipe Streaming (" + ("local lab" if variant == "local" else "Confluent Cloud") + ")"
    with Diagram(
        title,
        filename=str(OUT / f"architecture_{variant}"),
        outformat="png",
        show=False,
        direction="LR",
        graph_attr=style.GRAPH,
        node_attr=style.NODE,
        edge_attr=style.EDGE,
    ):
        with Cluster("Source", graph_attr=style.SOURCE):
            wiki = Internet("Wikimedia\nEventStreams")

        with Cluster("Producer", graph_attr=style.PRODUCER):
            producer = Python("wiki_to_kafka\nacks=all, idempotent")

        label = "Docker: Kafka lab" if variant == "local" else "Confluent Cloud"
        with Cluster(label, graph_attr=style.AWS if variant == "managed" else style.AZURE):
            topic = Kafka("wiki.recentchange\n3 partitions")
            dlq = Kafka("DLQ topic")
            connect = Docker("Kafka Connect\nSnowflake sink") if variant == "local" else Kafka("Managed\nSnowflake sink")

        with Cluster("Snowflake  P14_WIKI_STREAM", graph_attr=style.SNOWFLAKE):
            stream_api = Snowflake("Snowpipe Streaming\nchannels + offset tokens")
            raw = SQL("RAW\nRECORD_CONTENT\nRECORD_METADATA")
            stg = SQL("STG\none row per event")
            mart = SQL("MART\ndynamic table\n+ live view")
            ops = SQL("OPS\noffset integrity\nlatency, alert")

        with Cluster("Consumers", graph_attr=style.CONSUMERS):
            users = Users("Ops team\nlive dashboard")

        wiki >> Edge(label="SSE") >> producer >> Edge(label="key wiki:title") >> topic
        topic >> connect >> Edge(label="rows") >> stream_api >> raw
        connect >> Edge(label="bad records", style="dashed") >> dlq
        raw >> Edge(label="stream + task\nMERGE") >> stg >> Edge(label="lag 5 min") >> mart >> users
        raw >> Edge(label="live view", style="dashed") >> mart
        raw >> Edge(style="dotted", constraint="false") >> ops
        stg >> Edge(style="dotted") >> ops
        ops >> Edge(style="dotted") >> users


if __name__ == "__main__":
    for target in ("local", "managed"):
        render(target)
