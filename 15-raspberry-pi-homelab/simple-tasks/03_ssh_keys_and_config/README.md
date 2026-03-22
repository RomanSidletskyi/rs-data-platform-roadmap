# Simple Task 03 - SSH Keys And SSH Config

## Goal

Set up passwordless SSH access and a short host alias for Raspberry Pi.

Ready answer with concrete steps and commands:

- [solution.md](solution.md)

Start with these learning materials:

- [SSH, networking, and remote access](../../learning-materials/03_ssh_networking_and_remote_access.md)
- [SSH access cheatsheet](../../learning-materials/11_ssh_access_cheatsheet.md)

## What To Practice

- generating an SSH key
- copying the public key to Raspberry Pi
- testing passwordless login
- creating `~/.ssh/config`
- connecting with `ssh pi5`

## Suggested Workflow

1. generate a dedicated SSH key on the Mac
2. copy the public key to Raspberry Pi
3. test login with `-i`
4. create a local SSH config entry
5. verify that `ssh pi5` works

## Definition Of Done

- SSH key login works
- `~/.ssh/config` exists
- you can connect with `ssh pi5`