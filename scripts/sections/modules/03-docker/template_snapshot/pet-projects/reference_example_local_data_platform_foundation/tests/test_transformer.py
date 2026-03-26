import unittest

from src.config_loader import load_config
from src.transformer import build_event_summary


class PlatformTransformerTests(unittest.TestCase):
    def test_build_event_summary_counts_events_by_type(self) -> None:
        rows = [
            {"event_id": "1", "event_type": "click", "event_date": "2026-03-01", "source_system": "web"},
            {"event_id": "2", "event_type": "view", "event_date": "2026-03-01", "source_system": "web"},
            {"event_id": "3", "event_type": "click", "event_date": "2026-03-02", "source_system": "mobile"},
        ]

        summary = build_event_summary(rows)
        self.assertEqual(summary[0], {"event_type": "click", "event_count": 2})
        self.assertEqual(summary[1], {"event_type": "view", "event_count": 1})

    def test_load_config_reads_expected_targets(self) -> None:
        config = load_config(
            "/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/03-docker/pet-projects/reference_example_local_data_platform_foundation/config/platform_config.json"
        )
        self.assertEqual(config["bucket_name"], "events-lab")
        self.assertEqual(config["summary_table"], "event_counts_by_type")


if __name__ == "__main__":
    unittest.main()