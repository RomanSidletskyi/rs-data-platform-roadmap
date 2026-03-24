import tempfile
import unittest
from pathlib import Path

from src.workflow_checks import find_expected_paths, validation_report


class WorkflowChecksTests(unittest.TestCase):
    def test_find_expected_paths_returns_empty_when_structure_exists(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            (root / "src").mkdir()
            (root / "tests").mkdir()
            (root / ".github" / "workflows").mkdir(parents=True)
            self.assertEqual(find_expected_paths(temp_dir), [])

    def test_validation_report_shows_missing_paths(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            (root / "src").mkdir()
            report = validation_report(temp_dir)
            self.assertIn("missing:", report)


if __name__ == "__main__":
    unittest.main()