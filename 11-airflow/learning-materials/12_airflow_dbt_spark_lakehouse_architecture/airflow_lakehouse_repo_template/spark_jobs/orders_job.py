import argparse
import json
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("--start", required=True)
parser.add_argument("--end", required=True)
parser.add_argument("--output", required=True)
parser.add_argument("--executor-memory", required=False)
parser.add_argument("--app-name", required=False)
args = parser.parse_args()

print(f"Running pseudo Spark job for interval {args.start} -> {args.end}")
print(f"Output path: {args.output}")
print(f"Executor memory: {args.executor_memory}")
print(f"App name: {args.app_name}")

payload = {
    "start": args.start,
    "end": args.end,
    "output": args.output,
    "status": "ok"
}
Path("/tmp/orders_job_output.json").write_text(json.dumps(payload, indent=2))
print("Pseudo Spark job completed.")
