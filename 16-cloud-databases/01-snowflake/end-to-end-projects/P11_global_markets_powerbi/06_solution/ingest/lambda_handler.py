"""AWS Lambda entry point. Deployed by aws/02_deploy_lambda.sh, invoked daily by EventBridge Scheduler."""

import json
import logging
import os

from markets_ingest.landing import S3Writer
from markets_ingest.run import Config, run_all

logging.getLogger().setLevel(logging.INFO)


def handler(event, context):
    writer = S3Writer(os.environ["P11_BUCKET"], os.environ.get("P11_PREFIX", "landing/"))
    summary = run_all(writer, Config.from_env(os.environ))
    logging.info("p11 ingest summary %s", json.dumps(summary))
    if summary["errors"]:
        raise RuntimeError(f"{len(summary['errors'])} source(s) failed: {summary['errors']}")
    return {"landed": len(summary["landed"]), "unchanged": len(summary["unchanged"])}
