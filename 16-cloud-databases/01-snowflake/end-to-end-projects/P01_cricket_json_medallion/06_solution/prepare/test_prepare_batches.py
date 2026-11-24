"""Offline checks for prepare_batches: python -m pytest test_prepare_batches.py"""

import json
import zipfile

from prepare_batches import match_year, split_archive


def make_match(date: str, teams=("A", "B")) -> bytes:
    return json.dumps({"meta": {"revision": 1}, "info": {"dates": [date], "teams": list(teams)}, "innings": []}).encode()


def test_match_year():
    assert match_year({"dates": ["2016-08-16", "2016-08-17"]}) == "2016"
    assert match_year({}) == "unknown"


def test_split_by_year_and_range(tmp_path):
    archive = tmp_path / "odis_json.zip"
    with zipfile.ZipFile(archive, "w") as zf:
        zf.writestr("1001.json", make_match("2015-01-02"))
        zf.writestr("1002.json", make_match("2016-03-04"))
        zf.writestr("1003.json", make_match("2016-12-30"))
        zf.writestr("1004.json", make_match("2024-05-06"))
        zf.writestr("README.txt", b"not a match")

    counts = split_archive(archive, tmp_path / "batches", 2015, 2016)

    assert counts == {"2015": 1, "2016": 2}
    assert sorted(p.name for p in (tmp_path / "batches" / "year=2016").iterdir()) == ["1002.json", "1003.json"]
    assert not (tmp_path / "batches" / "year=2024").exists()
