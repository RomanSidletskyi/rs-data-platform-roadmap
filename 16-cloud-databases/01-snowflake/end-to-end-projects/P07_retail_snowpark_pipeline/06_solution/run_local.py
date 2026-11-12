"""Client-side runs with Snowpark: upload months with the File API, or process pending months from your laptop.

The DataFrame work is pushed down to Snowflake either way; only orchestration runs locally.

  python run_local.py upload                # PUT every month folder from $P07_DATA_DIR
  python run_local.py process               # same handler as the stored procedure
"""

from __future__ import annotations

import argparse
import os
import sys
from pathlib import Path

from snowflake.snowpark import Session

from retail_pipeline.pipeline import process_new_months


def session_from_env() -> Session:
    session = Session.builder.config("connection_name", os.environ.get("SNOW_CONNECTION", "p07")).create()
    session.use_role("P07_OWNER")
    session.use_warehouse("P07_WH")
    session.use_database("P07_RETAIL")
    return session


def upload(session: Session, root: Path) -> None:
    for folder in sorted(root.glob("month=*")):
        results = session.file.put(
            str(folder / "*.csv"), f"@RAW.RETAIL_STAGE/{folder.name}/", auto_compress=True, overwrite=False
        )
        print(folder.name, ", ".join(f"{r.source}: {r.status}" for r in results))


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("command", choices=["upload", "process"])
    args = parser.parse_args(argv)

    session = session_from_env()
    try:
        if args.command == "upload":
            upload(session, Path(os.environ["P07_DATA_DIR"]))
        else:
            print(process_new_months(session))
    finally:
        session.close()
    return 0


if __name__ == "__main__":
    sys.exit(main())
