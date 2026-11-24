"""One ingestion run: check every source, land only new versions, return a summary.

Run locally:  python -m markets_ingest.run --target local --out ~/data/p11_markets
Azure:        python -m markets_ingest.run --target azure --account-url https://<account>.blob.core.windows.net
AWS:          python -m markets_ingest.run --target s3 --bucket <bucket>
"""

from __future__ import annotations

import argparse
import json
import sys
from collections.abc import Mapping
from dataclasses import dataclass, field
from datetime import date

from . import sources as S
from .landing import AzureBlobWriter, LocalWriter, S3Writer


@dataclass
class Config:
    countries: list[str] = field(default_factory=lambda: list(S.WFP_COUNTRIES))
    ecb_currencies: list[str] = field(default_factory=lambda: list(S.ECB_CURRENCIES))
    ecb_start: str = "2010-01"
    wb_start: int = 2010
    wb_end: int = date.today().year

    @classmethod
    def from_env(cls, env: Mapping[str, str]) -> "Config":
        config = cls()
        if env.get("P11_COUNTRIES"):
            config.countries = [c.strip().upper() for c in env["P11_COUNTRIES"].split(",") if c.strip()]
        unknown = sorted(set(config.countries) - set(S.WFP_COUNTRIES))
        if unknown:
            raise ValueError(f"no HDX slug configured for {unknown}; add them to sources.WFP_COUNTRIES")
        return config


def _land(writer, key: str, body: bytes, summary: dict) -> None:
    if writer.put(key, body):
        summary["landed"].append(key)
    else:
        summary["unchanged"].append(key)


def run_all(writer, config: Config, fetch: S.Fetch = S.http_get) -> dict:
    """Each source is independent: one failing source is reported and does not stop the others."""
    summary: dict = {"landed": [], "unchanged": [], "errors": []}

    for iso3 in config.countries:
        try:
            url, version = S.wfp_resource(fetch(S.HDX_PACKAGE.format(slug=S.WFP_COUNTRIES[iso3])))
            key = S.wfp_key(iso3, version)
            # Ask before downloading: an unchanged country costs one small metadata request.
            if writer.exists(key):
                summary["unchanged"].append(key)
                continue
            body = fetch(url)
            S.check_wfp_csv(body)
            _land(writer, key, body, summary)
        except Exception as error:  # noqa: BLE001 - reported per source in the summary
            summary["errors"].append(f"wfp {iso3}: {error}")

    try:
        body = fetch(S.ecb_url(config.ecb_currencies, config.ecb_start))
        S.check_ecb_csv(body)
        _land(writer, S.ecb_key(body), body, summary)
    except Exception as error:  # noqa: BLE001
        summary["errors"].append(f"ecb: {error}")

    for indicator in S.WB_INDICATORS:
        try:
            body = fetch(S.wb_url(config.countries, indicator, config.wb_start, config.wb_end))
            S.check_wb_json(body)
            _land(writer, S.wb_key(indicator, body), body, summary)
        except Exception as error:  # noqa: BLE001
            summary["errors"].append(f"worldbank {indicator}: {error}")

    return summary


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--target", choices=["local", "azure", "s3"], default="local")
    parser.add_argument("--out", help="local root directory")
    parser.add_argument("--account-url", help="https://<account>.blob.core.windows.net")
    parser.add_argument("--container", default="landing")
    parser.add_argument("--bucket")
    parser.add_argument("--prefix", default="landing/")
    parser.add_argument("--countries", help="comma-separated ISO3 codes, default: all configured")
    args = parser.parse_args(argv)

    if args.target == "local":
        if not args.out:
            parser.error("--out is required for --target local")
        writer = LocalWriter(args.out)
    elif args.target == "azure":
        writer = AzureBlobWriter(args.account_url, args.container)
    else:
        writer = S3Writer(args.bucket, args.prefix)

    summary = run_all(writer, Config.from_env({"P11_COUNTRIES": args.countries or ""}))
    print(json.dumps(summary, indent=2))
    return 1 if summary["errors"] else 0


if __name__ == "__main__":
    sys.exit(main())
