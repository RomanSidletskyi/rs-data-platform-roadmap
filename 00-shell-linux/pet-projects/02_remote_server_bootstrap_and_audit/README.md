# 02 Remote Server Bootstrap And Audit

## Project Goal

Create a guided remote bootstrap and audit workflow using SSH and shell tooling.

## Scenario

You need to connect to a remote Linux host, verify access assumptions, inspect users, directories, permissions, and basic service/network state, then produce a simple audit report.

## Expected Deliverables

- SSH config guidance
- audit script or command sequence
- report of directories, ports, disk, and permissions

## Starter Assets Already Provided

- `.env.example`
- `src/render_remote_audit_plan.sh`
- `src/check_ssh_inputs.sh`
- `data/sample_remote_audit.txt`
- `tests/fixture_expected_audit_sections.txt`

## Definition Of Done

The workflow is reproducible and safe enough to run on a test host without destructive changes.