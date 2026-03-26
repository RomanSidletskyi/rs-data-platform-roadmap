from __future__ import annotations

import json
import sys
from pathlib import Path

from check_serving_contract import check_file
from review_schema_change import review_candidate


def load_config(path: str) -> dict[str, object]:
    config = {
        "contract": {"grain": [], "required_fields": []},
        "schema_change_review": {"breaking_changes": []},
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
            if section == "contract" and subsection == "grain":
                config["contract"]["grain"].append(value)
            elif section == "contract" and subsection == "required_fields":
                config["contract"]["required_fields"].append(value)
            elif section == "schema_change_review" and subsection == "breaking_changes":
                config["schema_change_review"]["breaking_changes"].append(value)
            continue
        key, value = [part.strip() for part in stripped.split(":", 1)]
        if value.isdigit():
            parsed_value: object = int(value)
        else:
            parsed_value = value
        if section == "contract":
            config["contract"][key] = parsed_value
        elif section == "schema_change_review":
            config["schema_change_review"][key] = parsed_value
    return config


def load_preview_rows(path: str) -> list[dict[str, object]]:
    rows = []
    with open(path, "r", encoding="utf-8") as handle:
        for raw_line in handle:
            rows.append(json.loads(raw_line))
    return rows


def run_pipeline(config_path: str, data_path: str, candidate_path: str) -> dict[str, object]:
    config = load_config(config_path)
    findings = check_file(data_path)
    preview_rows = load_preview_rows(data_path)
    review = review_candidate(candidate_path)
    return {
        "contract": config["contract"],
        "schema_change_review": config["schema_change_review"],
        "serving_contract_passed": not findings,
        "serving_findings": findings,
        "preview_row_count": len(preview_rows),
        "preview_rows": preview_rows[:2],
        "schema_review": review,
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
            "Usage: python3 src/run_local_serving_pipeline.py <config-path> <jsonl-path> <candidate-json-path> [output-path]"
        )
    result = run_pipeline(sys.argv[1], sys.argv[2], sys.argv[3])
    output_path = sys.argv[4] if len(sys.argv) == 5 else None
    emit_result(result, output_path)


if __name__ == "__main__":
    main()
