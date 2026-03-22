# Raspberry Pi Homelab

This module introduces Raspberry Pi as a small self-hosted lab environment for data engineering practice.

The goal is not to turn Raspberry Pi into a production platform.

The goal is to learn how to use a low-cost remote machine for:

- Docker workloads
- lightweight data services
- remote development workflows
- file storage for local labs
- service operations and monitoring

## Why It Matters

Many learning roadmaps assume you can run everything on a laptop.

In practice, local machines often have constraints:

- Docker may not be available
- memory may be limited
- it may be inconvenient to keep services running all the time
- you may want a separate host for experiments

Raspberry Pi gives you a small always-on environment where you can learn:

- remote access
- service deployment
- host organization
- basic infrastructure operations
- lightweight self-hosted platform patterns

## What You Will Learn

- Raspberry Pi role in a learning data platform
- Raspberry Pi OS installation and first boot
- SSH access and network basics
- static IP and remote login workflows
- Docker on ARM devices
- service deployment with compose
- file layout, volumes, and backups
- monitoring CPU, memory, disk, and container health
- security basics for a home lab machine
- how Raspberry Pi integrates with this repository

## Learning Structure

### Learning Materials

- quickstart from first boot to Docker
- commands cheatsheet
- recovering access from old notes
- clean SSD-first rebuild from an existing Raspberry Pi
- keep current SSD OS and clean old Docker/runtime state
- shared secrets management rules
- shared local env files workflow
- Raspberry Pi fundamentals and hardware choices
- OS installation and first boot
- SSH, networking, and remote access
- Docker and service management on ARM
- storage, file layout, and backups
- monitoring, security, and operations

### Simple Tasks

- first boot and SSH login
- static IP and remote access setup
- Docker installation and first service
- storage layout and backup basics
- monitoring and service operations

### Pet Projects

- remote Docker lab node
- Airflow on Raspberry Pi
- small data platform helper node

## Related Modules

- 03-docker
- 04-github-actions
- 11-airflow
- 12-dbt
- 16-observability

## Completion Criteria

By the end of this module, you should be able to:

- install Raspberry Pi OS and complete the first boot setup
- connect to the device with SSH from your main machine
- explain the difference between code storage and runtime storage
- install Docker and run simple ARM-compatible services
- organize host directories for repo, data, configs, and logs
- monitor resource usage and inspect service health
- use Raspberry Pi as a remote runtime for this repository