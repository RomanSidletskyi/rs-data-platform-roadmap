"""Shared look for end-to-end project architecture diagrams rendered with the `diagrams` library."""

GRAPH = {
    "fontname": "Helvetica",
    "fontsize": "22",
    "labelloc": "t",
    "bgcolor": "white",
    "pad": "0.5",
    "nodesep": "0.8",
    "ranksep": "1.1",
    "splines": "spline",
}

NODE = {
    "fontname": "Helvetica",
    "fontsize": "12",
}

EDGE = {
    "color": "#5b6b7a",
    "penwidth": "1.6",
    "fontname": "Helvetica",
    "fontsize": "11",
    "fontcolor": "#33414e",
}


def cluster(fill: str) -> dict:
    return {
        "bgcolor": fill,
        "pencolor": "#c9d3dd",
        "style": "rounded",
        "fontname": "Helvetica Bold",
        "fontsize": "14",
        "margin": "18",
    }


SOURCE = cluster("#fff7e6")
PRODUCER = cluster("#f4f0fb")
AZURE = cluster("#eaf3fb")
AWS = cluster("#fdf1e6")
SNOWFLAKE = cluster("#e6f6fc")
CONSUMERS = cluster("#eef8ee")
