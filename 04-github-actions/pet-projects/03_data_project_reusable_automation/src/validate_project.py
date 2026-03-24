from pathlib import Path


def required_paths_exist(project_root: str) -> bool:
    root = Path(project_root)
    required = [root / "src", root / "tests", root / ".github" / "workflows"]
    return all(path.exists() for path in required)