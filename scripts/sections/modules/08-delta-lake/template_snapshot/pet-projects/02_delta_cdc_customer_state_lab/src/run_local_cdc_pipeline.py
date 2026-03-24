from __future__ import annotations

import json
import sys
from pathlib import Path

from check_customer_cdc_keys import check_file
from preview_customer_current_state import build_current_state


def load_config(path: str) -> dict[str, object]:
    config = {
        "source": {},
        "merge": {},
        "delete_operations": [],
        "required_fields": [],
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
            if section == "merge" and subsection == "delete_operations":
                config["delete_operations"].append(value)
            elif section == "quality" and subsection == "required_fields":
                config["required_fields"].append(value)
            continue
        key, value = [part.strip() for part in stripped.split(":", 1)]
        if section == "source":
            config["source"][key] = value
        elif section == "merge":
            config["merge"][key] = value
    return config


def run_pipeline(config_path: str, data_path: str) -> dict[str, object]:
    config = load_config(config_path)
    findings = check_file(data_path)
    current_state = build_current_state(data_path)
    return {
        "source": config["source"],
        "merge": config["merge"],
        "delete_operations": config["delete_operations"],
        "required_fields": config["required_fields"],
        "cdc_check_passed": not findings,
        "cdc_findings": findings,
        "current_state_row_count": len(current_state),
        "current_state_preview": current_state,
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
            "Usage: python3 src/run_local_cdc_pipeline.py <config-path> <jsonl-path> [output-path]"
        )
    result = run_pipeline(sys.argv[1], sys.argv[2])
    output_path = sys.argv[3] if len(sys.argv) == 4 else None
    emit_result(result, output_path)


if __name__ == "__main__":
    main()
