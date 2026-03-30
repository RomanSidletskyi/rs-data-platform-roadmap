from __future__ import annotations

import json
from pathlib import Path


def load_runtime_config(config_path: Path) -> dict:
    return json.loads(config_path.read_text(encoding="utf-8"))


def build_branch_name(config: dict, change_name: str) -> str:
    return f"{config['branch_prefix']}{change_name}"


def is_protected_ref(config: dict, ref_name: str) -> bool:
    return ref_name == config["default_ref"]