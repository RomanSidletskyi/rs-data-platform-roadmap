import argparse
import json


def inspect_job(path: str):
    with open(path, "r", encoding="utf-8") as handle:
        job = json.load(handle)

    findings = []
    task_keys = [task["task_key"] for task in job.get("tasks", [])]
    expected = ["bronze_to_silver", "silver_to_gold", "quality_check"]
    if task_keys != expected:
        findings.append("unexpected task order or task set")

    if not job.get("job_clusters"):
        findings.append("missing job_clusters")

    cluster = job.get("job_clusters", [{}])[0].get("new_cluster", {})
    if "policy_id" not in cluster:
        findings.append("missing compute policy")

    return findings


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("input_path")
    args = parser.parse_args()
    findings = inspect_job(args.input_path)
    if findings:
        print("job-check=fail")
        for finding in findings:
            print(finding)
    else:
        print("job-check=pass")


if __name__ == "__main__":
    main()