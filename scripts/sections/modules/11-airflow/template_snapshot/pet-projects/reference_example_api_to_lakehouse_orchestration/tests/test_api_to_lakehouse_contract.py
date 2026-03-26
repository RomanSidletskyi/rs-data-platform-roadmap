from pathlib import Path

from src.helpers.api_to_lakehouse_contract import (
    build_marker_path,
    build_payload_path,
    validate_payload,
    write_json_file,
)


def test_build_payload_path_contains_interval() -> None:
    path = build_payload_path("/tmp/raw", "orders_api", "2024-01-01")
    assert str(path).endswith("orders_api/interval=2024-01-01/payload.json")


def test_build_marker_path_uses_marker_name() -> None:
    path = build_marker_path("/tmp/raw", "orders_api", "2024-01-01", "_READY.json")
    assert str(path).endswith("orders_api/interval=2024-01-01/_READY.json")


def test_validate_payload_rejects_missing_fields() -> None:
    try:
        validate_payload([{"order_id": "1"}], 1)
    except ValueError as exc:
        assert "missing required fields" in str(exc)
    else:
        raise AssertionError("Expected validate_payload to fail for incomplete record")


def test_write_json_file_creates_output(tmp_path: Path) -> None:
    target_path = tmp_path / "payload.json"
    write_json_file(target_path, [{"ok": True}])
    assert target_path.exists()
