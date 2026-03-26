from __future__ import annotations

import json
import os
from pathlib import Path


def main() -> None:
    output_root = Path(os.getenv("RAW_OUTPUT_ROOT", "/opt/airflow/data/platform"))
    publish_directory = output_root / "published" / "orders_daily"
    publish_directory.mkdir(parents=True, exist_ok=True)
    output_file = publish_directory / "orders_daily_2024-01-01.json"
    output_file.write_text(
        json.dumps(
            {
                "date": "2024-01-01",
                "total_orders": 2,
                "total_revenue": 214.5,
            },
            indent=2,
        ),
        encoding="utf-8",
    )


if __name__ == "__main__":
    main()