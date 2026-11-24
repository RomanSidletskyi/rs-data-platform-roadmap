"""P04 target architecture, Azure and AWS variants: python architecture.py (needs Graphviz)."""

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
from diagrams.programming.language import Python
from diagrams.saas.analytics import Snowflake

import style

OUT = Path(__file__).resolve().parent


def render(cloud: str) -> None:
    title = f"P04 Wikimedia near-real-time DWH ({'Azure' if cloud == 'azure' else 'AWS'})"
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

        with Cluster("Producer", graph_attr=style.PRODUCER):
            producer = Python("micro-batch\nproducer")

        if cloud == "azure":
            with Cluster("Azure", graph_attr=style.AZURE):
                lake = DataLakeStorage("ADLS Gen2\nlanding/")
                events = EventGridSubscriptions("Event Grid\nBlobCreated")
                queue = QueuesStorage("Storage\nQueue")
            lake >> events >> queue
        else:
            with Cluster("AWS", graph_attr=style.AWS):
                lake = S3("S3\nlanding/")
                queue = SQS("SQS\n(Snowflake-managed)")
            lake >> Edge(label="ObjectCreated") >> queue

        with Cluster("Snowflake  P04_WIKI_RT", graph_attr=style.SNOWFLAKE):
            pipe = Snowflake("Snowpipe\nauto-ingest")
            raw = SQL("RAW\nVARIANT + file metadata")
            stg = SQL("STG\none row per event")
            mart = SQL("MART\ndynamic table")
            ops = SQL("OPS\nreconciliation\nfreshness, alert")

        with Cluster("Consumers", graph_attr=style.CONSUMERS):
            users = Users("Ops team\nSnowsight dashboard")

        wiki >> Edge(label="SSE") >> producer
        producer >> Edge(label="NDJSON.gz\n+ manifest") >> lake
        queue >> Edge(label="notify") >> pipe
        lake >> Edge(label="read file", style="dashed") >> pipe
        pipe >> raw >> Edge(label="stream + task\nMERGE") >> stg >> Edge(label="lag 5 min") >> mart >> users
        # Only raw -> ops skips layout ranking, so OPS sits beside MART instead of bending the main row.
        raw >> Edge(style="dotted", constraint="false") >> ops
        stg >> Edge(style="dotted") >> ops
        ops >> Edge(style="dotted") >> users


if __name__ == "__main__":
    for target in ("azure", "aws"):
        render(target)
