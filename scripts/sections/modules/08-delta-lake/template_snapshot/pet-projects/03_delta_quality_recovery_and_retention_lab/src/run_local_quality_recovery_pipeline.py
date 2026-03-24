from __future__ import annotations

import json
import sys
from pathlib import Path

from check_quality_rules import check_file
from recommend_repair_strategy import recommend_strategy


def load_config(path: str) -> dict[str, object]:
    config = {
        "quality": {"require_supported_currency_codes": []},
        "recovery": {},
        "retention": {},
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
            if section == "quality" and subsection == "require_supported_currency_codes":
                config["quality"]["require_supported_currency_codes"].append(value)
            continue
        key, value = [part.strip() for part in stripped.split(":", 1)]
        if value in {"true", "false"}:
            parsed_value: object = value == "true"
        elif value.isdigit():
            parsed_value = int(value)
        else:
            parsed_value = value
        if section == "quality":
            config["quality"][key] = parsed_value
        elif section == "recovery":
            config["recovery"][key] = parsed_value
        elif section == "retention":
            config["retention"][key] = parsed_value
    return config


def run_pipeline(config_path: str, data_path: str) -> dict[str, object]:
    config = load_config(config_path)
    findings = check_file(data_path)
    repair_recommendation = recommend_strategy(data_path)
    return {
        "quality_policy": config["quality"],
        "recovery_policy": config["recovery"],
        "retention_policy": config["retention"],
        "quality_check_passed": not findings,
        "quality_findings": findings,
        "repair_recommendation": repair_recommendation,
    }


def emit_result(result: dict[str, object], output_path: str | None) -> None:
    rendered = json.dumps(result, indent=2) + "\n"
    if output_path:
        output_file = Path(output_path)
        output_file.parent.mkdir(parents=True, exist_ok=True)
        output_file.write_text(rendered, encoding="utf-8")
    sys.stdout.write(rendered)


def main() -> None:
    if len(sys.argv) not in {3, 4}:
        raise SystemExit(
            "Usage: python3 src/run_local_quality_recovery_pipeline.py <config-path> <jsonl-path> [output-path]"
        )
    result = run_pipeline(sys.argv[1], sys.argv[2])
    output_path = sys.argv[3] if len(sys.argv) == 4 else None
    emit_result(result, output_path)


if __name__ == "__main__":
    main()
