import json
from pathlib import Path


def build_manifest(version: str, sha: str, environment: str) -> dict:
    return {
        "version": version,
        "sha": sha,
        "environment": environment,
    }


def write_manifest(output_path: str, version: str, sha: str, environment: str) -> None:
    manifest = build_manifest(version, sha, environment)
    Path(output_path).write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")