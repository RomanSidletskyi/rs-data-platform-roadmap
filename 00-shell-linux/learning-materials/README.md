# 00-shell-linux Learning Materials Index

This learning block is meant to be a self-contained handbook.

The goal is not to memorize command names.

The goal is to build a working command-line model from zero to operational confidence.

## Recommended Reading Path

1. 01_shell_mental_model_and_runtime_boundaries.md
2. 02_filesystem_navigation_and_path_reasoning.md
3. 03_files_directories_and_safe_mutation.md
4. 04_reading_text_and_working_with_large_files.md
5. 05_pipes_redirection_and_command_composition.md
6. 06_grep_find_xargs_sort_uniq_cut_awk_sed_cookbook.md
7. 07_permissions_ownership_and_execution_model.md
8. 08_processes_jobs_signals_and_runtime_debugging.md
9. 09_environment_variables_shell_config_and_profiles.md
10. 10_ssh_remote_workflows_and_file_transfer.md
11. 11_network_debugging_for_engineers.md
12. 12_shell_scripting_from_basics_to_reliable_automation.md
13. 13_linux_for_data_engineers_and_platform_workflows.md
14. 14_command_line_incident_cookbook.md

## Reading Strategy

Use this sequence repeatedly:

1. read the concept and cookbook
2. run the commands manually
3. adapt them to the current repository or machine
4. solve the matching simple tasks
5. revisit the file after hitting a real failure mode

## Command Philosophy

These files are intentionally command-heavy.

They should answer practical questions such as:

- which command should I use
- what output should I expect
- what can go wrong
- what is the safer pattern
- when should I stop using shell and move to Python or another tool

## Target Outcome

After this block, the learner should be able to work comfortably in a Linux-like shell without treating every operation as an isolated trick.