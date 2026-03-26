import json
from pathlib import Path

from src.helpers.runtime_config import load_runtime_config


def test_load_runtime_config_adds_environment_fields(tmp_path: Path, monkeypatch) -> None:
    config_path = tmp_path / "runtime_config.json"
    config_path.write_text(
        json.dumps(
            {
                "project_name": "orders_platform",
                "success_marker_name": "_SUCCESS.json",
                "minimum_output_files": 1,
                "default_transform_command": "python job.py",
            }
        ),
        encoding="utf-8",
    )
    monkeypatch.setenv("AIRFLOW_RUNTIME_ENV", "qa")
    resolved = load_runtime_config(config_path)
    assert resolved["runtime_env"] == "qa"
    assert resolved["transform_command"] == "python job.py"
