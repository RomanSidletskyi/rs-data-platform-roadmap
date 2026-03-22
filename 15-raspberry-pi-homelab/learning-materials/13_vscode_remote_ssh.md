# VS Code Remote SSH

## Purpose

This note shows how to open Raspberry Pi directly inside VS Code over SSH.

Use it when you want to:

- browse Raspberry Pi files in VS Code
- edit host-local config files
- inspect logs on the machine
- run commands in the Raspberry Pi terminal without leaving VS Code

## Prerequisites

You should already have:

- working SSH login with `ssh pi5`
- a valid local SSH config entry for `pi5`
- the VS Code extension `Remote - SSH`

## Recommended SSH Config

Your local `~/.ssh/config` should contain:

```sshconfig
Host pi5
    HostName pi5.local
    User rsidletskyi
    IdentityFile ~/.ssh/id_ed25519_pi5
    IdentitiesOnly yes
```

## Open Raspberry Pi In VS Code

1. open the command palette
2. run `Remote-SSH: Connect to Host...`
3. choose `pi5`
4. wait for VS Code to open a remote window

## Open A Folder On Raspberry Pi

Useful folders to open:

- `/srv/rs-data-platform`
- `/srv/rs-data-platform/repo`
- `/srv/rs-data-platform/configs`
- `/srv/rs-data-platform/logs`

## What You Can Do In A Remote Window

- open remote files
- edit configuration files
- use the integrated terminal on Raspberry Pi
- inspect logs
- run `git`, `python`, `ls`, `htop`, or other host commands directly on the device

## Good Practice

Prefer this split:

- local Mac workspace for repository authoring
- VS Code Remote SSH only when you need to work on Raspberry Pi runtime state

This avoids confusion between:

- files in the local repository
- files that exist only on Raspberry Pi

## Troubleshooting

If `pi5` does not appear or does not connect:

1. test in terminal first:

```bash
ssh pi5
```

2. inspect effective SSH settings:

```bash
ssh -G pi5 | egrep '^(hostname|user|identityfile) '
```

3. confirm Raspberry Pi is reachable:

```bash
ping -c 2 pi5.local
```

4. confirm the SSH key exists locally:

```bash
ls -lah ~/.ssh/id_ed25519_pi5 ~/.ssh/id_ed25519_pi5.pub
```

## Short Version

1. make sure `ssh pi5` works
2. install `Remote - SSH`
3. run `Remote-SSH: Connect to Host...`
4. choose `pi5`
5. open `/srv/rs-data-platform`