# SSH, Remote Workflows, And File Transfer

## Why This Topic Matters

Remote shell access is one of the most common Linux workflows for engineers.

## Core Commands

    ssh user@host
    ssh host-alias
    ssh-keygen
    scp local.txt user@host:/tmp/
    rsync -av ./folder/ user@host:/srv/folder/

## Good Strategy

- use SSH config aliases for repeatable remote access
- prefer keys over passwords where possible
- use rsync for repeatable folder transfer

## SSH Config Example

    Host pi5
        HostName pi5.local
        User rsidletskyi
        IdentityFile ~/.ssh/id_ed25519_pi5

Then connect with:

    ssh pi5

## Bad Strategy

- copy long SSH commands manually every time
- ignore file permissions on private keys

## Common Failure Mode

If SSH says permissions are too open on a key file, fix them with:

    chmod 600 ~/.ssh/id_ed25519_pi5

## Key Architectural Takeaway

SSH is the normal operational bridge between your local machine and remote runtime infrastructure.