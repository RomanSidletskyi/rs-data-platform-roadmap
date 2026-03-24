import argparse
import json
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("--start", required=True)
parser.add_argument("--end", required=True)
parser.add_argument("--orders-path", required=True)
parser.add_argument("--enrichment-path", required=True)
parser.add_argument("--output", required=True)
parser.add_argument("--executor-memory", required=False)
parser.add_argument("--app-name", required=False)
args = parser.parse_args()

payload = {
    "interval_start": args.start,
    "interval_end": args.end,
    "orders_path": args.orders_path,
    "enrichment_path": args.enrichment_path,
    "output": args.output,
    "executor_memory": args.executor_memory,
    "app_name": args.app_name,
    "status": "ok"
}

print("Pseudo Spark-style job running with payload:")
print(json.dumps(payload, indent=2))

Path("/tmp/orders_spark_job_output.json").write_text(json.dumps(payload, indent=2))
print("Pseudo Spark-style processing completed.")
