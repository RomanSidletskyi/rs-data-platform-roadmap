# Solution - SSH Keys And SSH Config

This solution sets up key-based SSH access and a reusable host alias.

## 1. Generate A Dedicated SSH Key On Mac

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_pi5 -C "rsidletskyi@pi5.local" -N ""
```

## 2. Copy The Public Key To Raspberry Pi

```bash
cat ~/.ssh/id_ed25519_pi5.pub | ssh rsidletskyi@pi5.local 'mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'
```

## 3. Test Key-Based Login

```bash
ssh -i ~/.ssh/id_ed25519_pi5 rsidletskyi@pi5.local
```

## 4. Create Local SSH Config

```bash
touch ~/.ssh/config
chmod 600 ~/.ssh/config
nano ~/.ssh/config
```

Add:

```sshconfig
Host pi5
    HostName pi5.local
    User rsidletskyi
    IdentityFile ~/.ssh/id_ed25519_pi5
    IdentitiesOnly yes
```

Save in `nano` with:

1. `Ctrl + O`
2. `Enter`
3. `Ctrl + X`

## 5. Verify Config

```bash
ssh -G pi5 | egrep '^(hostname|user|identityfile) '
ssh pi5
```

## 6. Definition Of Done Check

This task is complete if:

- the key files exist in `~/.ssh/`
- Raspberry Pi has the public key in `~/.ssh/authorized_keys`
- `ssh pi5` works without entering the account password