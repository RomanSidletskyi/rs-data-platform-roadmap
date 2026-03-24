# Monitoring Security And Operations

## Why Monitoring Matters

Even for a learning machine, services fail for predictable reasons:

- memory pressure
- disk pressure
- broken containers
- port conflicts
- misconfigured volumes

If you want to use Raspberry Pi reliably for this repository, you need operational basics.

## Minimum Things To Monitor

- CPU usage
- memory usage
- disk usage
- container status
- service logs
- host uptime

## Operational Checks

Examples of what you should be able to inspect:

- current disk usage
- memory pressure
- which containers are running
- which ports are listening
- whether a service restarts repeatedly

## Good Monitoring Progression

Stage 1:

- shell commands
- Docker logs
- systemd service status

Stage 2:

- simple dashboards or lightweight monitoring containers

Stage 3:

- central logging or metrics if your homelab grows

## Security Basics For A Learning Lab

- use SSH keys
- update the OS regularly
- expose as few ports as possible
- do not store secrets in git
- document which services are reachable from the network

## Operational Mindset

The real learning outcome is not only “can I start a container”.

It is also:

- can I restart it safely
- can I inspect failures
- can I see where files are stored
- can I explain what should be backed up

That mindset maps directly to platform engineering work.