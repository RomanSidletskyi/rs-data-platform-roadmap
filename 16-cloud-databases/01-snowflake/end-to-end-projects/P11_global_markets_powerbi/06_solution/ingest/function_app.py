"""Azure Functions entry point (Python v2 programming model). Deployed by azure/02_deploy_function.sh."""

import json
import logging
import os

import azure.functions as func

from markets_ingest.landing import AzureBlobWriter
from markets_ingest.run import Config, run_all

app = func.FunctionApp()


# NCRONTAB with seconds: 06:00 UTC daily. WFP publishes monthly, ECB monthly averages, World Bank yearly.
@app.timer_trigger(schedule="0 0 6 * * *", arg_name="timer", run_on_startup=False, use_monitor=True)
def fetch_global_markets(timer: func.TimerRequest) -> None:
    writer = AzureBlobWriter(os.environ["P11_LANDING_ACCOUNT_URL"], os.environ.get("P11_LANDING_CONTAINER", "landing"))
    summary = run_all(writer, Config.from_env(os.environ))
    logging.info("p11 ingest summary %s", json.dumps(summary))
    if summary["errors"]:
        # A failed invocation shows up in Application Insights and in the function's failure count.
        raise RuntimeError(f"{len(summary['errors'])} source(s) failed: {summary['errors']}")
