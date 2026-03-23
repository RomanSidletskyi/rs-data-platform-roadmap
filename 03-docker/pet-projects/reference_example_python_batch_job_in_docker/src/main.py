import json
import os

from batch_job import run_batch_job


def main() -> None:
    input_path = os.getenv("INPUT_PATH", "data/input/sales.csv")
    output_dir = os.getenv("OUTPUT_DIR", "data/output")
    config_path = os.getenv("CONFIG_PATH", "config/job_config.json")

    summary = run_batch_job(
        input_path=input_path,
        output_dir=output_dir,
        config_path=config_path,
    )
    print(json.dumps(summary, indent=2))


if __name__ == "__main__":
    main()