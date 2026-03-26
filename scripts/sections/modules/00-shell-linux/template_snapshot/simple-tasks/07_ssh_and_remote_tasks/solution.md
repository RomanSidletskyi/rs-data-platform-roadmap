# Solution

SSH config example:

    Host example-server
        HostName example.internal
        User devuser
        IdentityFile ~/.ssh/id_ed25519_example

Transfer reasoning:

- `scp` is fine for one-off file copy
- `rsync -av` is better for repeatable directory sync

Debug sequence:

    ping host
    nc -vz host 22
    ssh -v host