import argparse
import json

from order_sink_helpers import build_dlq_record, build_upsert_record, parse_event


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("input_path")
    args = parser.parse_args()

    with open(args.input_path, "r", encoding="utf-8") as handle:
        for line in handle:
            stripped = line.strip()
            if not stripped:
                continue

            payload = parse_event(stripped)
            try:
                result = {"status": "valid", "record": build_upsert_record(payload)}
            except ValueError as exc:
                result = {
                    "status": "dlq",
                    "record": build_dlq_record(
                        payload,
                        error_type="validation_error",
                        error_reason=str(exc),
                        failed_at="2026-03-24T12:00:00Z",
                    ),
                }

            print(json.dumps(result, sort_keys=True))


if __name__ == "__main__":
    main()