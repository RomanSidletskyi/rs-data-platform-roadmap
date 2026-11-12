"""P09 target architecture: python architecture.py (needs Graphviz)."""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "_shared" / "diagrams"))

from diagrams import Cluster, Diagram, Edge
from diagrams.generic.database import SQL
from diagrams.onprem.ci import GithubActions
from diagrams.onprem.client import Users
from diagrams.onprem.network import Internet
from diagrams.onprem.vcs import Github
from diagrams.programming.flowchart import Action
from diagrams.programming.language import Python
from diagrams.saas.analytics import Snowflake

import style

OUT = Path(__file__).resolve().parent

with Diagram(
    "P09 Crypto and market data modelled with dbt",
    filename=str(OUT / "architecture"),
    outformat="png",
    show=False,
    direction="LR",
    graph_attr=style.GRAPH,
    node_attr=style.NODE,
    edge_attr=style.EDGE,
):
    with Cluster("Sources", graph_attr=style.SOURCE):
        coinbase = Internet("Coinbase Exchange\nhourly candles\nBTC, ETH, SOL")
        fred = Internet("FRED CSV\nSP500, NASDAQ,\ndollar index")

    with Cluster("GitHub", graph_attr=style.PRODUCER):
        repo = Github("dbt project\nmodels, tests, contracts")
        pr = GithubActions("pull request\ndbt build in CI_PR_<n>\nthen drop schemas")
        hourly = GithubActions("hourly schedule\nextract, PUT, COPY,\ndbt build, freshness")
        extract = Python("extract_markets.py\noverlapping windows")

    with Cluster("Snowflake  P09_MARKETS", graph_attr=style.SNOWFLAKE):
        stage = Snowflake("RAW.MARKET_STAGE\ninternal stage")
        raw = SQL("RAW\nresponses and CSV lines\nas delivered")
        staging = SQL("STAGING views\ntyped, deduplicated")
        inter = SQL("INTERMEDIATE\ndaily rollups,\none price table")
        marts = SQL("MARTS\nincremental hourly fact,\nvolatility, correlation")
        ci = SQL("CI_PR_<n>_*\nDEV_<user>_*\nisolated copies")
        alerts = Action("OPS alerts\nstale prices,\nlarge move")

    users = Users("Dashboard\nand email")

    coinbase >> extract
    fred >> extract
    hourly >> extract >> Edge(label="PUT") >> stage >> Edge(label="COPY") >> raw
    raw >> staging >> inter >> marts >> users
    repo >> pr >> Edge(style="dashed") >> ci
    repo >> Edge(label="dbt build --target prod") >> hourly
    marts >> alerts >> Edge(style="dashed") >> users
