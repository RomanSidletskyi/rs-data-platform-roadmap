# Quickstart - First Boot To Working SSH And Docker

This guide is the fastest practical path from unopened Raspberry Pi to a usable remote Docker host for this repository.

It assumes:

- you have a Raspberry Pi 4 or 5
- you have Raspberry Pi OS Lite available for install
- your main machine is your laptop
- your Raspberry Pi and laptop are on the same local network

## Outcome

By the end of this quickstart, you should have:

- Raspberry Pi booted and reachable on the network
- SSH login working from your laptop
- SSH key authentication configured
- a stable host alias such as `pi5`
- Docker installed and verified
- a basic runtime directory layout ready for services

## Step 1 - Flash Raspberry Pi OS Lite

Use Raspberry Pi Imager.

Recommended settings during imaging:

- OS: Raspberry Pi OS Lite
- set hostname: `pi5`
- enable SSH
- create your user
- configure Wi-Fi only if Ethernet is not available
- set locale and timezone

If Ethernet is available, prefer Ethernet for the first setup.

## Step 2 - Boot And Find The Device

Power on the Raspberry Pi and connect it to the network.

From your laptop, try to find it with one of these approaches:

- look in your router client list
- try the hostname if local name resolution works
- scan local devices if needed

Typical checks from macOS terminal:

```bash
ping pi5.local
ssh <your-user>@pi5.local
```

If hostname access does not work, connect by IP address.

## Step 3 - First SSH Login

Connect from your laptop:

```bash
ssh <your-user>@<raspberry-pi-ip>
```

After login, verify the host basics:

```bash
hostname
whoami
ip addr
df -h
free -h
uname -a
```

## Step 4 - Update The System

Run:

```bash
sudo apt update
sudo apt full-upgrade -y
sudo reboot
```

Reconnect after reboot.

## Step 5 - Create SSH Key Authentication

On your laptop, if you do not already have an SSH key:

```bash
ssh-keygen -t ed25519 -C "pi5"
```

Copy the key to the Raspberry Pi:

```bash
ssh-copy-id <your-user>@<raspberry-pi-ip>
```

Test login again:

```bash
ssh <your-user>@<raspberry-pi-ip>
```

The goal is to log in without typing the password every time.

## Step 6 - Create An SSH Host Alias On Your Laptop

Edit your laptop SSH config in `~/.ssh/config` and add an entry like:

```sshconfig
Host pi5
    HostName pi5.local
    User <your-user>
    IdentityFile ~/.ssh/id_ed25519
```

Now your login command becomes:

```bash
ssh pi5
```

This also makes `scp`, `rsync`, and VS Code Remote SSH easier.

## Step 7 - Make The Address Stable

Preferred approach:

- create a DHCP reservation for the Raspberry Pi in your router

Alternative:

- configure a static IP on the Raspberry Pi

Choose one stable approach before you start using the device heavily.

## Step 8 - Install Basic Packages

On the Raspberry Pi:

```bash
sudo apt install -y ca-certificates curl git htop tmux
```

These tools are enough for initial operations and debugging.

## Step 9 - Install Docker

Use Docker's official convenience script only if you are comfortable with it for a learning machine.

One common path is:

```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
newgrp docker
```

Verify Docker:

```bash
docker --version
docker run --rm hello-world
```

If the user group change does not apply immediately, log out and log back in.

## Step 10 - Prepare Host Directories

Create a stable layout for this repository:

```bash
sudo mkdir -p /srv/rs-data-platform/{repo,runtime,data,logs,backups,configs}
sudo chown -R $USER:$USER /srv/rs-data-platform
```

This gives you one base path for repo clone, service state, and generated files.

## Step 11 - Clone The Repository Onto The Raspberry Pi

Inside the Raspberry Pi session:

```bash
cd /srv/rs-data-platform/repo
git clone <your-repo-url>
cd rs-data-platform-roadmap
```

If the repo already exists remotely and you work mainly from the laptop, your standard flow becomes:

1. edit locally
2. commit and push
3. SSH to Raspberry Pi
4. pull changes
5. run services

## Step 12 - Container Smoke Test

Run a simple test container:

```bash
docker run --rm -p 8080:80 nginx:alpine
```

Then from your laptop, test whether the service is reachable:

```bash
curl http://<raspberry-pi-ip>:8080
```

Stop the container with `Ctrl+C` in the Raspberry Pi terminal.

## Step 13 - Optional VS Code Remote SSH

After the SSH host alias works, you can use VS Code Remote SSH to open the Raspberry Pi host directly.

Use it for:

- host-local config files
- container logs
- compose debugging

Do not confuse host-local runtime files with the git-managed source of truth.

## Step 14 - First Health Check Routine

Make sure you can run these checks on demand:

```bash
docker ps
df -h
free -h
htop
journalctl -xe --no-pager | tail -n 50
```

This is the operational baseline before you start larger services.

## Recommended Next Step Inside This Module

After this quickstart, continue with:

1. [01_first_15_minutes_on_pi.md](01_first_15_minutes_on_pi.md)
2. [03_ssh_networking_and_remote_access.md](03_ssh_networking_and_remote_access.md)
3. [11_ssh_access_cheatsheet.md](11_ssh_access_cheatsheet.md)
4. [12_scp_and_rsync_cheatsheet.md](12_scp_and_rsync_cheatsheet.md)
5. [13_vscode_remote_ssh.md](13_vscode_remote_ssh.md)
6. [04_docker_services_and_runtime_layout.md](04_docker_services_and_runtime_layout.md)

## Common Early Problems

Problem:
hostname does not resolve

Likely cause:
- local network name resolution is unreliable

Practical fix:
- connect by IP first
- add DHCP reservation
- keep using SSH host alias on the laptop

Problem:
Docker runs only with `sudo`

Likely cause:
- your user has not reloaded group membership

Practical fix:
- log out and back in
- or run `newgrp docker`

Problem:
containers are slow or unstable

Likely cause:
- weak storage or too many services at once

Practical fix:
- run one service at a time
- prefer SSD if possible
- keep stacks intentionally small