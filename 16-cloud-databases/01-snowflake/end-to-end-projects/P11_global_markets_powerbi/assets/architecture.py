"""P11 target architecture, Azure and AWS variants: python architecture.py (needs Graphviz)."""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "_shared" / "diagrams"))

from diagrams import Cluster, Diagram, Edge
from diagrams.aws.compute import Lambda
from diagrams.aws.integration import Eventbridge, SQS
from diagrams.aws.storage import S3
from diagrams.azure.compute import FunctionApps
from diagrams.azure.integration import EventGridSubscriptions
from diagrams.azure.storage import BlobStorage, QueuesStorage
from diagrams.generic.database import SQL
from diagrams.onprem.client import Users
from diagrams.onprem.network import Internet
from diagrams.programming.language import Python
from diagrams.saas.analytics import Snowflake

import style

OUT = Path(__file__).resolve().parent


def render(cloud: str) -> None:
    azure = cloud == "azure"
    with Diagram(
        f"P11 Global markets to Power BI ({'Azure' if azure else 'AWS'})",
        filename=str(OUT / f"architecture_{cloud}"),
        outformat="png",
        show=False,
        direction="LR",
        graph_attr=style.GRAPH,
        node_attr=style.NODE,
        edge_attr=style.EDGE,
    ):
        with Cluster("Public sources", graph_attr=style.SOURCE):
            wfp = Internet("WFP food prices\n(HDX, monthly)")
            ecb = Internet("ECB exchange rates\n(monthly averages)")
            wb = Internet("World Bank\nindicators (yearly)")

        with Cluster("Azure" if azure else "AWS", graph_attr=style.AZURE if azure else style.AWS):
            if azure:
                function = FunctionApps("Function (Flex Consumption)\ntimer 06:00 UTC\nmanaged identity")
                landing = BlobStorage("landing/markets/\nversioned file names")
                events = EventGridSubscriptions("Event Grid\nBlobCreated")
                queue = QueuesStorage("Storage Queue\none for three pipes")
            else:
                schedule = Eventbridge("EventBridge Scheduler\n06:00 UTC")
                function = Lambda("Lambda\nexecution role")
                landing = S3("landing/markets/\nconditional writes")
                queue = SQS("Snowflake-managed SQS\none for three pipes")

        with Cluster("Snowflake  P11_MARKETS", graph_attr=style.SNOWFLAKE):
            pipes = Snowflake("3 pipes\nWFP, ECB, World Bank")
            raw = SQL("RAW\nevery file version")
            snowpark = Python("Snowpark procedure\nunits, FX precedence,\nbuild beside and swap")
            core = SQL("CORE\nprices per kg in\nlocal, USD, EUR")
            mart = SQL("MART star views")
            sem = SQL("SEM.FOOD_PRICES\nsemantic view")

        with Cluster("Consumers", graph_attr=style.CONSUMERS):
            powerbi = Users("Power BI\nImport, key pair,\nP11_BI_WH")
            analysts = Users("SQL, notebooks,\nCortex Analyst")

        for source in (wfp, ecb, wb):
            source >> Edge(style="dashed") >> function
        if not azure:
            schedule >> function
        function >> Edge(label="create if absent") >> landing
        if azure:
            landing >> events >> queue >> pipes
        else:
            landing >> Edge(label="event") >> queue >> pipes
        pipes >> raw >> snowpark >> core >> mart >> powerbi
        mart >> sem >> analysts


render("azure")
render("aws")
