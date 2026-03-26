import tempfile
import unittest
from pathlib import Path

from src.validate_project import required_paths_exist


class ValidateProjectTests(unittest.TestCase):
    def test_required_paths_exist(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            (root / "src").mkdir()
            (root / "tests").mkdir()
            (root / ".github" / "workflows").mkdir(parents=True)
            self.assertTrue(required_paths_exist(temp_dir))


if __name__ == "__main__":
    unittest.main()