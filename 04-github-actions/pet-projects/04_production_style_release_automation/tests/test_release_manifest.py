import json
import tempfile
import unittest
from pathlib import Path

from src.release_manifest import build_manifest, write_manifest


class ReleaseManifestTests(unittest.TestCase):
    def test_build_manifest(self):
        manifest = build_manifest("v1.0.0", "abc123", "prod")
        self.assertEqual(manifest["environment"], "prod")

    def test_write_manifest(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            output_path = Path(temp_dir) / "release-manifest.json"
            write_manifest(str(output_path), "v1.0.0", "abc123", "prod")
            content = json.loads(output_path.read_text(encoding="utf-8"))
            self.assertEqual(content["version"], "v1.0.0")


if __name__ == "__main__":
    unittest.main()