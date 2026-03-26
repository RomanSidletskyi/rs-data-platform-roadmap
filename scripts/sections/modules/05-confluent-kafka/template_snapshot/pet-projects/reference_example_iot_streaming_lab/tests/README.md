# Test Assets

Provided fixture:

- `fixture_expected_site_summary.json` for validating the output of `build_site_temperature_summary.py`
- `verify_site_summary.sh` for a quick fixture-driven smoke check

Suggested checks:

- event payload validation
- per-device keying expectations
- malformed event routing behavior
- summary-output verification against the fixture