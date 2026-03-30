import json
from pathlib import Path

from src.branch_helpers import build_branch_name, is_protected_ref, load_runtime_config


def test_branch_helpers(tmp_path: Path) -> None:
    config_path = tmp_path / "runtime_config.json"
    config_path.write_text(
        json.dumps(
            {
                "catalog_name": "lab",
                "default_ref": "main",
                "branch_prefix": "dev_",
                "promotion_rule": "Only merge reviewed branch state into main",
            }
        ),
        encoding="utf-8",
    )

    config = load_runtime_config(config_path)

    assert build_branch_name(config, "price_fix") == "dev_price_fix"
    assert is_protected_ref(config, "main") is True
    assert is_protected_ref(config, "dev_price_fix") is False