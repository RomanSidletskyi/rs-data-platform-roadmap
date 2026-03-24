# SSH Networking And Remote Access

## Goal

You should be able to connect to the Raspberry Pi reliably from your main machine and manage it without attaching a monitor and keyboard each time.

## Core Concepts

You need to understand:

- local IP address
- hostname
- SSH authentication
- private key and public key
- port exposure
- static IP or DHCP reservation

## Recommended Access Model

Preferred model:

- Raspberry Pi connected to the same local network
- SSH enabled
- access by hostname or stable IP
- SSH key authentication from the laptop

## Typical Workflow

1. discover the device on the network
2. log in once with user credentials
3. set up SSH key authentication
4. store a named host entry in SSH config on the laptop
5. use that named host for future sessions

## SSH Config Idea On The Main Machine

A practical pattern is to define a host alias such as:

- `pi5`

Then your workflow becomes:

- one short SSH command
- simpler `scp` or `rsync`
- easier VS Code Remote SSH usage

## Static IP Versus DHCP Reservation

Preferred approach:

- router DHCP reservation if available

Alternative:

- static IP on the device

The main goal is stability, not complexity.

## VS Code Integration

Once SSH access is stable, Raspberry Pi can be used through:

- VS Code Remote SSH
- terminal SSH session
- file sync with `rsync`

For this repo, VS Code Remote SSH is useful when you want to:

- inspect logs on the host
- edit host-local config files
- check Docker compose runtime behavior

## Security Basics

- prefer SSH keys over passwords
- do not expose SSH to the public internet without understanding the risk
- do not reuse weak passwords
- keep the system updated