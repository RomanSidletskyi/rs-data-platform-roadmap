from pathlib import Path

from src.helpers.validation import build_publish_directory, validate_publish_contract, write_success_marker


def test_build_publish_directory() -> None:
    directory = build_publish_directory("/tmp/platform")
    assert str(directory).endswith("published/orders_daily")


def test_validate_publish_contract_requires_files(tmp_path: Path) -> None:
    publish_directory = tmp_path / "published" / "orders_daily"
    publish_directory.mkdir(parents=True)
    try:
        validate_publish_contract(publish_directory, 1)
    except ValueError as exc:
        assert "minimum output files" in str(exc)
    else:
        raise AssertionError("Expected validate_publish_contract to fail when no files exist")


def test_write_success_marker_creates_file(tmp_path: Path) -> None:
    publish_directory = tmp_path / "published" / "orders_daily"
    publish_directory.mkdir(parents=True)
    marker_path = write_success_marker(publish_directory, "_SUCCESS.json", "dev")
    assert marker_path.exists()
