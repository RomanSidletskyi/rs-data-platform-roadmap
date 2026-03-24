# 00-shell-linux

This module is the operational foundation for the rest of the roadmap.

It is not a lightweight introduction to a few terminal commands.

It is a practical path from zero familiarity with the command line to confident engineering work in Linux-like environments used for:

- local development
- Docker containers
- CI runners
- remote servers
- Airflow workers
- homelab machines
- debugging and incident response

The goal is to make shell work feel normal, safe, and explainable.

## Why This Module Matters

Many later modules assume the learner can already:

- navigate file systems quickly
- inspect logs without opening an editor
- pipe commands together
- reason about permissions and processes
- debug environment variables and PATH issues
- work over SSH on remote hosts
- automate repetitive tasks safely

Without this foundation, Docker, Git, GitHub Actions, Airflow, and homelab work become much harder than they should be.

## Main Learning Goals

By the end of this module, the learner should be able to:

- explain what the shell is and where it fits in system execution
- navigate and mutate the file system safely
- use pipes, redirection, and text tools as normal workflow primitives
- inspect and control processes, jobs, ports, and services
- reason about permissions, ownership, and executability
- work with environment variables and shell configuration without guessing
- use SSH and remote file transfer as routine engineering tools
- write safe shell scripts for automation and operational tasks
- debug common Linux runtime problems using command-line tools only

## Module Structure

    00-shell-linux/
        README.md
        learning-materials/
        simple-tasks/
        pet-projects/

## Learning Philosophy

This module is intentionally cookbook-heavy.

The learner should not need to leave the repository to understand the practical command-line workflows required for the rest of the roadmap.

That means the learning block is designed to connect:

- what a command or concept is
- when it is used in real engineering work
- which safe and unsafe patterns matter
- what fails when the tool is misused

## Learning Materials

The learning-materials block follows a concept + architecture + cookbook pattern.

Topics include:

- shell mental model and execution boundaries
- filesystem navigation and safe mutation
- text inspection, pipes, and redirection
- grep, find, xargs, awk, sed, sort, uniq, cut
- permissions, ownership, and executability
- processes, jobs, signals, and runtime debugging
- environment variables, shell config, and PATH reasoning
- SSH, remote work, and file transfer
- network debugging for engineers
- shell scripting for reliable automation
- Linux as an operational substrate for data engineering
- incident-response command-line cookbook

For the full learning path, see learning-materials/README.md.

## Simple Tasks

The simple tasks focus on command-line reps rather than abstract theory.

The learner will practice:

- navigation and file creation
- text reading and output redirection
- search and extraction pipelines
- permission repair and script execution
- process and signal control
- environment and PATH debugging
- SSH and remote workflow basics
- shell scripting tasks

Each task topic contains both README.md and solution.md.

## Pet Projects

The pet projects simulate real operations work rather than toy command practice.

Guided projects include:

- local operations toolkit
- remote server bootstrap and audit toolkit
- log triage and incident debugging workflow
- shell automation for data-job operations

These projects are meant to make the learner think like an engineer who must inspect, diagnose, and stabilize real runtime environments.

## Recommended Order Inside The Module

1. understand shell runtime and paths
2. learn file mutation and text inspection
3. become comfortable with pipes and extraction tools
4. learn permissions, processes, and environment reasoning
5. move into SSH, network checks, and scripting
6. finish with incident-style command-line workflows

## Why This Comes Before Git

Git is heavily shell-driven in real engineering work.

The learner who already understands:

- file paths
- diffs as text
- process execution
- editor and environment boundaries
- SSH and remote hosts

will learn Git faster and more safely.

## Related Modules

- 00-git
- 03-docker
- 04-github-actions
- 11-airflow
- 15-raspberry-pi-homelab

## Completion Criteria

The module is complete when the learner can:

- perform normal Linux shell work without relying on GUI shortcuts
- inspect files, logs, processes, and ports confidently
- explain why a command works, not only repeat it from memory
- build small reliable shell scripts
- debug routine operational failures through the command line

## Final Note

This module should make the terminal feel like an engineering workspace, not a hostile interface.