from __future__ import annotations

import json
from pathlib import Path
from typing import Any


def load_config(config_path: str) -> dict[str, Any]:
    path = Path(config_path)
    with path.open("r", encoding="utf-8") as file_handle:
        return json.load(file_handle)