# 03 Log Triage And Incident Debugging

## Project Goal

Build a guided log triage workflow for operational incidents.

## Scenario

An application is failing intermittently. You have shell access and several logs. Your job is to extract useful evidence and reduce noise fast.

## Expected Deliverables

- command workflow or script set for log inspection
- error extraction and counting
- simple incident summary

## Starter Assets Already Provided

- `.env.example`
- `src/triage_logs.sh`
- `src/build_incident_summary.sh`
- `data/sample_incident.log`
- `tests/fixture_expected_incident_summary.txt`

## Definition Of Done

The project can turn messy logs into a smaller, interpretable incident report.