import gzip
import json
import sys
from datetime import date, datetime, timedelta, timezone
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "dags"))

import gharchive_lib as gh  # noqa: E402

UTC = timezone.utc


def test_file_name_has_no_leading_zero_for_the_hour():
    assert gh.hour_file_name(datetime(2026, 11, 9, 5, tzinfo=UTC)) == "2026-11-09-5.json.gz"
    assert gh.source_url(datetime(2026, 11, 9, 15, 42, tzinfo=UTC)) == "https://data.gharchive.org/2026-11-09-15.json.gz"


def test_landing_key_uses_the_utc_day_of_the_hour():
    kyiv = timezone(timedelta(hours=2))
    assert gh.landing_key(datetime(2026, 11, 10, 1, 30, tzinfo=kyiv)) == "gharchive/dt=2026-11-09/2026-11-09-23.json.gz"
    assert gh.landing_key(datetime(2026, 11, 9, 0), root="landing/") == "landing/gharchive/dt=2026-11-09/2026-11-09-0.json.gz"


def test_snowflake_timestamp_and_day_hours():
    assert gh.snowflake_ts(datetime(2026, 11, 9, 7, 59, 59, tzinfo=UTC)) == "2026-11-09 07:00:00"
    hours = gh.hours_of_day(date(2026, 11, 9))
    assert len(hours) == 24 and hours[0].hour == 0 and hours[-1].hour == 23


def test_publication_status():
    assert gh.is_published(200) is True
    assert gh.is_published(404) is False
    with pytest.raises(RuntimeError):
        gh.is_published(403)


def test_landing_is_idempotent_unless_forced():
    assert gh.should_land(exists=False, force=False)
    assert not gh.should_land(exists=True, force=False)
    assert gh.should_land(exists=True, force=True)
    gh.check_size(10, 10)
    gh.check_size(None, 10)
    with pytest.raises(RuntimeError):
        gh.check_size(10, 9)


def _event(event_id, event_type, created, login="alice", payload=None):
    return json.dumps({
        "id": event_id, "type": event_type, "created_at": created,
        "actor": {"id": 1, "login": login}, "repo": {"id": 2, "name": "o/r"}, "payload": payload or {},
    })


def test_profile_finds_both_payload_eras_and_bad_lines():
    lines = [
        _event("1", "PushEvent", "2025-10-01T15:00:01Z", payload={"size": 2, "commits": []}),
        _event("2", "PushEvent", "2025-10-01T15:10:00Z", payload={"ref": "refs/heads/main"}),
        _event("3", "PullRequestEvent", "2025-10-01T15:20:00Z", "dependabot[bot]",
               {"action": "closed", "pull_request": {"merged": True}}),
        _event("4", "PullRequestEvent", "2025-10-01T16:00:00Z", payload={"action": "merged", "pull_request": {}}),
        _event("4", "PullRequestEvent", "2025-10-01T15:30:00Z", payload={"action": "opened", "pull_request": {}}),
        "{not json",
        "",
    ]
    profile = gh.profile_lines(lines, datetime(2025, 10, 1, 15, tzinfo=UTC))
    assert profile["events"] == 5
    assert profile["bad_lines"] == 1
    assert profile["duplicate_ids"] == 1
    assert profile["bot_events"] == 1
    assert profile["created_outside_hour"] == 1
    assert profile["push_events_with_size"] == 1
    assert profile["pr_events_with_merged_flag"] == 1
    assert profile["pr_actions"] == {"closed": 1, "merged": 1, "opened": 1}


def test_profile_cli_reads_a_local_file(tmp_path, capsys):
    path = tmp_path / "2026-11-09-15.json.gz"
    path.write_bytes(gzip.compress((_event("9", "WatchEvent", "2026-11-09T15:00:00Z") + "\n").encode()))
    assert gh.main(["2026-11-09T15", "--file", str(path)]) == 0
    out = json.loads(capsys.readouterr().out)
    assert out["events"] == 1 and out["types"] == {"WatchEvent": 1}
