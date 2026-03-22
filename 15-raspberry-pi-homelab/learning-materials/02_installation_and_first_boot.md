# Installation And First Boot

## Hardware Recommendations

Preferred setup:

- Raspberry Pi 4 or 5
- 4 GB RAM minimum, 8 GB preferred
- SSD preferred over microSD for long-term Docker usage
- stable power supply
- Ethernet preferred for more stable networking

## Base Operating System

Recommended starting point:

- Raspberry Pi OS Lite

Why:

- lower resource usage
- fewer unnecessary packages
- better fit for remote server-style usage

## High-Level Installation Flow

1. flash Raspberry Pi OS Lite to storage media
2. enable SSH during imaging if the tool supports it
3. set hostname and username during imaging if possible
4. boot the device
5. find its IP address
6. connect with SSH
7. update packages
8. configure timezone, locale, and host basics

## First Commands After Login

Typical initial tasks:

- update package metadata
- upgrade installed packages
- verify hostname
- verify storage capacity
- verify memory
- verify IP address

Example checks:

```bash
hostname
ip addr
df -h
free -h
uname -a
```

## Initial Hardening

Before installing services, do at least this:

- change default credentials if any exist
- disable password SSH login later if you use SSH keys
- install only required packages
- avoid exposing unnecessary ports

## Practical Advice For This Repository

Do not start by installing everything at once.

Start with:

- SSH access
- system updates
- Docker
- one small service

This keeps debugging simple.