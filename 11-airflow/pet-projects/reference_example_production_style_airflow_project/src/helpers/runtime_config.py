from __future__ import annotations

import json
import os
from pathlib import Path


def load_runtime_config(config_path: Path) -> dict:
    config = json.loads(config_path.read_text(encoding="utf-8"))
    resolved = dict(config)
    resolved["runtime_env"] = os.getenv("AIRFLOW_RUNTIME_ENV", "dev")
    resolved["raw_output_root"] = os.getenv("RAW_OUTPUT_ROOT", "/opt/airflow/data/platform")
    resolved["alert_email"] = os.getenv("ALERT_EMAIL", "data-team@example.com")
    resolved["transform_command"] = os.getenv(
        "TRANSFORM_COMMAND",
        config["default_transform_command"],
    )
    return resolved