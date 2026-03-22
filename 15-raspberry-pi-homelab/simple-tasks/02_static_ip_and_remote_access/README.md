# Simple Task 02 - Static IP And Remote Access

## Goal

Make Raspberry Pi reachable through a stable address or hostname.

Ready answer with concrete steps and commands:

- [solution.md](solution.md)

Start with the quickstart guide if you have not completed first login and SSH key setup yet:

- [quickstart from first boot to Docker](../../learning-materials/00_quickstart_first_boot_to_docker.md)

## What To Practice

- DHCP reservation or static IP
- SSH key setup
- SSH host alias configuration
- optional VS Code Remote SSH workflow

## Suggested Workflow

1. connect once by current IP
2. configure SSH key authentication
3. add `rpi-lab` style SSH alias on the laptop
4. configure DHCP reservation or static IP
5. verify that reconnect works with the stable host alias

## Definition Of Done

- you can connect without re-discovering the device every time
- SSH key auth works
- you have a stable remote access path

## Useful Verification Commands

```bash
ssh rpi-lab
ping rpi-lab.local
ssh -T rpi-lab
```