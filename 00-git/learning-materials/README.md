# 00-git Learning Materials Index

This learning block is designed as a self-contained Git handbook for engineering work.

The goal is not only to know commands.

The goal is to understand repository state, history, integration, and recovery deeply enough to work without constant fear of breaking the repository.

## Recommended Reading Path

1. 01_git_mental_model_commits_trees_and_history.md
2. 02_repository_creation_status_and_first_commits.md
3. 03_staging_diff_and_history_inspection_cookbook.md
4. 04_branches_merges_and_integration_model.md
5. 05_remote_repositories_fetch_pull_push_and_tracking.md
6. 06_rebase_conflicts_and_history_cleanup.md
7. 07_undo_restore_reset_revert_and_safe_recovery.md
8. 08_gitignore_repo_hygiene_and_binary_risk.md
9. 09_commit_quality_pull_request_workflow_and_team_rules.md
10. 10_git_for_data_engineers_infrastructure_and_platform_repos.md
11. 11_conflict_resolution_cookbook.md
12. 12_git_incident_recovery_cookbook.md

## Reading Strategy

Use this loop:

1. read the mental model
2. run the commands in a safe practice repository
3. intentionally create a small mistake
4. recover using the documented workflow
5. solve the matching simple tasks

## Learning Philosophy

This block treats Git as a system with:

- state
- history
- integration boundaries
- recovery paths

That is why history inspection and recovery receive as much attention as basic commits.

## Target Outcome

After this block, the learner should be able to explain both the happy-path workflow and the recovery path when the happy path fails.