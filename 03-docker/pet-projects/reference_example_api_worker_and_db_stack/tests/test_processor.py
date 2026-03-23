import unittest

from src.config_loader import load_config
from src.processor import process_job, validate_job


class ProcessorTests(unittest.TestCase):
    def test_validate_job_accepts_supported_job_type(self) -> None:
        job = {"job_id": "job-1", "job_type": "aggregate_sales", "payload": {"source": "demo"}}
        validate_job(job, ["aggregate_sales", "normalize_events"])

    def test_validate_job_rejects_unknown_job_type(self) -> None:
        job = {"job_id": "job-1", "job_type": "unknown", "payload": {}}
        with self.assertRaises(ValueError):
            validate_job(job, ["aggregate_sales"])

    def test_process_job_returns_completed_result(self) -> None:
        result = process_job(
            {"job_id": "job-1", "job_type": "aggregate_sales", "payload": {"source": "demo", "window": "daily"}}
        )
        self.assertEqual(result["status"], "completed")
        self.assertEqual(result["summary"]["source"], "demo")

    def test_load_config_reads_valid_job_types(self) -> None:
        config = load_config(
            "/Users/rsidletskyi/Documents/My/Programming/rs-data-platform-roadmap/03-docker/pet-projects/reference_example_api_worker_and_db_stack/config/app_config.json"
        )
        self.assertIn("aggregate_sales", config["valid_job_types"])


if __name__ == "__main__":
    unittest.main()