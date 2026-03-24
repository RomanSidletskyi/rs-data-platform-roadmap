# SSH Access Cheatsheet

## Purpose

This note is a short practical reference for connecting to Raspberry Pi from the main machine.

Use it when you need to:

- remember the login flow
- connect by hostname or IP
- configure SSH keys
- save SSH config locally
- connect quickly after setup

## Base Connection Data

Current working example:

- hostname: `pi5.local`
- ip: `192.168.1.110`
- user: `rsidletskyi`
- password: store in macOS Keychain or a password manager, not in the repository

## First Login

Connect by local hostname:

```bash
ssh rsidletskyi@pi5.local
```

Connect by IP:

```bash
ssh rsidletskyi@192.168.1.110
```

At the first login:

- confirm the host fingerprint with `yes`
- enter the user password

## How To Find The Raspberry Pi IP

On Raspberry Pi:

```bash
hostname -I
ip a
ip addr show eth0
ip addr show wlan0
```

On Mac:

```bash
ping pi5.local
arp -a | grep pi5
```

## How To Access The System

Normal access methods:

1. SSH from the main machine
2. monitor and keyboard connected directly to Raspberry Pi
3. browser only for web interfaces of services

Examples of browser access to services:

```text
http://192.168.1.110:3000
http://192.168.1.110:8080
https://192.168.1.110:9443
```

Browser access is not shell access to the operating system.

## Configure SSH Key Authentication

### 1. Generate A Dedicated Key On Mac

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_pi5 -C "rsidletskyi@pi5.local" -N ""
```

Files created:

```text
~/.ssh/id_ed25519_pi5
~/.ssh/id_ed25519_pi5.pub
```

### 2. Copy The Public Key To Raspberry Pi

```bash
cat ~/.ssh/id_ed25519_pi5.pub | ssh rsidletskyi@pi5.local 'mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'
```

### 3. Test Key-Based Login

```bash
ssh -i ~/.ssh/id_ed25519_pi5 rsidletskyi@pi5.local
```

If this works, passwordless SSH is configured.

## Configure Local SSH Config

Create the file if needed:

```bash
touch ~/.ssh/config
chmod 600 ~/.ssh/config
```

Open the file:

```bash
nano ~/.ssh/config
```

Add this block:

```sshconfig
Host pi5
    HostName pi5.local
    User rsidletskyi
    IdentityFile ~/.ssh/id_ed25519_pi5
    IdentitiesOnly yes
```

Optional fallback by IP:

```sshconfig
Host pi5-ip
    HostName 192.168.1.110
    User rsidletskyi
    IdentityFile ~/.ssh/id_ed25519_pi5
    IdentitiesOnly yes
```

## How To Save In Nano

After editing `nano ~/.ssh/config`:

1. press `Ctrl + O`
2. press `Enter`
3. press `Ctrl + X`

If asked:

```text
Save modified buffer?
```

Use:

- `Y` to save
- `N` to discard changes

## Login After SSH Config

After the config is saved:

```bash
ssh pi5
```

Optional fallback:

```bash
ssh pi5-ip
```

Direct commands still work:

```bash
ssh rsidletskyi@pi5.local
ssh -i ~/.ssh/id_ed25519_pi5 rsidletskyi@192.168.1.110
```

## Verify SSH Config

```bash
ssh -G pi5 | egrep '^(hostname|user|identityfile) '
```

Expected shape:

```text
hostname pi5.local
user rsidletskyi
identityfile /Users/rsidletskyi/.ssh/id_ed25519_pi5
```

## Where To Store What

Password:

- macOS Keychain or password manager

SSH keys and SSH config:

```text
~/.ssh/id_ed25519_pi5
~/.ssh/id_ed25519_pi5.pub
~/.ssh/config
```

Public key on Raspberry Pi:

```text
~/.ssh/authorized_keys
```

## Short Version

First login:

```bash
ssh rsidletskyi@pi5.local
```

Create key:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_pi5 -C "rsidletskyi@pi5.local" -N ""
```

Copy key to Raspberry Pi:

```bash
cat ~/.ssh/id_ed25519_pi5.pub | ssh rsidletskyi@pi5.local 'mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'
```

Test key login:

```bash
ssh -i ~/.ssh/id_ed25519_pi5 rsidletskyi@pi5.local
```

After SSH config:

```bash
ssh pi5
```