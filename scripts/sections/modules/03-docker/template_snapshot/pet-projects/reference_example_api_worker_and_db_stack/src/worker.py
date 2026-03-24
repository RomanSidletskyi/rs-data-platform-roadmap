import os
import time

from config_loader import load_config
from db import ensure_tables, fetch_pending_jobs, get_connection, mark_job_status, save_job_result
from processor import process_job


def run_worker_loop() -> None:
    config_path = os.getenv("APP_CONFIG_PATH", "config/app_config.json")
    poll_interval = float(os.getenv("WORKER_POLL_INTERVAL", "2"))
    config = load_config(config_path)

    while True:
        connection = get_connection()
        try:
            ensure_tables(connection, config["job_table"], config["result_table"])
            pending_jobs = fetch_pending_jobs(connection, config["job_table"])

            for job in pending_jobs:
                mark_job_status(connection, config["job_table"], job["job_id"], "running")
                result = process_job(job)
                save_job_result(connection, config["result_table"], job["job_id"], result)
                mark_job_status(connection, config["job_table"], job["job_id"], result["status"])
                print(f"processed job_id={job['job_id']}")
        finally:
            connection.close()

        time.sleep(poll_interval)


if __name__ == "__main__":
    run_worker_loop()