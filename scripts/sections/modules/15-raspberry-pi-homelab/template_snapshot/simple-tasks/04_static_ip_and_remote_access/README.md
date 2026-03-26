# Simple Task 04 - Static IP And Remote Access

## Goal

Make Raspberry Pi reachable through a stable address or hostname.

Ready answer with concrete steps and commands:

- [solution.md](solution.md)

Start with these materials first if you have not completed SSH key setup yet:

- [SSH access cheatsheet](../../learning-materials/11_ssh_access_cheatsheet.md)
- [VS Code Remote SSH](../../learning-materials/13_vscode_remote_ssh.md)

## What To Practice

- DHCP reservation or static IP
- stable hostname usage
- SSH reconnect verification after IP stabilization
- optional VS Code Remote SSH workflow

## Suggested Workflow

1. connect once by current IP
2. configure SSH key authentication
3. add `pi5` style SSH alias on the laptop
4. configure DHCP reservation or static IP
5. verify that reconnect works with the stable host alias

## Definition Of Done

- you can connect without re-discovering the device every time
- SSH key auth works
- you have a stable remote access path

## Useful Verification Commands

```bash
ssh pi5
ping pi5.local
ssh -T pi5
```