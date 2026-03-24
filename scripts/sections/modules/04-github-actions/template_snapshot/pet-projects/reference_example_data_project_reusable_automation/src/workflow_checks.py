from pathlib import Path


def find_expected_paths(project_root: str) -> list[str]:
    root = Path(project_root)
    expected = [root / "src", root / "tests", root / ".github" / "workflows"]
    missing = [str(path.relative_to(root)) for path in expected if not path.exists()]
    return missing


def validation_report(project_root: str) -> str:
    missing = find_expected_paths(project_root)
    if missing:
        return "missing:" + ",".join(sorted(missing))
    return "ok"