from __future__ import annotations

import json
import sys
from pathlib import Path

from check_orders_delta_contract import check_file
from preview_repair_window import build_daily_summary


def load_config(path: str) -> dict[str, object]:
    config = {
        "tables": {},
        "allowed_statuses": [],
        "required_fields": [],
        "repair": {},
    }
    section = ""
    subsection = ""
    for raw_line in Path(path).read_text(encoding="utf-8").splitlines():
        line = raw_line.rstrip()
        stripped = line.strip()
        if not stripped:
            continue
        if not line.startswith(" ") and stripped.endswith(":"):
            section = stripped[:-1]
            subsection = ""
            continue
        if line.startswith("  ") and stripped.endswith(":"):
            subsection = stripped[:-1]
            continue
        if stripped.startswith("- "):
            value = stripped[2:].strip()
            if section == "validation" and subsection == "required_fields":
                config["required_fields"].append(value)
            elif section == "validation" and subsection == "allowed_statuses":
                config["allowed_statuses"].append(value)
            continue
        key, value = [part.strip() for part in stripped.split(":", 1)]
        if section == "tables":
            config["tables"][key] = value
        elif section == "repair":
            config["repair"][key] = int(value) if value.isdigit() else value
    return config


def run_pipeline(config_path: str, data_path: str, business_date: str) -> dict[str, object]:
    config = load_config(config_path)
    findings = check_file(data_path)
    return {
        "tables": config["tables"],
        "repair": config["repair"],
        "required_fields": config["required_fields"],
        "allowed_statuses": config["allowed_statuses"],
        "contract_check_passed": not findings,
        "contract_findings": findings,
        "gold_preview": build_daily_summary(data_path, business_date),
    }


def emit_result(result: dict[str, object], output_path: str | None) -> None:
    rendered = json.dumps(result, indent=2) + "\n"
    if output_path:
        output_file = Path(output_path)
        output_file.parent.mkdir(parents=True, exist_ok=True)
        output_file.write_text(rendered, encoding="utf-8")
    sys.stdout.write(rendered)


def main() -> None:
    if len(sys.argv) not in {4, 5}:
        raise SystemExit(
            "Usage: python3 src/run_local_batch_pipeline.py <config-path> <jsonl-path> <business-date> [output-path]"
        )
    result = run_pipeline(sys.argv[1], sys.argv[2], sys.argv[3])
    output_path = sys.argv[4] if len(sys.argv) == 5 else None
    emit_result(result, output_path)


if __name__ == "__main__":
    main()
