import argparse
import json


def inspect(job_path: str, contract_path: str):
    findings = []
    with open(job_path, "r", encoding="utf-8") as handle:
        job = json.load(handle)
    with open(contract_path, "r", encoding="utf-8") as handle:
        contract = json.load(handle)

    if len(job.get("tasks", [])) != 2:
        findings.append("expected two serving tasks")
    if "warehouse_name" not in job:
        findings.append("missing warehouse_name in job definition")
    if contract.get("grain") != "one_row_per_order":
        findings.append("unexpected contract grain")
    if contract.get("freshness") != "every_15_minutes":
        findings.append("unexpected freshness contract")
    return findings


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("job_path")
    parser.add_argument("contract_path")
    args = parser.parse_args()
    findings = inspect(args.job_path, args.contract_path)
    if findings:
        print("serving-check=fail")
        for finding in findings:
            print(finding)
    else:
        print("serving-check=pass")


if __name__ == "__main__":
    main()