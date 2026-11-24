import json
import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from markets_ingest import sources as S  # noqa: E402
from markets_ingest.landing import LocalWriter  # noqa: E402
from markets_ingest.run import Config, main, run_all  # noqa: E402

WFP_CSV = (S.WFP_HEADER + "\n2026-10-15,Coast,Mombasa,Mombasa,191,-4.05,39.67,cereals and tubers,Maize,51,KG,actual,Retail,KES,60,0.46\n").encode()
ECB_CSV = (S.ECB_HEADER + "\nEXR.M.USD.EUR.SP00.A,M,USD,EUR,SP00,A,2026-10,1.12\n").encode()
WB_JSON = json.dumps([{"page": 1, "pages": 1, "total": 1}, [{"countryiso3code": "KEN", "date": "2025", "value": 4.5}]]).encode()


def hdx_package(last_modified="2026-11-04T01:24:21.670860", iso3="ken"):
    return json.dumps({"success": True, "result": {"resources": [
        {"url": f"https://data.humdata.org/x/wfp_food_prices_{iso3}.csv", "last_modified": last_modified},
        {"url": f"https://data.humdata.org/x/wfp_markets_{iso3}.csv", "last_modified": last_modified},
    ]}}).encode()


class FakeHttp:
    def __init__(self, hdx_modified="2026-11-04T01:24:21.670860", broken=()):
        self.calls = []
        self.hdx_modified = hdx_modified
        self.broken = broken

    def __call__(self, url):
        self.calls.append(url)
        for marker in self.broken:
            if marker in url:
                return b"<html>blocked</html>"
        if "package_show" in url:
            return hdx_package(self.hdx_modified)
        if url.endswith(".csv"):
            return WFP_CSV
        if "data-api.ecb.europa.eu" in url:
            return ECB_CSV
        if "api.worldbank.org" in url:
            return WB_JSON
        raise AssertionError(url)


def test_wfp_resource_and_versioned_key():
    url, version = S.wfp_resource(hdx_package())
    assert url.endswith("wfp_food_prices_ken.csv")
    assert version == "20261104T012421"
    assert S.wfp_key("KEN", version) == "markets/wfp/country=KEN/version=20261104T012421/wfp_food_prices_ken.csv"
    with pytest.raises(S.SourceError):
        S.wfp_resource(json.dumps({"success": False}).encode())


def test_content_addressed_keys_are_stable():
    assert S.ecb_key(ECB_CSV) == S.ecb_key(ECB_CSV)
    assert S.ecb_key(ECB_CSV) != S.ecb_key(ECB_CSV + b"EXR.M.INR.EUR.SP00.A,M,INR,EUR,SP00,A,2026-10,107\n")
    assert S.wb_key("FP.CPI.TOTL", WB_JSON).startswith("markets/worldbank/indicator=FP.CPI.TOTL/")
    assert "M.USD+INR.EUR" in S.ecb_url(["USD", "INR"], "2010-01")
    assert "country=KEN;NGA" not in S.wb_url(["KEN", "NGA"], "SP.POP.TOTL", 2010, 2026)
    assert "/country/KEN;NGA/indicator/SP.POP.TOTL" in S.wb_url(["KEN", "NGA"], "SP.POP.TOTL", 2010, 2026)


def test_shape_checks_reject_error_pages():
    S.check_wfp_csv(WFP_CSV)
    S.check_ecb_csv(ECB_CSV)
    assert S.check_wb_json(WB_JSON) == 1
    for check in (S.check_wfp_csv, S.check_ecb_csv, S.check_wb_json):
        with pytest.raises(S.SourceError):
            check(b"<html>blocked</html>")
    with pytest.raises(S.SourceError):
        S.check_wb_json(json.dumps([{"message": [{"id": "120", "value": "Invalid value"}]}]).encode())


def test_second_run_lands_nothing_and_skips_unchanged_downloads(tmp_path):
    config = Config(countries=["KEN", "IND"])
    first = run_all(LocalWriter(tmp_path), config, FakeHttp())
    assert first["errors"] == []
    assert len(first["landed"]) == 2 + 1 + len(S.WB_INDICATORS)

    http = FakeHttp()
    second = run_all(LocalWriter(tmp_path), config, http)
    assert second["landed"] == [] and second["errors"] == []
    assert not any(url.endswith(".csv") for url in http.calls), "unchanged WFP versions must not be downloaded"

    third = run_all(LocalWriter(tmp_path), config, FakeHttp(hdx_modified="2026-12-02T03:00:00"))
    assert sorted(third["landed"]) == sorted(S.wfp_key(c, "20261202T030000") for c in ("KEN", "IND"))


def test_one_failing_source_does_not_block_the_others(tmp_path):
    summary = run_all(LocalWriter(tmp_path), Config(countries=["KEN"]), FakeHttp(broken=("data-api.ecb.europa.eu",)))
    assert [e.split(":")[0] for e in summary["errors"]] == ["ecb"]
    assert len(summary["landed"]) == 1 + len(S.WB_INDICATORS)
    assert not list(tmp_path.rglob("*.part"))


def test_config_rejects_unknown_country():
    assert Config.from_env({"P11_COUNTRIES": "ken, ind"}).countries == ["KEN", "IND"]
    with pytest.raises(ValueError):
        Config.from_env({"P11_COUNTRIES": "XYZ"})


def test_cli_requires_out_for_local(capsys):
    with pytest.raises(SystemExit):
        main(["--target", "local"])
