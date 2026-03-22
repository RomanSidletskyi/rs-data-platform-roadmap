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
5. complete the first login
6. find its IP address
7. connect with SSH
8. update packages
9. configure timezone, locale, and host basics

## Recommended Reading Order After First Boot

After the OS boots successfully, continue with:

1. `01_first_15_minutes_on_pi.md`
2. `03_ssh_networking_and_remote_access.md`
3. `11_ssh_access_cheatsheet.md`
4. `12_scp_and_rsync_cheatsheet.md`
5. `13_vscode_remote_ssh.md`

Only after that move to Docker, storage, backup, and monitoring topics.

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
- host basics and filesystem navigation
- file transfer workflow
- only then Docker or a small host service

This keeps debugging simple.