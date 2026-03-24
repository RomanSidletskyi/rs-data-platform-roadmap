from __future__ import annotations

import logging
import time
from typing import Any

import requests


def fetch_data_with_retry(
    url: str,
    timeout: int = 30,
    retries: int = 3,
    delay_seconds: int = 2,
) -> Any:
    last_error: Exception | None = None

    for attempt in range(1, retries + 1):
        try:
            logging.info("Requesting API: %s | attempt %s/%s", url, attempt, retries)
            response = requests.get(url, timeout=timeout)
            response.raise_for_status()
            logging.info("API request successful with status %s", response.status_code)
            return response.json()
        except (requests.RequestException, ValueError) as exc:
            last_error = exc
            logging.warning("API request failed on attempt %s: %s", attempt, exc)
            if attempt < retries:
                time.sleep(delay_seconds)

    raise RuntimeError(f"API request failed after {retries} attempts") from last_error